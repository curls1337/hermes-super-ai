import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { config } from './env.mjs';

const PY_BRIDGE = `
import json, sqlite3, sys
payload = json.loads(sys.stdin.read())
db_path = payload["db_path"]
mode = payload["mode"]
sql = payload["sql"]
params = payload.get("params", [])

conn = sqlite3.connect(db_path, timeout=10.0)
conn.row_factory = sqlite3.Row
conn.execute("PRAGMA foreign_keys = ON;")

try:
    if mode == "script":
        conn.executescript(sql)
        conn.commit()
        print(json.dumps({"ok": True}))
    elif mode == "all":
        cur = conn.execute(sql, params)
        rows = [dict(r) for r in cur.fetchall()]
        print(json.dumps({"ok": True, "rows": rows}))
    elif mode == "get":
        cur = conn.execute(sql, params)
        row = cur.fetchone()
        print(json.dumps({"ok": True, "row": dict(row) if row else None}))
    elif mode == "run":
        cur = conn.execute(sql, params)
        conn.commit()
        print(json.dumps({"ok": True, "changes": cur.rowcount, "lastInsertRowid": cur.lastrowid}))
    else:
        raise ValueError("Unsupported mode: " + mode)
finally:
    conn.close()
`;

function invokeSqlite(mode, sql, params = []) {
  const dir = path.dirname(config.databasePath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  const stdout = execFileSync('python3', ['-c', PY_BRIDGE], {
    input: JSON.stringify({
      db_path: config.databasePath,
      mode,
      sql,
      params
    }),
    encoding: 'utf8',
    maxBuffer: 10 * 1024 * 1024
  });
  return JSON.parse(stdout);
}

export function ensureDatabaseReady() {
  if (!fs.existsSync(config.databasePath) && fs.existsSync(config.schemaPath)) {
    const schema = fs.readFileSync(config.schemaPath, 'utf8');
    invokeSqlite('script', schema);
  }
}

export const db = {
  all(sql, params = []) {
    return invokeSqlite('all', sql, params).rows;
  },
  get(sql, params = []) {
    return invokeSqlite('get', sql, params).row;
  },
  run(sql, params = []) {
    return invokeSqlite('run', sql, params);
  },
  execScript(sql) {
    return invokeSqlite('script', sql);
  }
};

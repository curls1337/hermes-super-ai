import path from 'node:path';
import express from 'express';
import cors from 'cors';
import { config } from './config/env.mjs';
import { ensureDatabaseReady } from './config/db.mjs';
import { createApiRouter } from './routes/api.mjs';

export function createApp() {
  ensureDatabaseReady();

  const app = express();
  app.disable('x-powered-by');

  app.use(
    cors({
      origin: (origin, cb) => {
        if (!origin || config.corsOrigin.includes('*') || config.corsOrigin.includes(origin)) {
          return cb(null, true);
        }
        return cb(null, true); // Allow local staging simulator origins in hybrid mode
      },
      credentials: true
    })
  );

  app.use(express.json({ limit: '10mb' }));
  app.use((_req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
    next();
  });

  app.use(config.apiPrefix, createApiRouter());

  // Serve interactive simulator & static assets cleanly when run standalone
  app.use('/assets', express.static(path.join(config.projectRoot, 'assets')));
  app.use(express.static(config.projectRoot));

  app.use((err, _req, res, _next) => {
    console.error('[Hermes Bridge Error]', err);
    res.status(500).json({
      success: false,
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Terjadi kesalahan internal pada server.' }
    });
  });

  return app;
}

const isDirectRun = process.argv[1] && path.resolve(process.argv[1]) === path.resolve(new URL(import.meta.url).pathname);
if (isDirectRun) {
  const app = createApp();
  app.listen(config.port, config.host, () => {
    console.log(`⚡ Hermes Super AI Bridge running at http://${config.host}:${config.port}${config.apiPrefix}`);
  });
}

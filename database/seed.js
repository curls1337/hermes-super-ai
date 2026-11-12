/**
 * HERMES SUPER AI - DATABASE SEED SCRIPT (Universal Node.js / CommonJS)
 * Populates initial RBAC, Users, Showcase Chat Sessions, Image Generations,
 * Remotion Video Jobs, Vault Gallery, and System Settings.
 *
 * Supported drivers:
 * 1. better-sqlite3 (if installed in node_modules)
 * 2. sqlite3 CLI fallback via child_process
 */

const fs = require('node:fs');
const path = require('node:path');
const { execSync } = require('node:child_process');

const DB_PATH = process.env.DATABASE_PATH || path.join(__dirname, 'hermes_vault.db');
const SCHEMA_PATH = path.join(__dirname, 'schema.sql');

// Precomputed bcrypt hash for 'password123' (10 rounds)
const DEFAULT_PASSWORD_HASH = '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyUIXe/QLSUG6xNekd.vGqmQnWkJWb72';

const SEED_DATA = {
  roles: [
    {
      id: 'role_superadmin',
      slug: 'superadmin',
      name: 'Superadmin / System Owner',
      description: 'Full administrative access, token allocation, server bridge config, and audit logs.'
    },
    {
      id: 'role_pro',
      slug: 'pro_creator',
      name: 'Pro Creator',
      description: 'Uncapped Remotion video exports, custom dual-speaker TTS voices, ultra-res image generation.'
    },
    {
      id: 'role_consumer',
      slug: 'consumer',
      name: 'Consumer / Everyday Creator',
      description: 'Standard multimodal chat, aspect ratio selector, template video lab with watermark, hands-free voice.'
    },
    {
      id: 'role_guest',
      slug: 'guest',
      name: 'Guest / Demo Evaluator',
      description: 'Sandbox access with pre-seeded data and quick role switcher capability.'
    }
  ],

  permissions: [
    { id: 'perm_chat_stream', slug: 'chat:stream', module: 'chat', description: 'Real-time SSE Chat streaming' },
    { id: 'perm_chat_agent_switch', slug: 'chat:agent_switch', module: 'chat', description: 'Switch between specialist personas' },
    { id: 'perm_chat_web_search', slug: 'chat:web_search', module: 'chat', description: 'Toggle web search & grounding citations' },
    { id: 'perm_image_generate', slug: 'image:generate', module: 'image', description: 'Text-to-image studio generations' },
    { id: 'perm_image_hd', slug: 'image:hd_presets', module: 'image', description: 'Advanced style presets and CFG sampling controls' },
    { id: 'perm_video_render', slug: 'video:render', module: 'video', description: 'Generate storyboard video' },
    { id: 'perm_video_export_remotion', slug: 'video:export_remotion', module: 'video', description: 'Headless Remotion MP4 native render' },
    { id: 'perm_voice_duplex', slug: 'voice:duplex', module: 'voice', description: 'Full-duplex hands-free voice mode with barge-in' },
    { id: 'perm_vault_export', slug: 'vault:export', module: 'vault', description: 'Export full media vault to ZIP archive' },
    { id: 'perm_system_config', slug: 'system:config', module: 'system', description: 'Modify backend bridge URL and API token keys' }
  ],

  users: [
    {
      id: 'usr_admin_001',
      email: 'admin@hermes.ai',
      password_hash: DEFAULT_PASSWORD_HASH,
      full_name: 'Lead System Architect',
      role_id: 'role_superadmin',
      avatar_url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      quota_tokens_remaining: 1000000,
      quota_renders_remaining: 500,
      custom_backend_url: 'http://localhost:3000',
      custom_bearer_token: null
    },
    {
      id: 'usr_pro_002',
      email: 'pro@hermes.ai',
      password_hash: DEFAULT_PASSWORD_HASH,
      full_name: 'Elena Rostova (Pro Creator)',
      role_id: 'role_pro',
      avatar_url: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      quota_tokens_remaining: 500000,
      quota_renders_remaining: 100,
      custom_backend_url: null,
      custom_bearer_token: null
    },
    {
      id: 'usr_member_003',
      email: 'member@hermes.ai',
      password_hash: DEFAULT_PASSWORD_HASH,
      full_name: 'Kenji Sato (Consumer)',
      role_id: 'role_consumer',
      avatar_url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      quota_tokens_remaining: 50000,
      quota_renders_remaining: 10,
      custom_backend_url: null,
      custom_bearer_token: null
    },
    {
      id: 'usr_guest_004',
      email: 'guest@hermes.ai',
      password_hash: DEFAULT_PASSWORD_HASH,
      full_name: 'Guest Evaluator',
      role_id: 'role_guest',
      avatar_url: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      quota_tokens_remaining: 5000,
      quota_renders_remaining: 2,
      custom_backend_url: null,
      custom_bearer_token: null
    }
  ],

  chat_sessions: [
    {
      id: 'chat_sess_demo_01',
      user_id: 'usr_pro_002',
      title: 'VisionOS Spatial AI Architecture Overview',
      specialist_persona: 'tech_architect',
      is_pinned: 1,
      messages: [
        {
          id: 'msg_001',
          role: 'user',
          content: 'Bagaimana arsitektur glassmorphism VisionOS diimplementasikan pada canvas rendering Remotion?',
          web_search_enabled: 0,
          citations_json: '[]'
        },
        {
          id: 'msg_002',
          role: 'assistant',
          content: 'Implementasi VisionOS Glassmorphism pada Remotion menggabungkan CSS Backdrop Filters (`blur(40px) saturate(180%)`), layered radial specular glow pada koordinat dinamis, dan SVG FeTurbulence shader untuk efek refraksi es (Graphite Frost). Seluruh layer dirender per-frame pada timeline 60fps dengan sinkronisasi dual-speaker audio.',
          web_search_enabled: 1,
          citations_json: JSON.stringify([
            { title: 'Apple VisionOS Spatial Human Interface Guidelines', url: 'https://developer.apple.com/design/human-interface-guidelines/visionos', snippet: 'Materials, depth, and spatial lighting guidelines for translucent glass surfaces.' },
            { title: 'Remotion React Video Framework Documentation', url: 'https://www.remotion.dev/docs', snippet: 'Programmatic video creation in React with deterministic frame sequencing.' }
          ])
        }
      ]
    }
  ],

  image_generations: [
    {
      id: 'img_gen_001',
      user_id: 'usr_pro_002',
      prompt: 'A floating holographic AI sphere encased in graphite frost glass, VisionOS aesthetic, glowing refraction, studio lighting, hyperminimalist',
      negative_prompt: 'blurry, noise, low quality, oversaturated',
      aspect_ratio: '16:9',
      style_preset: 'visionos_cyber_glass',
      image_url: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=1280&q=80',
      resolution: '1280x720',
      seed: 849201
    },
    {
      id: 'img_gen_002',
      user_id: 'usr_pro_002',
      prompt: 'Minimalist glass card dashboard with neon cyan edge specular borders, floating in spatial fog',
      negative_prompt: 'dark, muddy, artifact',
      aspect_ratio: '1:1',
      style_preset: 'photorealistic',
      image_url: 'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=1024&q=80',
      resolution: '1024x1024',
      seed: 529143
    }
  ],

  video_remotion_jobs: [
    {
      id: 'job_remotion_001',
      user_id: 'usr_pro_002',
      title: 'Hermes Super AI Launch Teaser',
      script_text: 'Scene 1: Introducing Hermes Super AI. Spatial Intelligence meets Creative Freedom.\nScene 2: Multimodal Chat, Realtime Voice, and Native Remotion Video Rendering in One Unified Suite.',
      template_name: 'cinematic_spatial_glass',
      speaker_male_voice: 'echo',
      speaker_female_voice: 'shimmer',
      status: 'completed',
      progress_pct: 100,
      output_video_url: '/static/renders/hermes_launch_teaser.mp4',
      duration_sec: 15.0,
      error_message: null
    }
  ],

  vault_items: [
    {
      id: 'vlt_001',
      user_id: 'usr_pro_002',
      title: 'VisionOS Spatial AI Orb',
      media_type: 'image',
      asset_url: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=1280&q=80',
      thumbnail_url: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=300&q=80',
      metadata_json: JSON.stringify({ ratio: '16:9', prompt: 'Holographic AI sphere in graphite glass', format: 'PNG' }),
      is_favorite: 1
    },
    {
      id: 'vlt_002',
      user_id: 'usr_pro_002',
      title: 'Hermes Launch Teaser MP4',
      media_type: 'video',
      asset_url: '/static/renders/hermes_launch_teaser.mp4',
      thumbnail_url: 'https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=300&q=80',
      metadata_json: JSON.stringify({ duration: 15.0, template: 'cinematic_spatial_glass', fps: 60 }),
      is_favorite: 1
    }
  ],

  system_settings: [
    { id: 'set_001', key: 'DEFAULT_AI_MODEL', value: 'hermes-3-llama-3.1-8b', description: 'Primary agent model for chat SSE' },
    { id: 'set_002', key: 'HERMES_BRIDGE_URL', value: 'http://localhost:3000/api', description: 'Default Hermes Core Gateway Bridge endpoint' },
    { id: 'set_003', key: 'REMOTION_MAX_CONCURRENT_RENDERS', value: '2', description: 'Maximum simultaneous Chromium headless render workers' },
    { id: 'set_004', key: 'VISIONOS_DEFAULT_THEME', value: 'graphite_frost', description: 'Initial spatial glass styling variant' }
  ]
};

function generateSeedSQL() {
  const schemaSQL = fs.readFileSync(SCHEMA_PATH, 'utf8');
  const statements = [schemaSQL, '\n-- SEED DATA INSERTION\nBEGIN TRANSACTION;'];

  // Roles
  for (const r of SEED_DATA.roles) {
    statements.push(`INSERT OR REPLACE INTO roles (id, slug, name, description) VALUES ('${r.id}', '${r.slug}', '${r.name.replace(/'/g, "''")}', '${r.description.replace(/'/g, "''")}');`);
  }

  // Permissions
  for (const p of SEED_DATA.permissions) {
    statements.push(`INSERT OR REPLACE INTO permissions (id, slug, module, description) VALUES ('${p.id}', '${p.slug}', '${p.module}', '${p.description.replace(/'/g, "''")}');`);
  }

  // Role Permissions
  for (const p of SEED_DATA.permissions) {
    statements.push(`INSERT OR REPLACE INTO role_permissions (role_id, permission_id) VALUES ('role_superadmin', '${p.id}');`);
  }
  for (const p of SEED_DATA.permissions.filter(x => x.module !== 'system')) {
    statements.push(`INSERT OR REPLACE INTO role_permissions (role_id, permission_id) VALUES ('role_pro', '${p.id}');`);
  }
  for (const p of SEED_DATA.permissions.filter(x => ['chat:stream', 'chat:web_search', 'image:generate', 'voice:duplex'].includes(x.slug))) {
    statements.push(`INSERT OR REPLACE INTO role_permissions (role_id, permission_id) VALUES ('role_consumer', '${p.id}');`);
  }
  statements.push(`INSERT OR REPLACE INTO role_permissions (role_id, permission_id) VALUES ('role_guest', 'perm_chat_stream');`);

  // Users
  for (const u of SEED_DATA.users) {
    statements.push(`INSERT OR REPLACE INTO users (id, email, password_hash, full_name, role_id, avatar_url, quota_tokens_remaining, quota_renders_remaining, custom_backend_url, custom_bearer_token) VALUES ('${u.id}', '${u.email}', '${u.password_hash}', '${u.full_name}', '${u.role_id}', '${u.avatar_url}', ${u.quota_tokens_remaining}, ${u.quota_renders_remaining}, ${u.custom_backend_url ? `'${u.custom_backend_url}'` : 'NULL'}, NULL);`);
  }

  // Chat sessions & messages
  for (const s of SEED_DATA.chat_sessions) {
    statements.push(`INSERT OR REPLACE INTO chat_sessions (id, user_id, title, specialist_persona, is_pinned) VALUES ('${s.id}', '${s.user_id}', '${s.title.replace(/'/g, "''")}', '${s.specialist_persona}', ${s.is_pinned});`);
    for (const m of s.messages) {
      statements.push(`INSERT OR REPLACE INTO messages (id, session_id, role, content, web_search_enabled, citations_json) VALUES ('${m.id}', '${s.id}', '${m.role}', '${m.content.replace(/'/g, "''")}', ${m.web_search_enabled}, '${m.citations_json.replace(/'/g, "''")}');`);
    }
  }

  // Image Generations
  for (const img of SEED_DATA.image_generations) {
    statements.push(`INSERT OR REPLACE INTO image_generations (id, user_id, prompt, negative_prompt, aspect_ratio, style_preset, image_url, resolution, seed) VALUES ('${img.id}', '${img.user_id}', '${img.prompt.replace(/'/g, "''")}', '${(img.negative_prompt || '').replace(/'/g, "''")}', '${img.aspect_ratio}', '${img.style_preset}', '${img.image_url}', '${img.resolution}', ${img.seed});`);
  }

  // Remotion Jobs
  for (const v of SEED_DATA.video_remotion_jobs) {
    statements.push(`INSERT OR REPLACE INTO video_remotion_jobs (id, user_id, title, script_text, template_name, speaker_male_voice, speaker_female_voice, status, progress_pct, output_video_url, duration_sec, error_message, completed_at) VALUES ('${v.id}', '${v.user_id}', '${v.title.replace(/'/g, "''")}', '${v.script_text.replace(/'/g, "''")}', '${v.template_name}', '${v.speaker_male_voice}', '${v.speaker_female_voice}', '${v.status}', ${v.progress_pct}, '${v.output_video_url}', ${v.duration_sec}, NULL, CURRENT_TIMESTAMP);`);
  }

  // Vault Items
  for (const vlt of SEED_DATA.vault_items) {
    statements.push(`INSERT OR REPLACE INTO vault_items (id, user_id, title, media_type, asset_url, thumbnail_url, metadata_json, is_favorite) VALUES ('${vlt.id}', '${vlt.user_id}', '${vlt.title.replace(/'/g, "''")}', '${vlt.media_type}', '${vlt.asset_url}', '${vlt.thumbnail_url}', '${vlt.metadata_json.replace(/'/g, "''")}', ${vlt.is_favorite});`);
  }

  // System Settings
  for (const s of SEED_DATA.system_settings) {
    statements.push(`INSERT OR REPLACE INTO system_settings (id, key, value, description) VALUES ('${s.id}', '${s.key}', '${s.value.replace(/'/g, "''")}', '${s.description.replace(/'/g, "''")}');`);
  }

  statements.push('COMMIT;');
  return statements.join('\n');
}

function runSeed() {
  console.log('⚡ Initializing Hermes Super AI Database Seed...');
  const sql = generateSeedSQL();

  try {
    const Database = require('better-sqlite3');
    const db = new Database(DB_PATH);
    db.exec(sql);
    db.close();
    console.log(`✅ Database seeded successfully via better-sqlite3 at: ${DB_PATH}`);
    return;
  } catch (_err) {
    const tempSqlPath = path.join(__dirname, 'temp_seed.sql');
    fs.writeFileSync(tempSqlPath, sql, 'utf8');
    try {
      // Execute multi-statement SQL script using python3 executescript
      execSync(`python3 -c "import sqlite3, sys; conn = sqlite3.connect(sys.argv[1]); conn.executescript(open(sys.argv[2], 'r').read()); conn.commit(); conn.close()" "${DB_PATH}" "${tempSqlPath}"`);
      fs.unlinkSync(tempSqlPath);
      console.log(`✅ Database seeded successfully via SQLite executescript at: ${DB_PATH}`);
    } catch (cliErr) {
      if (fs.existsSync(tempSqlPath)) fs.unlinkSync(tempSqlPath);
      console.error('❌ Failed to run SQLite seed:', cliErr.message);
      process.exit(1);
    }
  }
}

if (require.main === module) {
  runSeed();
}

module.exports = {
  SEED_DATA,
  generateSeedSQL,
  runSeed
};

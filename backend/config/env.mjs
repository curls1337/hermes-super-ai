import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { fileURLToPath } from 'node:url';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, '../..');

const envPath = path.join(projectRoot, '.env');
if (fs.existsSync(envPath)) {
  dotenv.config({ path: envPath });
}

const nodeEnv = process.env.NODE_ENV || 'development';
const rawJwtSecret = process.env.JWT_SECRET || '';
const isPlaceholderSecret = !rawJwtSecret || rawJwtSecret.includes('replace_with_high_entropy_secret');

if (nodeEnv === 'production' && isPlaceholderSecret) {
  throw new Error('FATAL: JWT_SECRET must be set to a high-entropy secret in production.');
}

const jwtSecret = isPlaceholderSecret
  ? crypto.createHash('sha256').update(`hermes-dev-secret-${projectRoot}`).digest('hex')
  : rawJwtSecret;

const encryptionSeed = process.env.SESSION_SECRET || jwtSecret;
const encryptionKey = crypto.createHash('sha256').update(encryptionSeed).digest();

export const config = {
  nodeEnv,
  port: Number(process.env.PORT || 3000),
  host: process.env.HOST || '0.0.0.0',
  apiPrefix: process.env.API_PREFIX || '/api/v1',
  corsOrigin: (process.env.CORS_ORIGIN || 'http://localhost:3000,http://localhost:5173,https://webui.5nod.com')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean),
  databasePath: path.resolve(projectRoot, process.env.DATABASE_PATH || './database/hermes_vault.db'),
  schemaPath: path.join(projectRoot, 'database', 'schema.sql'),
  jwtSecret,
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '1d',
  encryptionKey,
  hermesApiEndpoint: process.env.HERMES_API_ENDPOINT || 'http://127.0.0.1:8642',
  hermesApiSecretToken: process.env.HERMES_API_SECRET_TOKEN || '',
  defaultChatModel: process.env.DEFAULT_CHAT_MODEL || 'hermes-3-llama-3.1-8b',
  enableDemoRoleSwitcher: String(process.env.ENABLE_DEMO_ROLE_SWITCHER ?? 'true').toLowerCase() === 'true',
  enableWebSearch: String(process.env.ENABLE_WEB_SEARCH ?? 'true').toLowerCase() === 'true',
  enableVideoRemotion: String(process.env.ENABLE_VIDEO_REMOTION ?? 'true').toLowerCase() === 'true',
  enableVoiceMode: String(process.env.ENABLE_VOICE_MODE ?? 'true').toLowerCase() === 'true',
  ttsDefaultVoiceMale: process.env.TTS_DEFAULT_VOICE_MALE || 'echo',
  ttsDefaultVoiceFemale: process.env.TTS_DEFAULT_VOICE_FEMALE || 'shimmer',
  vadSilenceTimeoutMs: Number(process.env.VAD_SILENCE_TIMEOUT_MS || 750),
  outputMediaDir: path.resolve(projectRoot, process.env.OUTPUT_MEDIA_DIR || './storage/media'),
  projectRoot
};

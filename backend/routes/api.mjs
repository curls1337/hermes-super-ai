import crypto from 'node:crypto';
import express from 'express';
import { config } from '../config/env.mjs';
import { SPECIALIST_AGENTS } from '../domain/entities/rbac.mjs';
import {
  requireAuth,
  requirePermission,
  requireRole,
  roleRateLimiter
} from '../middlewares/auth.mjs';
import {
  deleteVaultUseCase,
  demoSwitchUseCase,
  generateImageUseCase,
  getSystemSettingsUseCase,
  getVideoStatusUseCase,
  listChatSessionsUseCase,
  listVaultUseCase,
  loginUseCase,
  logoutUseCase,
  renderVideoUseCase,
  streamChatUseCase,
  updateSystemSettingsUseCase
} from '../application/useCases.mjs';

export function createApiRouter() {
  const router = express.Router();

  router.get('/health', (_req, res) => {
    res.json({
      success: true,
      data: {
        status: 'healthy',
        service: 'hermes-super-ai-bridge',
        mode: 'hybrid',
        version: '1.0.0',
        demoRoleSwitcher: config.enableDemoRoleSwitcher,
        timestamp: new Date().toISOString()
      }
    });
  });

  router.post('/auth/login', async (req, res) => {
    const result = await loginUseCase({
      email: req.body?.email,
      password: req.body?.password,
      reqMeta: { ip: req.ip, userAgent: req.headers['user-agent'] }
    });
    if (result.error) {
      return res.status(result.status).json({ success: false, error: result.error });
    }
    return res.json({ success: true, data: result.data });
  });

  router.post('/auth/demo-switch', (req, res) => {
    const result = demoSwitchUseCase({
      roleSlug: req.body?.roleSlug || req.body?.targetRole,
      reqMeta: { ip: req.ip, userAgent: req.headers['user-agent'] }
    });
    if (result.error) {
      return res.status(result.status).json({ success: false, error: result.error });
    }
    return res.json({ success: true, data: result.data });
  });

  router.get('/auth/me', requireAuth, (req, res) => {
    res.json({ success: true, data: { user: req.user, permissions: req.user.permissions } });
  });

  router.post('/auth/logout', requireAuth, (req, res) => {
    const data = logoutUseCase(req.authToken);
    res.json({ success: true, data });
  });

  router.get('/agents', requireAuth, (req, res) => {
    const canSwitch = req.user.policy.canSwitchAgents;
    res.json({
      success: true,
      data: SPECIALIST_AGENTS.map((a, idx) => ({
        ...a,
        locked: !canSwitch && idx > 0
      }))
    });
  });

  router.get('/chat/sessions', requireAuth, (req, res) => {
    const data = listChatSessionsUseCase(req.user.id);
    res.json({ success: true, data });
  });

  router.post('/chat/stream', requireAuth, roleRateLimiter, requirePermission('chat:stream'), async (req, res) => {
    res.setHeader('Content-Type', 'text/event-stream; charset=utf-8');
    res.setHeader('Cache-Control', 'no-cache, no-transform');
    res.setHeader('Connection', 'keep-alive');
    res.flushHeaders?.();

    const abortController = new AbortController();
    req.on('close', () => abortController.abort());

    const writeEvent = (event, data) => {
      if (abortController.signal.aborted) return;
      res.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
    };

    try {
      await streamChatUseCase({
        user: req.user,
        body: req.body,
        writeEvent,
        signal: abortController.signal
      });
    } catch (err) {
      writeEvent('error', { message: err.message || 'Streaming error' });
    } finally {
      if (!res.writableEnded) res.end();
    }
  });

  router.post('/image/generate', requireAuth, roleRateLimiter, requirePermission('image:generate'), (req, res) => {
    const result = generateImageUseCase({ user: req.user, body: req.body });
    if (result.error) {
      return res.status(result.status).json({ success: false, error: result.error });
    }
    return res.status(result.status).json({ success: true, data: result.data });
  });

  router.get('/image/preview/:file', (req, res) => {
    const ratio = String(req.query.ratio || '1:1');
    const seed = Number(req.query.seed || 1024);
    const dims = ratio === '16:9' ? [1280, 720] : ratio === '9:16' ? [720, 1280] : [1024, 1024];
    const [w, h] = dims;
    const hue1 = seed % 360;
    const hue2 = (seed + 75) % 360;
    res.setHeader('Content-Type', 'image/svg+xml; charset=utf-8');
    res.send(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${w} ${h}" width="${w}" height="${h}">
      <defs>
        <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stop-color="hsl(${hue1}, 55%, 12%)"/>
          <stop offset="50%" stop-color="#090D16"/>
          <stop offset="100%" stop-color="hsl(${hue2}, 65%, 22%)"/>
        </linearGradient>
        <radialGradient id="orb" cx="50%" cy="45%" r="42%">
          <stop offset="0%" stop-color="rgba(255,255,255,0.85)"/>
          <stop offset="45%" stop-color="hsla(${hue1}, 90%, 62%, 0.55)"/>
          <stop offset="100%" stop-color="transparent"/>
        </radialGradient>
      </defs>
      <rect width="${w}" height="${h}" fill="url(#bg)"/>
      <circle cx="${w * 0.5}" cy="${h * 0.46}" r="${Math.min(w, h) * 0.34}" fill="url(#orb)"/>
      <rect x="${w * 0.14}" y="${h * 0.72}" width="${w * 0.72}" height="${h * 0.12}" rx="28" fill="rgba(255,255,255,0.08)" stroke="rgba(255,255,255,0.28)" stroke-width="2"/>
      <text x="${w * 0.5}" y="${h * 0.79}" text-anchor="middle" fill="#F8FAFC" font-family="system-ui,sans-serif" font-size="${Math.round(Math.min(w, h) * 0.032)}" font-weight="600">HERMES VISIONOS STUDIO • SEED #${seed}</text>
    </svg>`);
  });

  router.post('/video/render', requireAuth, roleRateLimiter, requirePermission('video:render'), (req, res) => {
    const result = renderVideoUseCase({ user: req.user, body: req.body });
    if (result.error) {
      return res.status(result.status).json({ success: false, error: result.error });
    }
    return res.status(result.status).json({ success: true, data: result.data });
  });

  router.get('/video/status/:id', requireAuth, (req, res) => {
    const result = getVideoStatusUseCase({ user: req.user, jobId: req.params.id });
    if (result.error) {
      return res.status(result.status).json({ success: false, error: result.error });
    }
    return res.json({ success: true, data: result.data });
  });

  router.post('/voice/session', requireAuth, roleRateLimiter, requirePermission('voice:duplex'), (req, res) => {
    res.status(201).json({
      success: true,
      data: {
        voiceSessionId: `vox_${crypto.randomUUID()}`,
        agentPersona: req.body?.agentPersona || 'general',
        vadConfig: {
          silenceTimeoutMs: Number(req.body?.vadTimeoutMs || config.vadSilenceTimeoutMs),
          bargeInEnabled: true
        }
      }
    });
  });

  router.get('/vault/items', requireAuth, (req, res) => {
    const data = listVaultUseCase({ user: req.user, query: req.query });
    res.json({ success: true, data });
  });

  router.delete('/vault/items/:id', requireAuth, (req, res) => {
    const result = deleteVaultUseCase({ user: req.user, itemId: req.params.id });
    if (result.error) {
      return res.status(result.status).json({ success: false, error: result.error });
    }
    return res.json({ success: true, data: result.data });
  });

  router.get('/system/settings', requireAuth, requireRole(['superadmin', 'pro_creator']), (req, res) => {
    const data = getSystemSettingsUseCase({ user: req.user });
    res.json({ success: true, data });
  });

  router.put('/system/settings', requireAuth, requireRole(['superadmin', 'pro_creator']), (req, res) => {
    const result = updateSystemSettingsUseCase({ user: req.user, body: req.body });
    if (result.error) {
      return res.status(result.status).json({ success: false, error: result.error });
    }
    return res.json({ success: true, data: result.data });
  });

  return router;
}

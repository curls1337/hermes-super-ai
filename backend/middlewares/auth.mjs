import jwt from 'jsonwebtoken';
import crypto from 'node:crypto';
import { config } from '../config/env.mjs';
import { db } from '../config/db.mjs';
import { getRolePolicy } from '../domain/entities/rbac.mjs';

const rateBuckets = new Map();

export function hashToken(rawToken) {
  return crypto.createHash('sha256').update(String(rawToken)).digest('hex');
}

export function extractToken(req) {
  const authHeader = req.headers.authorization || '';
  if (authHeader.startsWith('Bearer ')) {
    return authHeader.slice(7).trim();
  }
  const cookieHeader = req.headers.cookie || '';
  const match = cookieHeader.match(/(?:^|;\s*)hermes_token=([^;]+)/);
  if (match) {
    return decodeURIComponent(match[1]);
  }
  return null;
}

export function requireAuth(req, res, next) {
  const token = extractToken(req);
  if (!token) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Bearer token atau session diperlukan.' }
    });
  }

  try {
    const decoded = jwt.verify(token, config.jwtSecret);
    const user = db.get(
      `SELECT u.id, u.email, u.full_name, u.avatar_url, u.quota_tokens_remaining,
              u.quota_renders_remaining, u.custom_backend_url, u.is_active,
              r.slug AS role_slug, r.name AS role_name
       FROM users u
       JOIN roles r ON r.id = u.role_id
       WHERE u.id = ?`,
      [decoded.sub]
    );

    if (!user || !user.is_active) {
      return res.status(401).json({
        success: false,
        error: { code: 'USER_INACTIVE', message: 'Akun tidak ditemukan atau tidak aktif.' }
      });
    }

    const perms = db.all(
      `SELECT p.slug
       FROM role_permissions rp
       JOIN permissions p ON p.id = rp.permission_id
       JOIN roles r ON r.id = rp.role_id
       WHERE r.slug = ?`,
      [user.role_slug]
    ).map((r) => r.slug);

    req.user = {
      id: user.id,
      email: user.email,
      fullName: user.full_name,
      avatarUrl: user.avatar_url,
      roleSlug: user.role_slug,
      roleName: user.role_name,
      quotaTokensRemaining: user.quota_tokens_remaining,
      quotaRendersRemaining: user.quota_renders_remaining,
      customBackendUrl: user.custom_backend_url,
      permissions: perms,
      isDemo: Boolean(decoded.isDemo),
      policy: getRolePolicy(user.role_slug)
    };
    req.authToken = token;
    return next();
  } catch (err) {
    return res.status(401).json({
      success: false,
      error: { code: 'INVALID_TOKEN', message: 'Sesi atau token tidak valid/kedaluwarsa.' }
    });
  }
}

export function requireRole(allowedRoles) {
  return (req, res, next) => {
    if (!req.user || !allowedRoles.includes(req.user.roleSlug)) {
      return res.status(403).json({
        success: false,
        error: {
          code: 'FORBIDDEN_ROLE',
          message: `Akses ditolak. Membutuhkan role: ${allowedRoles.join(', ')}`,
          required: allowedRoles
        }
      });
    }
    return next();
  };
}

export function requirePermission(permissionSlug) {
  return (req, res, next) => {
    if (!req.user || !Array.isArray(req.user.permissions) || !req.user.permissions.includes(permissionSlug)) {
      return res.status(403).json({
        success: false,
        error: {
          code: 'FORBIDDEN_PERMISSION',
          message: `Hak izin '${permissionSlug}' tidak dimiliki oleh role '${req.user?.roleSlug || 'unknown'}'.`,
          requiredPermission: permissionSlug
        }
      });
    }
    return next();
  };
}

export function roleRateLimiter(req, res, next) {
  const key = req.user ? `${req.user.id}:${req.user.roleSlug}` : req.ip;
  const limit = req.user ? getRolePolicy(req.user.roleSlug).rateLimitPerMin : 30;
  const now = Date.now();
  const windowMs = 60 * 1000;
  let bucket = rateBuckets.get(key);
  if (!bucket || now - bucket.start > windowMs) {
    bucket = { start: now, count: 0 };
  }
  bucket.count += 1;
  rateBuckets.set(key, bucket);

  if (bucket.count > limit) {
    return res.status(429).json({
      success: false,
      error: { code: 'RATE_LIMIT_EXCEEDED', message: `Batas ${limit} request/menit tercapai untuk tier ini.` }
    });
  }
  return next();
}

-- ============================================================================
-- HERMES SUPER AI - DATABASE SCHEMA DDL (SQLite / SQLCipher Compatible)
-- Project Slug: hermes-super-ai
-- Specification: BRD 1.0 & PRD 1.0.0 (VisionOS Spatial Glass Architecture)
-- ============================================================================

PRAGMA foreign_keys = ON;

-- ----------------------------------------------------------------------------
-- 1. ROLES & PERMISSIONS (RBAC)
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS roles (
    id TEXT PRIMARY KEY,                       -- e.g. 'role_superadmin', 'role_pro', 'role_consumer', 'role_guest'
    slug TEXT NOT NULL UNIQUE,                 -- e.g. 'superadmin', 'pro_creator', 'consumer', 'guest'
    name TEXT NOT NULL,                        -- e.g. 'Superadmin / System Owner', 'Pro Creator', etc.
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS permissions (
    id TEXT PRIMARY KEY,                       -- e.g. 'perm_chat_stream', 'perm_remotion_export_4k'
    slug TEXT NOT NULL UNIQUE,                 -- e.g. 'chat:stream', 'image:generate_hd', 'video:export_remotion'
    module TEXT NOT NULL,                      -- e.g. 'chat', 'image', 'video', 'voice', 'vault', 'system'
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id TEXT NOT NULL,
    permission_id TEXT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 2. USERS & AUTHENTICATION SESSIONS
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,                       -- UUID v4
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,               -- Argon2id or bcrypt hash
    full_name TEXT NOT NULL,
    role_id TEXT NOT NULL,
    avatar_url TEXT,
    quota_tokens_remaining INTEGER DEFAULT 100000,
    quota_renders_remaining INTEGER DEFAULT 5,
    custom_backend_url TEXT,                   -- Optional user-defined custom Hermes bridge
    custom_bearer_token TEXT,                  -- Optional encrypted user custom bearer token
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,                       -- UUID v4
    user_id TEXT NOT NULL,
    token_hash TEXT NOT NULL UNIQUE,           -- SHA-256 hash of refresh / session token
    ip_address TEXT,
    user_agent TEXT,
    expires_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 3. MULTIMODAL CHAT SESSIONS & MESSAGES
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS chat_sessions (
    id TEXT PRIMARY KEY,                       -- UUID v4
    user_id TEXT NOT NULL,
    title TEXT NOT NULL,
    specialist_persona TEXT NOT NULL DEFAULT 'general', -- 'general', 'business_analyst', 'tech_architect', 'creative_director', 'financial_researcher'
    is_pinned INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS messages (
    id TEXT PRIMARY KEY,                       -- UUID v4
    session_id TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
    content TEXT NOT NULL,
    web_search_enabled INTEGER DEFAULT 0,
    citations_json TEXT,                       -- JSON array: [{"title": "...", "url": "...", "snippet": "..."}]
    token_count INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS attachments (
    id TEXT PRIMARY KEY,                       -- UUID v4
    message_id TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_type TEXT NOT NULL,                   -- e.g. 'image/png', 'application/pdf'
    file_size_bytes INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 4. IMAGE STUDIO GENERATIONS
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS image_generations (
    id TEXT PRIMARY KEY,                       -- UUID v4
    user_id TEXT NOT NULL,
    prompt TEXT NOT NULL,
    negative_prompt TEXT,
    aspect_ratio TEXT NOT NULL DEFAULT '1:1',  -- '1:1', '16:9', '9:16', '4:5'
    style_preset TEXT NOT NULL DEFAULT 'visionos_cyber_glass', -- 'photorealistic', 'spatial_3d', 'anime', 'visionos_cyber_glass'
    image_url TEXT NOT NULL,
    resolution TEXT NOT NULL DEFAULT '1024x1024',
    seed INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 5. VIDEO LAB & REMOTION JOBS
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS video_remotion_jobs (
    id TEXT PRIMARY KEY,                       -- UUID v4
    user_id TEXT NOT NULL,
    title TEXT NOT NULL,
    script_text TEXT NOT NULL,
    template_name TEXT NOT NULL DEFAULT 'cinematic_spatial_glass', -- 'cinematic_spatial_glass', 'product_showcase_glass', 'social_reels', 'metric_counter'
    speaker_male_voice TEXT DEFAULT 'echo',    -- e.g. 'alloy', 'echo', 'onyx'
    speaker_female_voice TEXT DEFAULT 'shimmer', -- e.g. 'shimmer', 'fable', 'nova'
    status TEXT NOT NULL DEFAULT 'queued' CHECK (status IN ('queued', 'synthesizing_audio', 'rendering_frames', 'encoding_mp4', 'completed', 'failed')),
    progress_pct INTEGER DEFAULT 0,
    output_video_url TEXT,                     -- Final MP4 URL
    duration_sec REAL DEFAULT 15.0,
    error_message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 6. UNIFIED VAULT / GALLERY & BOOKMARKS
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS vault_items (
    id TEXT PRIMARY KEY,                       -- UUID v4
    user_id TEXT NOT NULL,
    title TEXT NOT NULL,
    media_type TEXT NOT NULL CHECK (media_type IN ('image', 'video', 'audio', 'chat', 'note')),
    asset_url TEXT NOT NULL,
    thumbnail_url TEXT,
    metadata_json TEXT,                        -- JSON string with prompt, model, resolution, tags
    is_favorite INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 7. SYSTEM SETTINGS & RUNTIME CONFIG
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS system_settings (
    id TEXT PRIMARY KEY,
    key TEXT NOT NULL UNIQUE,
    value TEXT NOT NULL,
    description TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 8. PERFORMANCE INDEXES
-- ----------------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_users_role ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_token ON sessions(token_hash);
CREATE INDEX IF NOT EXISTS idx_chat_sessions_user ON chat_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_messages_session ON messages(session_id);
CREATE INDEX IF NOT EXISTS idx_attachments_msg ON attachments(message_id);
CREATE INDEX IF NOT EXISTS idx_image_gen_user ON image_generations(user_id);
CREATE INDEX IF NOT EXISTS idx_video_jobs_user ON video_remotion_jobs(user_id);
CREATE INDEX IF NOT EXISTS idx_video_jobs_status ON video_remotion_jobs(status);
CREATE INDEX IF NOT EXISTS idx_vault_user_media ON vault_items(user_id, media_type);
CREATE INDEX IF NOT EXISTS idx_vault_fav ON vault_items(user_id, is_favorite);

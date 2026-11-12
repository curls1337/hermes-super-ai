# ARCHITECTURE SPECIFICATION — HERMES SUPER AI

**Versi Dokumen:** 1.0.0  
**Tanggal:** 12 November 2026  
**Slug Proyek:** `hermes-super-ai`  
**Mode Proyek:** Mode 3 — Hybrid (Full-Stack Production Ready + Interactive Consumer Demo Mode)  
**Tema Desain:** VisionOS White / Graphite Frost (Apple Spatial Glass)  
**Penyusun:** Solution Architect (`team-architect`)  

---

## 1. Ringkasan Eksekutif & Tujuan Arsitektur

**Hermes Super AI** adalah platform asisten AI multimodal dan studio kreasi generatif terpadu (Chat AI + Web Search Grounding, Image Studio, Remotion Video Lab Dual-Speaker, Hands-free Voice Mode, dan Unified Media Vault). Sistem ini dirancang untuk beroperasi dalam **Mode Hybrid**:
1. **Production Full-Stack Mode:** Menggunakan autentikasi JWT + Session tracking, otorisasi RBAC ketat berbasis database relasional, pemrosesan SSE streaming ke Hermes Core Gateway, dan rendering video MP4 headless melalui Remotion + Dual-Speaker TTS.
2. **Consumer Demo & Interactive Staging Simulator Mode:** Menyediakan pengalaman evaluasi instan di browser (`/staging/hermes-super-ai/`) dalam frame mobile interaktif lengkap dengan **Floating Quick Role Switcher Pill** (`Superadmin`, `Pro Creator`, `Consumer`, `Guest`) serta *pre-seeded showcases* dari `database/seed.js`.

Arsitektur menerapkan prinsip **Clean Architecture (Dependency Rule)**: seluruh aturan bisnis inti (*Entities & Use Cases*) terisolasi dari framework HTTP, driver database, dan provider AI eksternal sehingga mudah diuji, di-swap, dan di-scale.

---

## 2. Tech Stack Eksplisit

| Layer / Komponen | Teknologi Terpilih | Alasan & Peran Arsitektural |
| :--- | :--- | :--- |
| **Bahasa Pemrograman** | **JavaScript (ES2024 / Node.js 22 LTS)** & **Dart (Flutter 3.x)** | Ekosistem unified untuk Backend Bridge + Remotion React Engine (Node.js) serta kompilasi Mobile lintas-platform `.ipa`/`.apk` (Flutter). |
| **Backend Framework** | **Node.js + Express.js (ES Modules)** | Ringan, dukungan native untuk **Server-Sent Events (SSE)** streaming berlatensi rendah (TTFT ≤ 650 ms), serta integrasi langsung ke `@remotion/renderer`. |
| **Frontend Web / Simulator** | **React 18 + Vite + Tailwind CSS + `@remotion/player`** | Antarmuka VisionOS White / Graphite Frost (`backdrop-blur`, specular borders) dan preview timeline video 60fps real-time di browser. |
| **Mobile Cross-Platform** | **Flutter (Material 3 + Cupertino Spatial Glass)** | Satu codebase (`mobile/lib/`) untuk membangun biner iOS `.ipa` (sideload) dan Android `.apk` via **GitHub Actions Zero-Local-Build**. |
| **Database & Persistence** | **SQLite / SQLCipher (`better-sqlite3` / `sqlite3` CLI)** | Zero-config embedded database dengan dukungan ACID, Foreign Key ketat (`PRAGMA foreign_keys = ON`), dan portabilitas tinggi. Siap migrasi ke PostgreSQL 16 via Repository Interface. |
| **Audio & Video Pipeline** | **Remotion (`@remotion/renderer`) + Dual-Speaker TTS + Web Audio VAD** | Komposisi video React headless menjadi MP4 H.264 dengan audio dua pembicara (`echo`/`shimmer` atau Edge TTS `ArdiNeural`/`GadisNeural`). |
| **CI/CD Mobile Factory** | **GitHub Actions (`ubuntu-latest` + `macos-latest`)** | Kompilasi `.apk` dan unsigned `.ipa` (`xcodebuild CODE_SIGNING_ALLOWED=NO`) otomatis ke **GitHub Releases** tanpa instalasi SDK di server Linux lokal. |

---

## 3. Struktur Folder Multi-Layer (Clean Architecture)

```text
/home/devcurl/workspace-webui/hermes-super-ai/
├── ARCHITECTURE_SPEC.md           # Spesifikasi arsitektur sistem, DDL, API & Security
├── BRD_PRD.md                     # Business Requirements & RBAC Matrix
├── PRD_AC_SPEC.md                 # Product Requirements & Gherkin Acceptance Criteria
├── .env.example                   # Template variabel lingkungan terstandarisasi
├── .github/
│   └── workflows/
│       └── build-mobile.yml       # Pipeline GitHub Actions CI/CD (.ipa & .apk -> Releases)
├── database/
│   ├── schema.sql                 # DDL Relasional Lengkap (12 tabel + Index + FK)
│   └── seed.js                    # Script seed awal (RBAC, Users, Showcase Chat/Image/Video/Vault)
├── backend/
│   ├── package.json
│   ├── server.js                  # Entrypoint composition root & HTTP server
│   ├── config/
│   │   ├── env.js                 # Validasi & pemuatan konfigurasi .env
│   │   └── db.js                  # Koneksi SQLite & PRAGMA enforcement
│   ├── domain/                    # INNER CIRCLE: Entities & Repository Interfaces
│   │   ├── entities/              # User, Session, ChatMessage, ImageJob, VideoJob, VaultItem
│   │   └── repositories/          # Kontrak abstrak (IUserRepo, IVaultRepo, dll)
│   ├── application/               # USE CASES: Business Rules murni (framework-agnostic)
│   │   ├── auth/                  # LoginUseCase, SwitchDemoRoleUseCase, VerifySessionUseCase
│   │   ├── chat/                  # StreamChatUseCase, WebSearchGroundingUseCase
│   │   ├── studio/                # GenerateImageUseCase, RenderRemotionVideoUseCase
│   │   └── vault/                 # ListVaultItemsUseCase, ExportVaultUseCase
│   ├── infrastructure/            # OUTER ADAPTERS: Implementasi konkret DB & AI Providers
│   │   ├── repositories/          # SqliteUserRepository, SqliteVaultRepository, dll
│   │   ├── ai-gateway/            # HermesCoreAdapter, WebSearchAdapter, ImageProviderAdapter
│   │   └── remotion/              # RemotionHeadlessService + DualSpeakerTTSService
│   ├── middlewares/               # Express Interface Adapters
│   │   ├── requireAuth.js         # Validasi Bearer JWT / Session Cookie / Demo Token
│   │   ├── requireRole.js         # RBAC Role & Permission Guard
│   │   └── rateLimiter.js         # Pembatasan kuota berdasarkan tier role
│   ├── controllers/               # HTTP Request -> Use Case DTO translation
│   └── routes/                    # Definisi endpoint /api/v1/*
├── frontend/                      # Web App & Interactive Mobile Simulator Staging
│   ├── package.json
│   ├── index.html
│   ├── src/
│   │   ├── theme/                 # Token VisionOS White & Graphite Frost Spatial Glass
│   │   ├── state/                 # AuthContext, RoleSwitcherStore, ThemeStore
│   │   ├── services/api/          # Typed HTTP + EventSource (SSE) Client
│   │   ├── components/            # SpatialGlassCard, RoleSwitcherPill, VoiceOrb, DeviceFrame
│   │   ├── remotion/              # Komposisi video Remotion Player (60fps)
│   │   └── pages/                 # 5 Layar Utama (Chat, Image Studio, Video Lab, Voice, Vault/Settings)
└── mobile/                        # Flutter Cross-Platform Source (Di-compile di GitHub Actions)
    ├── pubspec.yaml
    └── lib/
        ├── main.dart              # Composition root Flutter & Theme VisionOS
        ├── services/              # API Bridge Client & Secure Token Storage
        └── screens/               # 5 Layar Komersial (Login+Switcher, Chat Bento, Studio+Sheet, Voice/Analytics, Settings)
```

---

## 4. Arsitektur Clean Architecture & Dependency Rule

```
  [ Frameworks & Drivers ]  (Express HTTP, SQLite, Remotion Chromium, Flutter UI)
            │
            ▼  (Dependency points inward ONLY)
  [ Interface Adapters ]    (Controllers, Middlewares RBAC, SqliteRepositories, AI Adapters)
            │
            ▼
  [ Application Use Cases ] (StreamChat, GenerateImage, RenderVideo, SwitchDemoRole)
            │
            ▼
  [ Domain Entities ]       (User, Role, Permission, QuotaPolicy, MediaAsset)
```

- **Aturan Ketat:** Layer `domain/` dan `application/` **dilarang** mengimpor `express`, `better-sqlite3`, atau SDK pihak ketiga. Seluruh dependensi eksternal diinjeksi melalui *Dependency Injection* di `backend/server.js`.

---

## 5. Skema Database Relasional (DDL)

Skema lengkap didefinisikan pada `database/schema.sql` dengan `PRAGMA foreign_keys = ON;` dan dapat dijalankan langsung via `database/seed.js`.

### 5.1 Ringkasan Entitas & Relasi (12 Tabel)

| Kelompok | Tabel | Kolom Kunci & Relasi Foreign Key | Deskripsi |
| :--- | :--- | :--- | :--- |
| **RBAC** | `roles` | `id (PK)`, `slug (UNIQUE)`, `name` | 4 peran utama: `superadmin`, `pro_creator`, `consumer`, `guest`. |
| | `permissions` | `id (PK)`, `slug (UNIQUE)`, `module` | Izin granular (`chat:stream`, `chat:agent_switch`, `video:export_remotion`, `system:config`, dll). |
| | `role_permissions` | `role_id (FK -> roles.id)`, `permission_id (FK -> permissions.id)` | Tabel asosiasi Many-to-Many RBAC. |
| **Auth** | `users` | `id (PK)`, `email (UNIQUE)`, `password_hash`, `role_id (FK -> roles.id)` | Data pengguna, kuota token/render, dan kustom endpoint pribadi (`custom_backend_url`). |
| | `sessions` | `id (PK)`, `user_id (FK -> users.id)`, `token_hash (UNIQUE)`, `expires_at` | Pelacakan sesi aktif, device metadata, dan revokasi refresh token. |
| **Chat** | `chat_sessions` | `id (PK)`, `user_id (FK -> users.id)`, `specialist_persona` | Sesi obrolan multi-agen (`general`, `business_analyst`, `tech_architect`, dll). |
| | `messages` | `id (PK)`, `session_id (FK -> chat_sessions.id)`, `role`, `citations_json` | Riwayat pesan, flag `web_search_enabled`, dan JSON array kutipan grounding. |
| | `attachments` | `id (PK)`, `message_id (FK -> messages.id)`, `file_url`, `file_type` | Lampiran multimodal gambar/dokumen per pesan. |
| **Media** | `image_generations` | `id (PK)`, `user_id (FK -> users.id)`, `aspect_ratio`, `style_preset` | Riwayat generasi gambar AI Studio (`1:1`, `16:9`, `9:16`, seed, resolution). |
| | `video_remotion_jobs` | `id (PK)`, `user_id (FK -> users.id)`, `status`, `output_video_url` | Antrean & status render video Remotion beserta suara `speaker_male_voice` & `speaker_female_voice`. |
| **Vault** | `vault_items` | `id (PK)`, `user_id (FK -> users.id)`, `media_type`, `asset_url` | Galeri terpadu seluruh gambar, video, audio, dan bookmark pengguna. |
| **System** | `system_settings` | `id (PK)`, `key (UNIQUE)`, `value` | Konfigurasi runtime global (`DEFAULT_AI_MODEL`, `REMOTION_MAX_CONCURRENT_RENDERS`, dll). |

### 5.2 Indeks Performa
Seluruh *foreign key* dan kolom pencarian berfrekuensi tinggi (`users(role_id)`, `sessions(token_hash)`, `chat_sessions(user_id)`, `messages(session_id)`, `video_remotion_jobs(status)`, `vault_items(user_id, media_type)`, `vault_items(user_id, is_favorite)`) dilengkapi index eksplisit di `database/schema.sql`.

---

## 6. Desain Autentikasi, Sesi & RBAC Middleware

### 6.1 Alur Autentikasi & Keamanan Kredensial
1. **Password Hashing:** Menggunakan `bcrypt` (10+ salt rounds) atau `Argon2id`. Password mentah tidak pernah disimpan atau dicatat di log.
2. **Token Lifecycle:**
   - **Access Token (JWT HS256):** Masa aktif pendek (`JWT_EXPIRES_IN=1d`), memuat klaim `{ sub: userId, role: roleSlug, permissions: [...], isDemo: boolean }`. Dikirim melalui header `Authorization: Bearer <token>`.
   - **Refresh Token:** Disimpan hash SHA-256-nya di tabel `sessions` (`token_hash`) dan dikirim via `HttpOnly; SameSite=Lax` cookie pada klien web atau secure keychain pada mobile iOS/Android.
3. **Demo Quick Role Switcher Flow (Mode Hybrid):**
   - Hanya aktif apabila `ENABLE_DEMO_ROLE_SWITCHER=true` di environment.
   - Endpoint `POST /api/v1/auth/demo-switch` menerima `{ targetRole: 'superadmin' | 'pro_creator' | 'consumer' | 'guest' }`.
   - Sistem menerbitkan JWT bertanda `isDemo: true` dengan identitas user seed yang sesuai (`admin@hermes.ai`, `pro@hermes.ai`, `member@hermes.ai`, `guest@hermes.ai`), sehingga seluruh guard UI & API bereaksi otentik tanpa bypass keamanan di mode produksi (`ENABLE_DEMO_ROLE_SWITCHER=false`).

### 6.2 Middleware Proteksi RBAC (`backend/middlewares/`)
- **`requireAuth(req, res, next)`**:
  - Mengekstrak Bearer token atau session cookie.
  - Memverifikasi signature JWT dengan `JWT_SECRET`, mengecek masa berlaku, dan memvalidasi bahwa user `is_active = 1` serta sesi belum dicabut.
  - Menempelkan `req.user` (id, roleSlug, permissions[]) ke konteks request. Mengembalikan `401 Unauthorized` jika gagal.
- **`requireRole(allowedRoles)`**:
  - Memeriksa apakah `allowedRoles.includes(req.user.roleSlug)`.
  - Mengembalikan `403 Forbidden` dengan pesan terstruktur `{ error: "FORBIDDEN_ROLE", required: allowedRoles }` jika tidak memenuhi syarat.
- **`requirePermission(permissionSlug)`**:
  - Mengevaluasi izin granular berbasis `role_permissions` (misal `requirePermission('video:export_remotion')` atau `requirePermission('system:config')`).

### 6.3 Matriks Penegakan Hak Akses per Endpoint

| Fitur / Resource | `superadmin` | `pro_creator` | `consumer` | `guest` |
| :--- | :---: | :---: | :---: | :---: |
| Chat SSE Streaming | Penuh | Penuh | Penuh | Max 10 req/sesi |
| Multi-Agent Specialist Switcher | Penuh | Penuh | Default Agent | Preset Demo |
| Web Search + Grounding Citations | Penuh | Penuh | Penuh | Read-only Demo |
| Image Studio + Aspect Ratio | Penuh (HD + CFG) | Penuh (HD + CFG) | Standar (10/hari) | Demo (3/hari, Watermark) |
| Remotion Video Lab MP4 Export | 1080p No-Watermark | 1080p No-Watermark | 720p Watermark (15s) | Play Pre-rendered Only |
| Voice Mode Hands-Free (VAD) | Penuh | Penuh | Penuh | Max 2 Menit/sesi |
| Vault Export ZIP / Purge | Penuh | Penuh | Penuh | Diblokir (`403`) |
| System Settings (Bridge URL & Key) | Read & Write | Personal Override | Diblokir (`403`) | Diblokir (`403`) |

---

## 7. Kontrak REST API & SSE Streaming (`/api/v1`)

Seluruh respons standar menggunakan format JSON `{ success: boolean, data?: any, error?: { code, message } }`.

| Endpoint | Method | Middleware | Request Body / Params | Response & Kode Status |
| :--- | :---: | :--- | :--- | :--- |
| `/api/v1/health` | `GET` | Public | - | `200 OK` `{ status: "healthy", mode: "hybrid", version: "1.0.0" }` |
| `/api/v1/auth/login` | `POST` | Public | `{ email, password }` | `200 OK` `{ token, user, permissions }` / `401` |
| `/api/v1/auth/demo-switch` | `POST` | Demo Flag Guard | `{ roleSlug }` | `200 OK` `{ token, user, permissions }` / `403` |
| `/api/v1/auth/me` | `GET` | `requireAuth` | - | `200 OK` `{ user, quotas, permissions }` |
| `/api/v1/auth/logout` | `POST` | `requireAuth` | - | `200 OK` `{ message: "Session terminated" }` |
| `/api/v1/agents` | `GET` | `requireAuth` | - | `200 OK` Daftar agen (`general`, `business_analyst`, `tech_architect`, `creative_director`) |
| `/api/v1/chat/sessions` | `GET` | `requireAuth` | - | `200 OK` Daftar riwayat `chat_sessions` milik user |
| `/api/v1/chat/stream` | `POST` | `requireAuth`, `requirePermission('chat:stream')` | `{ sessionId?, agentPersona, messages, webSearchEnabled, attachments[] }` | `200 OK` (`Content-Type: text/event-stream`). Events: `event: search_status`, `event: token`, `event: citation`, `event: done` |
| `/api/v1/image/generate` | `POST` | `requireAuth`, `requirePermission('image:generate')` | `{ prompt, negativePrompt?, aspectRatio, stylePreset, steps?, cfg? }` | `201 Created` `{ id, imageUrl, width, height, seed }` |
| `/api/v1/video/render` | `POST` | `requireAuth`, `requirePermission('video:render')` | `{ title, scriptText, templateName, speakerMaleVoice, speakerFemaleVoice }` | `202 Accepted` `{ jobId, status: "queued" }` |
| `/api/v1/video/status/:id` | `GET` | `requireAuth` | Path: `id` | `200 OK` `{ id, status, progressPct, outputVideoUrl, durationSec }` |
| `/api/v1/voice/session` | `POST` | `requireAuth`, `requirePermission('voice:duplex')` | `{ agentPersona, vadTimeoutMs }` | `201 Created` `{ voiceSessionId, wsEndpoint, vadConfig }` |
| `/api/v1/vault/items` | `GET` | `requireAuth` | Query: `?type=image\|video\|audio&fav=1&q=...` | `200 OK` Array `vault_items` |
| `/api/v1/vault/items/:id` | `DELETE` | `requireAuth` | Path: `id` | `200 OK` `{ deleted: true }` / `403` jika Guest |
| `/api/v1/system/settings` | `GET/PUT` | `requireAuth`, `requireRole(['superadmin', 'pro_creator'])` | `{ customBackendUrl?, customBearerToken?, defaultModel? }` | `200 OK` Updated settings |

---

## 8. Arsitektur Mobile Zero-Local-Build & 5 Layar Komersial

Sesuai standar `mobile-github-ci-factory`, aplikasi mobile iOS (`.ipa`) dan Android (`.apk`) **tidak dibangun di server Linux lokal**, melainkan melalui GitHub Actions (`.github/workflows/build-mobile.yml`).

### 8.1 Alur Pipeline CI/CD (`.github/workflows/build-mobile.yml`)
1. **Trigger:** Otomatis saat `push` ke branch `main`/`master` atau manual via `workflow_dispatch`.
2. **Job `build-android` (`ubuntu-latest`):**
   - Menyiapkan Java 17 (Temurin) dan Flutter SDK (`stable`).
   - Men-generate shell native via `flutter create`, menginjeksi custom `lib/` + `pubspec.yaml`, mengubah label aplikasi menjadi `Hermes Super AI`, lalu menjalankan `flutter build apk --release` -> `HermesSuperAI-release.apk`.
3. **Job `build-ios` (`macos-latest`):**
   - Menyiapkan Flutter SDK, menginjeksi custom `lib/` + `pubspec.yaml`, menyetel Display Name di `Info.plist`.
   - Menjalankan `flutter build ios --config-only --no-codesign`, dilanjutkan kompilasi unsigned via `xcodebuild` dengan `CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGNING_IDENTITY="" DEVELOPMENT_TEAM=""`.
   - Mengemas `Runner.app` ke folder `Payload/` dan mengkompresi menjadi **`HermesSuperAI-iOS-sideload.ipa`** (siap sideload via ESign, GBox, Scarlet, AltStore, atau TrollStore).
4. **Job `publish-release`:** Mengunduh artefak `.apk` dan `.ipa` lalu menerbitkan **GitHub Release** otomatis dengan tag versi berurutan (`v1.0.<run_number>`) untuk mencegah *cache collision* saat sideloading ulang di iOS.

### 8.2 Struktur 5 Layar Komersial (Sinkron 1:1 Web Simulator & Mobile)
1. **Layar 1 — Login & Role Switcher:** Autentikasi email/password + *Floating Quick Role Switcher Pill* (Mode Demo).
2. **Layar 2 — Chat AI Space (Home Bento Dashboard):** Multimodal SSE chat, toggle *Web Search*, *Grounding Citations*, dan *Multi-Agent Specialist Switcher*.
3. **Layar 3 — Creative Studio & Video Lab (+ Bottom Sheet):** Generator Gambar (`1:1`, `16:9`, `9:16`, Download to Photos) & Remotion Dual-Speaker Video Lab dengan inline player.
4. **Layar 4 — Voice Mode & Usage Analytics:** *Spatial Orb Visualizer* hands-free dengan VAD (750ms) dan *Barge-in* + meteran pemakaian token/render.
5. **Layar 5 — Unified Vault & Server Settings:** Galeri media terfilter (`All`, `Images`, `Videos`, `Favorites`) serta pengaturan *Backend Bridge URL*, *Bearer Token*, dan tema (*Graphite Frost* / *VisionOS White*).

---

## 9. Spesifikasi Environment Variables (`.env.example`)

Seluruh konfigurasi rahasia dan runtime dideklarasikan tanpa hardcoding di `.env.example`:
- **Server & CORS:** `PORT`, `NODE_ENV`, `API_PREFIX`, `CORS_ORIGIN`.
- **Database:** `DATABASE_DRIVER=sqlite`, `DATABASE_PATH=./database/hermes_vault.db`, serta template `DATABASE_URL` untuk opsi PostgreSQL.
- **Auth & Security:** `JWT_SECRET`, `JWT_EXPIRES_IN`, `REFRESH_TOKEN_SECRET`, `BCRYPT_SALT_ROUNDS`, `SESSION_SECRET`.
- **Hermes Core & AI Providers:** `HERMES_API_ENDPOINT`, `HERMES_API_SECRET_TOKEN`, `DEFAULT_CHAT_MODEL`, `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GOOGLE_AI_KEY`, `NINEROUTE_API_KEY`.
- **Feature Flags:** `ENABLE_DEMO_ROLE_SWITCHER`, `ENABLE_WEB_SEARCH`, `ENABLE_VIDEO_REMOTION`, `ENABLE_VOICE_MODE`.
- **Remotion & Voice TTS:** `REMOTION_CHROMIUM_EXECUTABLE_PATH`, `VIDEO_RENDER_TIMEOUT_MS`, `OUTPUT_MEDIA_DIR`, `TTS_DEFAULT_VOICE_MALE`, `TTS_DEFAULT_VOICE_FEMALE`, `VAD_SILENCE_TIMEOUT_MS`.

---

## 10. Keamanan, Ancaman, Secret Management & Failure Handling

1. **Perlindungan Rahasia & Kredensial:**
   - `.env` dikecualikan via `.gitignore`; `custom_bearer_token` pengguna di tabel `users` wajib dienkripsi simetris (AES-256-GCM) sebelum disimpan ke SQLite/PostgreSQL.
   - `JWT_SECRET` di produksi wajib memiliki entropi ≥ 256-bit; server menolak start dalam `NODE_ENV=production` jika masih memakai placeholder default.
2. **Mitigasi Ancaman Utama:**
   - **SSRF pada Custom Backend URL:** Saat `pro_creator`/`superadmin` mengatur `custom_backend_url`, validasi URL memblokir skema non-HTTP(S) dan IP metadata cloud (`169.254.169.254`).
   - **Resource Exhaustion (DoS pada Remotion Render):** Batasi proses headless Chromium bersamaan via antrean `REMOTION_MAX_CONCURRENT_RENDERS=2` dan `VIDEO_RENDER_TIMEOUT_MS=60000`.
   - **SQL Injection:** Seluruh query repository wajib menggunakan *prepared statements* / parameterized binding (`?` pada `better-sqlite3`).
   - **Upload Validation:** Validasi MIME magic-bytes (PNG, JPEG, WebP, PDF) serta batas ukuran per role (Consumer max 5MB, Guest max 2MB, Pro/Admin max 10MB).
3. **Failure Handling & Degradasi Anggun:**
   - Jika Hermes Core Gateway (`HERMES_API_ENDPOINT`) tidak terjangkau saat mode staging/demo, adapter otomatis beralih ke *Deterministic Demo Stream Fallback* dengan penanda status `"Demo Simulation Fallback"` agar evaluasi UI tetap berjalan tanpa crash.
   - Jika job render Remotion gagal atau timeout, status job di `video_remotion_jobs` diperbarui menjadi `failed` dengan `error_message` informatif dan kuota render user dikembalikan (*quota rollback*).

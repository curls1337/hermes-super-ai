# HERMES SUPER AI — VisionOS Spatial Multimodal Suite

<p align="center">
  <img src="./assets/logo-icon.svg" alt="Hermes Super AI VisionOS Icon" width="96" height="96" />
</p>

**Hermes Super AI** adalah platform kreasi generatif dan asisten AI multimodal generasi baru yang mengonsolidasikan lima pilar kemampuan AI dalam estetika **Apple VisionOS Spatial Glass (Graphite Frost & Pure Alabaster White)**.

Proyek ini beroperasi dalam **Mode Hybrid**:
1. **Interactive Mobile Device Simulator (`index.html`, `simulator_app.js`, `simulator_orb.js`)**: Pratinjau staging interaktif di browser dengan bingkai iPhone 15 Pro (Dynamic Island) & Android Material 3, lengkap dengan *Floating Quick Role Switcher Pill* untuk menguji 4 peran RBAC secara instan.
2. **Backend Bridge API (`backend/`)**: Server Node.js + Express (Clean Architecture) dengan dukungan Server-Sent Events (SSE) streaming, guard RBAC/JWT, enkripsi AES-256-GCM, serta SQLite/SQLCipher database (`database/hermes_vault.db`).
3. **Cross-Platform Mobile App (`mobile/`)**: Codebase Flutter 3.x (5 Layar Komersial + `SpatialOrbVisualizer` + `SpatialGlassCard`) yang dikompilasi otomatis menjadi **iOS `.ipa` (Sideload)** dan **Android `.apk`** melalui GitHub Actions (`.github/workflows/build-mobile.yml`).

---

## ✨ 5 Pilar Kapabilitas Multimodal

1. **💬 Multimodal Chat AI Space**:
   - Real-time Server-Sent Events (SSE) streaming (target TTFT ≤ 650ms).
   - **Multi-Agent Specialist Switcher**: *Lead Orchestrator*, *Fullstack Architect*, *Art & UX Director*, dan *Business Analyst*.
   - **Web Search & Grounding Citations**: Saklar penelusuran web dengan kapsul rujukan sumber yang dapat diklik.
   - Pemformatan Markdown lengkap & blok kode dengan tombol salin 1-klik.
2. **🎨 AI Image Studio**:
   - Text-to-Image dengan tombol *Magic Polish* enhancer.
   - Pemilih rasio aspek tersegmentasi (`1:1`, `16:9`, `9:16`, `4:3`).
   - Animasi *Shimmer Skeleton Loading*, modal *Lightbox Inspector*, dan simpan ke *Photos / Camera Roll*.
3. **🎬 AI Video Lab (Remotion Engine 60 FPS)**:
   - Pemutar timeline interaktif dengan scrubber & playhead controls.
   - **Story Beat & Scene Sequencer** dengan narator ganda (*Dual-Speaker TTS*: Ardi Male & Gadis Female).
   - Render MP4 H.264 headless (bersih untuk *Superadmin*/*Pro Creator*, watermarked untuk *Consumer*/*Guest*).
4. **🎙️ Hands-Free Spatial Voice Mode**:
   - **Glowing Spatial Orb 3D** (`simulator_orb.js` / `orb_visualizer.dart`) dengan partikel neural 3D & 24-bar spektrum audio simetris.
   - **Voice Activity Detection (VAD)** otomatis (keheningan ≥ 750ms) dan dukungan interupsi instan (*Barge-in*).
   - *Live Synchronized Transcript HUD*.
5. **🗄️ Unified Media Vault & System Settings**:
   - Galeri media terfilter (*All*, *Images*, *Videos*, *Audio*, *Favorites*).
   - Pengaturan *Custom Backend Bridge URL*, *Bearer Token*, serta uji latensi server (*Ping*).
   - Toggle tema **Graphite Frost (Dark)** ↔ **VisionOS White (Light)**.

---

## 📁 Struktur Direktori

```text
hermes-super-ai/
├── index.html                  # Interactive Mobile Simulator Host (iOS / Android Frame)
├── simulator_app.js            # State, 5-Screen Simulator Flow, SSE & Remotion Simulation
├── simulator_orb.js            # 3D Fluid Spatial Voice Orb + Web Audio API VAD Engine
├── site.json                   # Metadata registri staging WebUI
├── tailwind.min.js             # Local Tailwind CSS bundle
├── README.md                   # Dokumentasi proyek
├── assets/                     # Ikon SVG VisionOS Squircle, Logo Wordmark & Favicon
├── backend/                    # Clean Architecture Node.js ES Modules Bridge
│   ├── package.json
│   ├── server.mjs              # Entrypoint Express & Static Simulator Host
│   ├── config/                 # env.mjs, db.mjs (SQLite3 Bridge)
│   ├── domain/entities/        # rbac.mjs (Role Policies & Specialist Agents)
│   ├── application/            # useCases.mjs (Auth, Chat SSE, Studio, Video, Vault)
│   ├── middlewares/            # auth.mjs (JWT, RBAC Role/Permission Guard, Rate Limiter)
│   └── routes/                 # api.mjs (/api/v1/*)
├── database/
│   ├── schema.sql              # DDL 12 tabel relasional + indexes
│   ├── seed.js                 # Skrip inisialisasi data contoh & akun demo
│   └── hermes_vault.db         # Database SQLite terisi siap pakai
├── mobile/                     # Flutter Cross-Platform Source (iOS .ipa & Android .apk)
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart           # App Shell + Floating Frosted Glass Bottom Tab Bar
│   │   ├── core/               # tokens.dart, app_state.dart
│   │   ├── services/           # api_client.dart
│   │   ├── widgets/            # spatial_glass_card.dart, role_switcher_pill.dart, orb_visualizer.dart
│   │   └── screens/            # login_screen.dart, chat_screen.dart, image_studio_screen.dart,
│   │                           # video_lab_screen.dart, voice_mode_screen.dart, gallery_vault_screen.dart
│   └── test/widget_test.dart   # RBAC & Navigation Smoke/Widget Tests
└── .github/workflows/
    └── build-mobile.yml        # GitHub Actions CI/CD (Build APK & Unsigned IPA -> Releases)
```

---

## 🚀 Panduan Menjalankan

### 1. Menjalankan Interactive Mobile Simulator (Standalone)
Buka langsung `index.html` melalui server web statis (misalnya `python3 -m http.server 8080` atau WebUI staging):
```bash
cd /home/devcurl/workspace-webui/hermes-super-ai
python3 -m http.server 8080
```
Akses `http://localhost:8080` di browser. Gunakan tombol **Ganti Frame (iOS / Android)**, **Tema (Frost / White)**, dan **Quick Role Switcher Pill** di pojok kanan atas layar ponsel.

### 2. Menjalankan Backend Bridge API
```bash
cd /home/devcurl/workspace-webui/hermes-super-ai/backend
npm install
cp ../.env.example ../.env
npm start
```
Server akan berjalan di `http://localhost:3000/api/v1` dan sekaligus menyajikan simulator statis di `http://localhost:3000`.

### 3. Akun Demo & RBAC Roles (Password: `password123`)
| Role | Email | Hak Akses Utama |
| :--- | :--- | :--- |
| **Superadmin** | `admin@hermes.ai` | Akses penuh sistem, konfigurasi global, tanpa batas kuota. |
| **Pro Creator** | `pro@hermes.ai` | Multi-Agent Switcher, Remotion 1080p tanpa watermark, HD Studio. |
| **Consumer** | `member@hermes.ai` | Asisten default, ekspor 720p ber-watermark, galeri Camera Roll. |
| **Guest Demo** | `guest@hermes.ai` | Sandbox evaluasi instan dengan batasan rate-limit. |

---

## 📱 Build Mobile `.ipa` & `.apk` (GitHub Actions CI/CD)

Pipeline `.github/workflows/build-mobile.yml` akan otomatis berjalan saat `push` ke branch `main`/`master` atau via `workflow_dispatch`:
- **`build-android` (`ubuntu-latest`)**: Menghasilkan **`HermesSuperAI-release.apk`**.
- **`build-ios` (`macos-latest`)**: Menghasilkan **`HermesSuperAI-iOS-sideload.ipa`** (unsigned IPA siap sideload via AltStore, SideStore, Scarlet, ESign, atau TrollStore).
- **`publish-release`**: Menerbitkan kedua biner ke halaman **GitHub Releases**.

# SPESIFIKASI DESAIN UI/UX & ART DIRECTION
# HERMES SUPER AI — VISIONOS SPATIAL EDITION

---
- **Aplikasi**: Hermes Super AI
- **Slug**: `hermes-super-ai`
- **Lokasi Berkas**: `/home/devcurl/workspace-webui/hermes-super-ai/UI_SPEC.md`
- **Dokumen Referensi**: `BRD_SPEC.md`, `PRD_AC_SPEC.md`
- **Versi**: 1.0.0
- **Profil Bertanggung Jawab**: UX/UI & Art Direction (`team-ux-ui`)
- **Tema Desain**: VisionOS White / Graphite Frost (Apple Spatial Glass, Minimalis, Transparan Buram, Border Reflektif Lembut, Kontras Tinggi)
- **Target Platform**: Progressive Web App (PWA Mobile iOS/Android Safari & Chrome), Native iOS (`.ipa` sideload), dan WebUI Desktop 60fps

---

## 1. Design Brief Delapan Unsur (Design Brief 8-Pillars)

### 1.1 Konteks (*Context*)
Hermes Super AI adalah platform kreasi generatif generasi baru (*next-generation creative suite*) yang mengonsolidasikan lima pilar kapabilitas AI terfragmentasi: Multimodal Chat AI (Real-time SSE Streaming + Multi-Agent), AI Image Studio (Prompt to Image multi-rasio), AI Video Lab (Remotion Engine Native MP4 + Dual-Speaker TTS), Hands-free Spatial Voice Mode (Interaktif Realtime), dan Unified Media Gallery & Vault. Aplikasi dibangun untuk berjalan responsif pada perangkat genggam (iPhone Safari PWA / Native `.ipa`) maupun antarmuka monitor layar lebar dengan standar estetika Apple VisionOS.

### 1.2 Target Pengguna (*Target Audience*)
1. **Power Creators & Animators (Pro)**: Kreator konten video pendek (TikTok/Reels), desainer visual, dan podcaster yang memerlukan ekspor cepat tanpa perpindahan alat kerja.
2. **Business Analysts & Researchers**: Eksekutif yang membutuhkan grounding citations, multi-agent switching, dan ringkasan eksekutif instan.
3. **Everyday Consumers (Members)**: Pengguna umum yang mencari asisten suara cerdas *hands-free*, generator gambar artistik, dan obrolan visual interaktif.
4. **Stakeholders & Client Reviewers (Guests)**: Evaluator pada *Interactive Staging Simulator* yang membutuhkan pengujian fitur instan dengan fitur *Quick Role Switcher*.

### 1.3 Vibe & Kesan Emosional (*Aesthetic Mood*)
- **Apple Spatial Glass**: Kesan material kaca fisik mengambang di ruang spatial, memiliki ketebalan visual (*depth*), refraksi cahaya, dan specular border reflection.
- **Graphite Frost & Pure Alabaster**: Nuansa es grafit gelap yang mewah dipadukan dengan kaca putih salju berembun yang jernih, menghadirkan ketenangan, presisi tinggi, dan keanggunan futuristik.
- **Tactile & Reactive**: Setiap elemen merespons interaksi mikro melalui efek pendar cahaya (*ambient backglow*), haptik halus, dan fisika pegas (*spring physics*).

### 1.4 Referensi Desain (*Inspirations*)
- **Apple VisionOS**: Material *Translucent Liquid Glass*, *Specularity*, kurvatur sudut *Squircle 24–32px*, dan palet kedalaman spasial.
- **Raycast & Linear App**: Tipografi tajam, navigasi keyboard-first, status pill badges, dan interaksi instan tanpa lag.
- **Stripe Dashboard**: Hirarki bento KPI grid, micro-contrast, dan keterbacaan data numerik yang akurat.
- **ChatGPT Advanced Voice**: Visualisasi bola audio organik 3D (*Spatial Glowing Orb*) yang bernapas sesuai ritme percakapan.

### 1.5 Palet Warna & Token Visual (*Color Palette*)
- **Dominan**: Deep Obsidian Canvas (`#090D16`), Translucent Graphite (`#0F172A` / `#1E293B`), dan Pure White Frost Glass (`rgba(255, 255, 255, 0.08)` hingga `rgba(255, 255, 255, 0.85)`).
- **Aksen Primer**: Electric Cyan (`#38BDF8`), Neural Violet (`#818CF8`), dan Prismatic Magenta (`#C084FC`).
- **Aksen Semantik**: Emerald Live (`#10B981`), Amber Attention (`#F59E0B`), Rose Danger (`#EF4444`).

### 1.6 Tipografi (*Typography System*)
- **Font Primer**: `-apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', 'Inter', sans-serif`.
- **Monospace (Kode & Token)**: `'JetBrains Mono', 'SF Mono', 'Fira Code', monospace`.
- **Karakter Tipografi**: Tracking lebar pada judul uppercase brand (`letter-spacing: 0.15em`), line-height ergonomis `1.5` pada pesan obrolan, dan weight semi-bold pada label tombol interaktif.

### 1.7 Struktur Navigasi & Tata Letak (*Information Architecture*)
- **Mobile PWA Architecture**: Mengadopsi *Floating Frosted Glass Bottom Tab Bar* dengan 5 tab inti, safe-area inset atas (anti Dynamic Island) dan bawah (anti Home Indicator).
- **Desktop Dynamic Split**: Navigasi sidebar spatial glass di sebelah kiri, workspace kanvas utama di tengah, dan kontekstual drawer (inspector/timeline/settings) di sebelah kanan.
- **Quick Role Switcher Pill**: Komponen pengalih peran melayang (*docked pill*) untuk peralihan instan antara Superadmin, Pro Creator, Member, dan Guest tanpa login berulang.

### 1.8 Hal yang Wajib Dihindari (*Anti-Patterns*)
- ❌ **Single-Screen Dummy**: Dilarang membuat antarmuka hanya 1 halaman teks polos tanpa sistem navigasi multi-layar.
- ❌ **Opaque Heavy Gray Boxes**: Menghindari kotak abu-abu flat tanpa transparansi dan tanpa efek blur material kaca.
- ❌ **Cramped Interactive Targets**: Dilarang menggunakan tombol berukuran < 28px atau target sentuh mobile < 44pt.
- ❌ **Dead States / Empty Mockups**: Dilarang menyajikan state tanpa data uji coba (*rich seed data*), tanpa feedback loading shimmer, atau tombol tanpa penangan klik.
- ❌ **Double Scrollbars & Iframe Enclosure**: Dilarang menempatkan komponen aplikasi di dalam `<iframe>` yang memotong scroll native.

---

## 2. Design Tokens: VisionOS White / Graphite Frost

### 2.1 CSS Custom Properties (Design Tokens)

```css
:root {
  /* Canvas & Background Surfaces */
  --bg-spatial-canvas: #090D16;
  --bg-graphite-deep: #0B0F19;
  --bg-graphite-elevated: #111827;
  --bg-graphite-surface: #1E293B;

  /* VisionOS Frosted Glass Tokens */
  --glass-bg-subtle: rgba(255, 255, 255, 0.04);
  --glass-bg-regular: rgba(255, 255, 255, 0.08);
  --glass-bg-frosted: rgba(15, 23, 42, 0.65);
  --glass-bg-elevated: rgba(30, 41, 59, 0.75);
  --glass-bg-white-frost: rgba(255, 255, 255, 0.88);

  /* Specular Light Borders & Highlights */
  --glass-border-subtle: rgba(255, 255, 255, 0.08);
  --glass-border-regular: rgba(255, 255, 255, 0.16);
  --glass-border-specular: rgba(255, 255, 255, 0.35);
  --glass-border-active: rgba(56, 189, 248, 0.65);
  --glass-inner-bevel: inset 0 1px 1px 0 rgba(255, 255, 255, 0.25);
  --glass-inner-bevel-glow: inset 0 1px 2px 0 rgba(56, 189, 248, 0.35);

  /* Backdrop Filters (Apple Spatial Glass) */
  --glass-blur-sm: blur(12px) saturate(160%);
  --glass-blur-md: blur(24px) saturate(190%);
  --glass-blur-lg: blur(40px) saturate(220%);

  /* Brand Accents */
  --accent-cyan: #38BDF8;
  --accent-indigo: #6366F1;
  --accent-violet: #818CF8;
  --accent-purple: #A855F7;
  --accent-prism: linear-gradient(135deg, #38BDF8 0%, #818CF8 50%, #C084FC 100%);
  --accent-frost-glow: radial-gradient(circle, rgba(56, 189, 248, 0.25) 0%, rgba(99, 102, 241, 0.05) 70%, transparent 100%);

  /* Semantic State Colors */
  --color-success: #10B981;
  --color-success-bg: rgba(16, 185, 129, 0.15);
  --color-warning: #F59E0B;
  --color-warning-bg: rgba(245, 158, 11, 0.15);
  --color-danger: #EF4444;
  --color-danger-bg: rgba(239, 68, 68, 0.15);
  --color-info: #0EA5E9;
  --color-info-bg: rgba(14, 165, 233, 0.15);

  /* Typography Colors */
  --text-primary: #F8FAFC;
  --text-secondary: #94A3B8;
  --text-tertiary: #64748B;
  --text-inverse: #090D16;

  /* Corner Curvature (Squircles) */
  --radius-xs: 6px;
  --radius-sm: 10px;
  --radius-md: 16px;
  --radius-lg: 24px;
  --radius-xl: 32px;
  --radius-pill: 9999px;

  /* Shadows & Spatial Depths */
  --shadow-spatial-float: 0 20px 48px -8px rgba(0, 0, 0, 0.65), 0 8px 16px -4px rgba(0, 0, 0, 0.4);
  --shadow-glass-card: 0 12px 32px -4px rgba(0, 0, 0, 0.45);
  --shadow-ambient-cyan: 0 0 32px -4px rgba(56, 189, 248, 0.35);
  --shadow-ambient-purple: 0 0 32px -4px rgba(168, 85, 247, 0.35);

  /* Safe Area Mobile Insets */
  --safe-top: max(env(safe-area-inset-top), 48px);
  --safe-bottom: max(env(safe-area-inset-bottom), 32px);
}
```

### 2.2 Hirarki Skala Tipografi (*Typography Scale*)

| Token Name | Ukuran Font / Line-Height | Weight | Letter Spacing | Peruntukan Elemen |
| :--- | :--- | :--- | :--- | :--- |
| `display-lg` | 36px / 44px (2.25rem) | 800 (Bold) | -0.03em | Hero Spatial Headlines & Splash Banner |
| `title-1` | 28px / 36px (1.75rem) | 700 (Bold) | -0.02em | Judul Modul Utama (Chat, Studio, Video Lab) |
| `title-2` | 22px / 28px (1.375rem) | 600 (Semibold) | -0.015em | Judul Kartu Bento, Story Beat Titles |
| `headline` | 18px / 24px (1.125rem) | 600 (Semibold) | -0.01em | Nama Agen Spesialis, Label Dialog Modal |
| `body-default`| 15px / 22px (0.9375rem) | 400 (Regular) | 0.0em | Bubble Percakapan Chat, Deskripsi Prompt |
| `body-code` | 13.5px / 20px (0.84rem) | 500 (Medium) | 0.02em | Syntax Snippet, Markdown Code Highlighting |
| `callout` | 14px / 20px (0.875rem) | 500 (Medium) | 0.01em | Grounding Citation Link, Voice Transcription |
| `footnote` | 12px / 16px (0.75rem) | 600 (Semibold) | 0.04em | Status Pills, Resolution Badges, Frame Counts |
| `caption` | 10.5px / 14px (0.65rem) | 700 (Bold) | 0.08em | Micro-badges, Role Switcher Labels (UPPERCASE) |

---

## 3. Identitas Visual, Logo & App Icon

Aset grafis vektor murni (`.svg`) telah dirancang dengan standar Apple VisionOS Spatial Glass murni dan tersimpan pada folder `/home/devcurl/workspace-webui/hermes-super-ai/assets/`:

1. **App Icon VisionOS Spatial Glass (`assets/app-icon-visionos.svg` & `assets/icon.svg`)**:
   - Format: Apple VisionOS Squircle (`rx="104" ry="104"` / `rx="115" ry="115"` pada kanvas 512x512).
   - Elemen: Kanvas *Obsidian Depth* bergradasi dengan partikel *micro-grid* spasial, dihiasi pendar latar *cyan* dan *violet*.
   - Inti Grafis: Sayap aerodinamis Hermes berlapis (*Layered Aero Wings*) yang memeluk kristal prisma kaca heksagonal (*Spatial Glass Prism*). Di pusat prisma bersinar bintang inti kecerdasan (*4-point Neural Spark*) melambangkan kecerdasan tanpa batas.
   - Refleksi Fisik: Tepian kaca atas memiliki *specular highlight arch* dan garis tepi *specular rim 3px*.

2. **App Icon VisionOS Dark & Light Editions (`assets/app-icon-visionos-dark.svg` & `assets/app-icon-visionos-light.svg`)**:
   - **Dark Graphite Frost Edition** (`assets/app-icon-visionos-dark.svg`): Nuansa hitam obsidian pekat (`#050608` - `#181920`) dengan aksen sayap biru laut dan bayangan tajam OLED.
   - **Light Alabaster Frost Edition** (`assets/app-icon-visionos-light.svg`): Nuansa salju putih bersih (`#FFFFFF` - `#E2E8F0`) dengan aksen sayap biru sapphire dan bayangan lembut elevasi kaca siang hari.

3. **Standalone App Icon Mark (`assets/logo-icon.svg`)**:
   - Dimensi: Kanvas 256x256 tanpa framing latar belakang, cocok untuk tombol melayang, splash screens, dan header mini.

4. **Logo Horizontal Wordmark (`assets/logo.svg`)**:
   - Dimensi: Kanvas 920x220 resolusi tinggi dengan bantalan kaca buram opsional.
   - Komposisi:
     - Kiri: *Hermes Winged Neural Prism Disc* (diameter 136px) berpusat pendar cahaya.
     - Tengah-Kanan: Tipografi berbobot 800 **HERMES** (`letter-spacing: 5px`) disandingkan dengan kapsul kaca buram bertuliskan gradasi **SUPER AI**.
     - Subtitle: *SPATIAL MULTIMODAL SUITE • VISIONOS FROST* dengan pelacak titik cyan.
     - Ujung Kanan: Status pill `v1.0 HYBRID` dengan titik hijau emerald aktif.

5. **Favicon Browser (`assets/favicon.svg`)**:
   - Dimensi: Kanvas 128x128 teroptimasi untuk resolusi kecil (16px, 32px, 64px).
   - Karakter: Siluet kristal prisma bersayap dengan kontras tajam, batas tepi kaca 1.75px, dan titik fokus cahaya sentral putih berkilau.

---

## 4. Arsitektur 5 Layar Komersial (Commercial Multi-Screen System)

```
┌────────────────────────────────────────────────────────────────────────┐
│                   HERMES SUPER AI SPATIAL SHELL                        │
├────────────────────────────────────────────────────────────────────────┤
│ [Top Bar]  Logo Squircle • Model Badge (GPT-4o/Claude 3.5) • [Role Pill]│
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  [Tab 1: CHAT]    [Tab 2: STUDIO]   [Tab 3: VIDEO]   [Tab 4: VOICE]   │
│  Multimodal       Text-to-Image     Remotion 60fps   Spatial Orb 3D   │
│  Streaming SSE    Aspect Ratios     Dual Narrator    VAD Barge-in     │
│  Agent Chips      Shimmer Lightbox  Timeline Beat    Live Transcript  │
│                                                                        │
├────────────────────────────────────────────────────────────────────────┤
│ [Tab 5: VAULT & SETTINGS]  Media Grid • Sync Pill • API Config • .ipa   │
├────────────────────────────────────────────────────────────────────────┤
│ [Bottom Bar]  Floating Frosted Glass Tab Bar (Blur 40px, Inset-Safe)   │
└────────────────────────────────────────────────────────────────────────┘
```

---

### 4.1 LAYAR 1: Chat Multimodal (Streaming, Agent Chips, Code Highlight)

#### A. Tujuan & Pengalaman Pengguna (*User Flow*)
Pengguna dapat berdialog secara interaktif dengan teks, mengunggah gambar/dokumen untuk analisis visi komputer, beralih peran agen spesialis dalam 1 ketukan, membaca jawaban yang mengalir (*SSE Streaming*), serta menyalin sintaksis kode pemrograman dalam kotak ber-highlight tanpa jeda.

#### B. Anatomi Komponen Antarmuka
1. **Specialist Agent Switcher Bar (Top Horizontal Scroll)**:
   - Deretan kartu mini/chip kapsul kaca buram yang menampilkan spesialis aktif:
     * `⚡ Lead Orchestrator` (Default - Multi-domain reasoning)
     * `💻 Fullstack Architect` (Code generation, refactoring, system architecture)
     * `🎨 Art & UX Director` (Visual prompt craft, UI design critiques, color tokens)
     * `📊 Business & Market Analyst` (Financial modelling, competitor research, BRD synthesis)
   - State aktif ditandai pendar biru *cyan glow* (`box-shadow: 0 0 16px rgba(56, 189, 248, 0.4)`) dan border `1px solid rgba(255, 255, 255, 0.6)`.
2. **Chat Stream Scroll Canvas**:
   - **User Bubble**: Mengambang di kanan dengan material *Graphite Elevated Glass* (`rgba(30, 41, 59, 0.8)`), border halus 1px, sudut melengkung `20px` (dengan ekor lengkung kecil di kanan bawah `6px`).
   - **AI Assistant Bubble**: Mengambang di kiri dengan latar *Translucent Obsidian Frost* (`rgba(15, 23, 42, 0.6)`), dihiasi avatar squircle spesialis 32x32px.
   - **Streaming Token Cursor**: Titik pendar cyan yang berkedip halus (*smooth breathing opacity 0.3 to 1.0*) mengikuti kata terakhir yang dirender.
3. **Web Search Grounding Citation Pills**:
   - Jika jawaban memanfaatkan data real-time, di bawah paragraf muncul deretan kapsul sumber:
     `🌐 [Reuters: Spatial Computing Trends 2026 ↗]` | `🌐 [Apple Developer HIG ↗]`
   - Klik membuka lembar preview sumber tanpa meninggalkan konteks obrolan.
4. **Markdown & Code Highlight Box**:
   - Blok kode dengan tema *Graphite Frost Terminal*:
     - Header baris atas: Nama bahasa (`typescript`, `python`, `swiftui`), tombol *Copy Code* berstatus reaktif (`Copy` ➔ `✓ Copied!`).
     - Latar belakang blok: `#070A10` dengan border tipis `rgba(255, 255, 255, 0.1)`.
     - Nomor baris teks vertikal pudar untuk memudahkan referensi.
5. **Ergonomic Prompt Box & Attachment Drawer**:
   - Input bar melayang di atas batas *Safe Area*:
     - Tombol `+` Lampiran: Membuka drawer mini (Kamera, Galeri Gambar, Dokumen PDF).
     - Preview Thumbnail Kaca: File gambar yang diunggah muncul sebagai chip mini dengan tombol silang hapus `✕`.
     - Toggle `Web Search`: Tombol ikon bola dunia dengan status warna cyan saat aktif.
     - Action Buttons ergonomis: Tombol Mic dan Submit berukuran `28px–30px` dengan sudut `round-full`. Tombol submit otomatis aktif berubah menjadi pendar kontras tinggi saat ada draf input.

---

### 4.2 LAYAR 2: AI Image Studio (Prompt, Aspect Ratios, Shimmer, Lightbox)

#### A. Tujuan & Pengalaman Pengguna
Menghasilkan aset visual berkualitas tinggi dari deskripsi teks dalam berbagai rasio format sosial (1:1 Feed, 16:9 Landscape/Desktop, 9:16 Reels/Story/TikTok, 4:3 Klasik), dilengkapi pratinjau skeleton shimmer saat rendering dan modal Lightbox detail untuk mengunduh ke galeri lokal (*Camera Roll*).

#### B. Anatomi Komponen Antarmuka
1. **Prompt Crafting Console**:
   - TextArea kaca buram elastis dengan placeholder: *"Describe a cinematic spatial scene..."*.
   - **1-Click Prompt Enhancer Pill** (`✨ Magic Polish`): Mengoptimasi prompt pendek menjadi deskripsi sinematik kaya detail (pencahayaan volumetrik, lensa 35mm, 8K Octane Render).
2. **Aspect Ratio Pill Selector (Segmented Glass Control)**:
   - Empat pilihan tombol segmen kapsul kaca:
     * `[ 1 : 1 ] Square` (Feed Instagram / Avatar)
     * `[ 16 : 9 ] Cinema` (YouTube / Web Hero Banner)
     * `[ 9 : 16 ] Portrait` (TikTok / Instagram Reels / Mobile Wallpaper)
     * `[ 4 : 3 ] Classic` (Editorial / Presentation)
   - Indikator aktif memiliki latar *White Frost Glass* dengan teks kontras gelap pekat.
3. **Visual Style Carousel**:
   - Slider kartu mini horizontal: *Spatial 3D Glass*, *Ultra Photoreal*, *Anime Cyberpunk*, *Minimalist Editorial*, *Claymation*.
4. **Shimmer Skeleton Loading Grid**:
   - Saat proses komputasi gambar berlangsung (durasi target ≤ 6 detik):
     - Frame kanvas menampilkan efek gelombang kilau cahaya *Graphite Shimmer* berkecepatan 1.5s linear infinite.
     - Lencana status melayang di tengah: `⚙️ Synthesizing Neural Diffusion (Step 18/25)...`.
5. **Generated Showcase Card & Actions**:
   - Kartu gambar dengan sudut lengkung `24px` dan bayangan ambient.
   - Quick action baris bawah:
     * `⬇️ Save to Photos` (Unduh berkas PNG/WebP langsung)
     * `🔍 Inspect Lightbox` (Membuka tampilan layar penuh)
     * `✨ Upscale 4K` (Meningkatkan ketajaman detail)
     * `🪄 Animate in Video Lab` (Mengirim aset langsung ke Layar 3)
6. **Lightbox Inspector Modal**:
   - Layer kaca cembung layar penuh dengan latar belakang buram pekat `backdrop-filter: blur(48px)`.
   - Menampilkan gambar resolusi asli, panel metadata (Seed, Model diffusion, Sampler, Dimensi piksel aktual), dan tombol salin prompt lengkap.

---

### 4.3 LAYAR 3: AI Video Lab (Remotion Engine, Storyboard, Dual Speaker)

#### A. Tujuan & Pengalaman Pengguna
Membuat video narasi beranimasi halus (60fps) berbasis naskah terstruktur (*Storyboard Beats*) dengan sintesis dua narator (*Dual-Speaker TTS Conversation*), pratinjau instan pemutar video Remotion di browser, serta ekspor file MP4 resolusi tinggi.

#### B. Anatomi Komponen Antarmuka
1. **Interactive Remotion Player Canvas (`@remotion/player`)**:
   - Rasio fleksibel (16:9 Landscape atau 9:16 Vertical Story) dengan sudut *squircle 24px*.
   - Header status di atas kanvas: Resolusi (`1080x1920 @ 60 FPS`), Durasi (`00:30.00`), dan Lencana Mesin `REMOTION CORE ENGINE`.
   - Lapisan visual video:
     * Background mesh dinamis (*VisionOS Ambient Pulse*).
     * Card tipografi kinetik judul besar dengan transisi pegas (*spring entrance*).
     * Overlay teks dialog narator dengan penanda warna pembicara.
2. **Timeline Scrubber & Playhead Controls**:
   - Bilah scrubber presisi tinggi dengan penanda detik dan *beat markers* per adegan.
   - Tombol kontrol: `⏮ Frame Back`, `⏯ Play / Pause (Spacebar)`, `⏭ Frame Forward`, `⏱ Durasi Slider`, `🔊 Audio Mixer`.
3. **Dual-Speaker Voice Configurator**:
   - Panel pemilihan karakter suara untuk adegan dialog dua arah:
     * **Narrator A (Lead Guide)**: Pilihan suara *Alpha Male / Baritone Deep* atau *Aria Female / Professional Clear*. Dilengkapi indikator pitch slider dan volume gain.
     * **Narrator B (Subject Specialist)**: Pilihan suara kontras untuk menciptakan dinamika percakapan alami.
   - Lencana preview audio `▶ Test Sample` di samping masing-masing narator.
4. **Story Beat & Scene Sequencer**:
   - Daftar kartu adegan bertingkat (*Draggable Scene Beats*):
     * *Beat 1 (0s - 8s)*: Hook awal & Animasi Judul Utama 3D.
     * *Beat 2 (8s - 18s)*: Penjelasan Masalah & Data Statistik Interaktif.
     * *Beat 3 (18s - 30s)*: Solusi Hermes AI & Call to Action (CTA).
   - Setiap kartu beat memuat input naskah dialog pembicara, waktu durasi, dan tautan gambar aset latar.
5. **Video Export & Render Drawer**:
   - Tombol utama `🎬 Render MP4 Video`.
   - Saat dirender: Muncul status progress bar persentase presisi (`Rendered: 450/900 frames - 50%`) dan estimasi sisa waktu (*ETA 12s*).
   - Setelah selesai: Tombol `⬇️ Download Final MP4` dan opsi `📤 Sideload to Vault`.

---

### 4.4 LAYAR 4: Hands-free Spatial Voice Mode (Glowing Spatial Orb 3D, VAD, Waveform)

#### A. Tujuan & Pengalaman Pengguna
Pengalaman obrolan suara murni tanpa sentuhan (*hands-free voice interaction*) berlatensi sangat rendah (target ≤ 900ms) menyerupai percakapan manusia alami. Menampilkan bola energi spasial bercahaya 3D (*Spatial Orb*) yang bernapas dan membesar saat sistem berbicara atau mendengarkan.

#### B. Anatomi Komponen Antarmuka
1. **Spatial Orb 3D Visualizer Canvas**:
   - Komponen utama di tengah layar: Bola kristal cair bercahaya (*Multi-layer fluid glass sphere*) berdiameter 220px (mobile) / 320px (desktop).
   - Lapisan bola terdiri dari 3 gradasi partikel:
     * *Core Neural Pulse*: Inti putih keunguan yang berdenyut cepat.
     * *Fluid Mantle*: Aliran cairan cyan-violet yang berputar menggunakan shader WebGL / Canvas 2D perlin noise.
     * *Outer Frosted Corona*: Pendar embun es (*Graphite Frost halo*) yang memanjang keluar mengikuti volume audio mic.
2. **Voice Activity Detection (VAD) State Indicators**:
   - Lencana status kapsul kaca mengambang tepat di atas bola suara:
     * `🟢 LISTENING` (Pendar hijau lembut, mic aktif mendeteksi desibel suara pengguna)
     * `🟣 THINKING` (Pendar ungu berputar, model mengolah penalaran konteks)
     * `🔵 SPEAKING` (Pendar biru cyan bervariasi mengikuti frekuensi audio TTS)
     * `⚪ IDLE / READY` (Pendar redup menanti kata sambutan pengguna)
   - Mendukung kemampuan *Barge-in*: Pengguna bisa langsung memotong suara AI kapan saja tanpa menekan tombol.
3. **Real-time Audio Spectrum Waveform**:
   - 24 batang frekuensi audio simetris (*mirror frequency bars*) di bagian bawah bola suara, bergerak harmonis mengikuti amplitudo suara secara real-time.
4. **Live Synchronized Transcript HUD**:
   - Bilah kaca mengambang melengkung (*VisionOS Curved Floating HUD*) di bagian bawah layar:
     - Menampilkan transkrip percakapan real-time dengan teks pudar ke atas (*auto-scroll fade*).
     - Membantu pengguna memverifikasi ketepatan pengenalan ucapan (STT).
5. **Voice Control Bottom Dock**:
   - Tiga tombol aksi kaca melayang:
     * `🎙️ Mute / Unmute Mic`
     * `⏸️ Pause Conversation`
     * `✕ End Voice Session` (Kembali ke Tab Chat dengan transkrip otomatis tersimpan di riwayat obrolan).

---

### 4.5 LAYAR 5: Gallery & Vault / Settings (Cloud Sync, Quick Role Switcher, Sideload)

#### A. Tujuan & Pengalaman Pengguna
Pusat komando terpadu untuk mengakses seluruh aset karya yang pernah dibuat (gambar, video MP4, transkrip audio, percakapan), mengatur sinkronisasi penyimpanan awan vs lokal, mengubah konfigurasi endpoint server API, menguji persona pengguna via *Quick Role Switcher*, serta memantau status instalasi aplikasi mobile `.ipa`.

#### B. Anatomi Komponen Antarmuka
1. **User Identity & Role Header**:
   - Kartu profil *Obsidian Frost Squircle*: Avatar pengguna, nama akun, lencana keanggotaan aktif (`ADMIN`, `PRO CREATOR`, `MEMBER`, atau `GUEST`), dan kuota token GPU tersisa.
2. **Demo Quick Role Switcher (Pill Bar Interaktif)**:
   - Panel tombol segmen kaca fleksibel untuk keperluan evaluasi staging tanpa login ulang:
     * `👑 Superadmin` ➔ Membuka audit log, konfigurasi model API kustom, dan unconstrained render.
     * `⚡ Pro Creator` ➔ Mengaktifkan opsi Remotion 4K 60fps, Image Studio aspect ratios bebas, dan audio ganda.
     * `👤 Member` ➔ Menampilkan batasan pemakaian harian realistis dan watermark preview.
     * `🧪 Guest / Demo` ➔ Mode sandbox dengan data contoh siap pakai.
   - Klik langsung memperbarui state visual seluruh aplikasi seketika (*zero page reload*).
3. **Unified Media Gallery Grid**:
   - Filter Chips Horizontal: `Semua Aset (24)`, `🖼️ Gambar (14)`, `🎬 Video (6)`, `🎙️ Rekaman Suara (4)`, `⭐ Bookmark`.
   - Grid Kartu Media Responsif (2 kolom pada mobile, 4 kolom pada desktop):
     * Setiap thumbnail kartu dilengkapi badge tipe file, durasi video, atau rasio aspek.
     * Hover / Tap memunculkan menu cepat: Unduh, Salin Tautan, Buka di Studio, Hapus.
4. **Cloud & Local Storage Vault Synchronization**:
   - Indikator status sinkronisasi: `🟢 Cloud Storage Connected (Supabase / S3)` & `💾 IndexedDB Local Cache: 42.8 MB`.
   - Tombol aksi: `Ekspor Seluruh Arsip (.zip)` dan `Bersihkan Cache Sementara`.
5. **Server Endpoint & Custom API Configuration**:
   - Input pengaturan endpoint backend:
     * `Backend API Base URL`: Nilai default domain atau kustom (misal `https://api.hermes-super-ai.com/v1`).
     * `Bearer Token / API Key`: Input sensor kata sandi dengan tombol *Show / Hide*.
     * Tombol `Test Connection`: Menguji ketersediaan server dengan feedback latensi (`Ping: 42ms - OK`).
6. **Mobile Sideload & Build Release Card**:
   - Kartu informasi rilis khusus pengujian aplikasi iOS:
     * Status Build: `✅ GitHub Actions CI/CD Build Passing`.
     * Berkas Tersedia: `HermesSuperAI-Release.ipa (v1.0.0-build.104)`.
     * Panduan Sideload 1-Sentuh: Petunjuk instalasi melalui AltStore, SideStore, atau Scarlet.

---

## 5. Spesifikasi Komponen & Ergonomi Mobile (iOS HIG & PWA Standar)

### 5.1 Safe Area Inset Rules
Sesuai dengan standar keahlian `ios-liquid-glass-pwa`:
- **Top App Bar**:
  ```css
  padding-top: max(calc(env(safe-area-inset-top) + 6px), 48px);
  min-height: 96px;
  ```
  Elemen tombol aksi, avatar, dan judul berada pada rentang aman $y = 48\text{px} - 96\text{px}$ sehingga terlindung dari Dynamic Island iPhone 14/15/16 Pro dan lekukan poni iPhone notch.
- **Bottom Tab Bar**:
  ```css
  position: fixed;
  bottom: 0;
  width: 100%;
  padding-bottom: max(env(safe-area-inset-bottom), 32px);
  border-top-left-radius: 26px;
  border-top-right-radius: 26px;
  backdrop-filter: blur(40px) saturate(220%);
  -webkit-backdrop-filter: blur(40px) saturate(220%);
  border-top: 0.5px solid rgba(255, 255, 255, 0.22);
  box-shadow: inset 0 1px 1px 0 rgba(255, 255, 255, 0.35);
  ```
  Teks label dan ikon tab berada di atas garis bilah sentuh geser (*Home Indicator*) dengan jarak aman minimal 32px.

### 5.2 Target Sentuh & Ergonomi Tombol
- **Minimal Touch Target**: Seluruh tombol interaktif utama memiliki area sentuh minimum `44pt x 44pt` (iOS HIG) atau `48dp x 48dp` (Android M3).
- **Prompt Action Icons**: Ikon tombol kirim, lampiran, dan mik berada pada ukuran `28px – 30px` dengan skala ikon `15px–16px` (stroke width `1.8`) guna mencegah antarmuka terasa sesak (*anti-clutter*).
- **Gesture Protection**: Diterapkan `overflow-x: hidden !important; overscroll-behavior-x: none !important; touch-action: pan-y;` pada kanvas aplikasi untuk mencegah gestur swipe kiri-kanan Safari yang tidak diinginkan (*anti rubber-banding*).

### 5.3 Keadaan Transisi & Penanganan Error (*Edge States*)
1. **Empty States**:
   - Jika galeri atau percakapan masih kosong: Menampilkan ilustrasi prisma kaca lembut dengan pesan sapaan hangat dan 3 rekomendasi tindakan instan (*Quick Starter Prompts*).
2. **Loading States**:
   - Menggunakan animasi shimmer berkilau (*specular wave*) dengan kurva easing `cubic-bezier(0.4, 0, 0.2, 1)`, bukan spinner putar lingkaran klasik yang membosankan.
3. **Error & Offline Banners**:
   - Banner kapsul mengambang berwarna *Rose Glass* (`rgba(239, 68, 68, 0.2)`) dengan border tipis merah muda dan tombol aksi `Coba Ulang (Retry)`.

---

## 6. Verifikasi Aset & Kelengkapan Berkas

Seluruh berkas desain dan artefak spesifikasi telah diverifikasi valid pada sistem berkas:

| No | Lokasi Berkas | Keterangan Artefak | Status Validasi |
| :---: | :--- | :--- | :---: |
| 1 | `/home/devcurl/workspace-webui/hermes-super-ai/assets/app-icon-visionos.svg` | App Icon VisionOS Master Squircle (512x512) Apple Spatial Glass | ✅ VALID (XML Verified) |
| 2 | `/home/devcurl/workspace-webui/hermes-super-ai/assets/app-icon-visionos-dark.svg` | App Icon VisionOS Graphite Frost Dark Edition (512x512) | ✅ VALID (XML Verified) |
| 3 | `/home/devcurl/workspace-webui/hermes-super-ai/assets/app-icon-visionos-light.svg` | App Icon VisionOS Alabaster White Light Edition (512x512) | ✅ VALID (XML Verified) |
| 4 | `/home/devcurl/workspace-webui/hermes-super-ai/assets/logo-icon.svg` | Standalone App Icon Vector Mark (256x256) | ✅ VALID (XML Verified) |
| 5 | `/home/devcurl/workspace-webui/hermes-super-ai/assets/icon.svg` | App Icon iOS Squircle (512x512) Neural Prism Glass | ✅ VALID (XML Verified) |
| 6 | `/home/devcurl/workspace-webui/hermes-super-ai/assets/logo.svg` | Logo Horizontal Wordmark HERMES SUPER AI (920x220) | ✅ VALID (XML Verified) |
| 7 | `/home/devcurl/workspace-webui/hermes-super-ai/assets/favicon.svg` | Favicon tajam resolusi tinggi (128x128) | ✅ VALID (XML Verified) |
| 8 | `/home/devcurl/workspace-webui/hermes-super-ai/UI_SPEC.md` | Dokumen Spesifikasi UI/UX Komprehensif 5 Layar | ✅ VALID & LENGKAP |

---

*Dokumen ini disusun oleh tim UX/UI & Art Direction (`team-ux-ui`) sebagai acuan baku desain implementasi bagi Tim Frontend, System Architect, dan Pengembang Mobile Simulator.*

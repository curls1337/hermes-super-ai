# PRODUCT REQUIREMENTS DOCUMENT (PRD) & ACCEPTANCE CRITERIA
# HERMES SUPER AI (Mobile iOS & Web App)

---

- **Nama Aplikasi**: Hermes Super AI
- **Slug Proyek**: `hermes-super-ai`
- **Direktori Proyek**: `/home/devcurl/workspace-webui/hermes-super-ai/`
- **Dokumen Referensi**: `BRD_SPEC.md` (Business Requirements Document)
- **Dokumen Target**: `PRD_AC_SPEC.md`
- **Versi**: 1.0.0
- **Tanggal Rilis**: 12 November 2026
- **Status**: Disetujui (Baseline Spesifikasi & Kriteria Penerimaan Rekayasa)
- **Tema Desain**: VisionOS White / Graphite Frost (Apple Spatial Glass, Blur Multi-layer, Specular Border, Kurvatur 24–32px)
- **Platform Sasaran**: Mobile iOS (`.ipa` sideload package via GitHub Actions CI/CD), Interactive Staging Simulator (WebUI Frame), dan Backend Bridge API

---

## 1. Visi Produk, Sasaran & Target Persona

### 1.1 Visi Produk
Hermes Super AI adalah rangkaian kreasi dan asisten multimodal generasi baru (*next-generation multimodal super-app*) yang menyatukan lima pilar kemampuan kecerdasan buatan dalam satu atap yang mulus:
1. **Multimodal Chat AI**: Percakapan real-time dengan streaming SSE, pencarian web cerdas dengan rujukan kutipan (*grounding citations*), dan pergantian persona agen spesialis (*Multi-Agent Specialist Switcher*).
2. **AI Image Studio**: Pembuatan visual kreatif berbasis teks ke gambar dengan seleksi rasio aspek (1:1, 16:9, 9:16), preset gaya artistik, serta penyimpanan langsung ke *Camera Roll / Photos*.
3. **AI Video Lab**: Perancangan video naratif beranimasi berbasis Remotion Engine terintegrasi, sintesis audio narator ganda (*dual-speaker conversation* pria & wanita), dan pemutar video interaktif (*inline player*).
4. **Hands-Free Voice Mode**: Percakapan suara dua arah secara alami tanpa jeda menekan tombol, visualisasi audio spasial dinamis (*Graphite Frost Spatial Orb*), serta deteksi interupsi instan (*Barge-in*).
5. **Unified Media Gallery / Vault & System Settings**: Penyimpanan terpadu hasil generasi multimodal, kustomisasi endpoint URL server backend, autentikasi token mandiri, dan manajemen cache media.

Seluruh pengalaman disajikan dalam estetika mewah **VisionOS White / Graphite Frost**, menggabungkan material *spatial glass*, *specular refraction border*, kurvatur sudut tinggi, dan fisika animasi halus 60 FPS.

### 1.2 Target Persona & Definisi Role (RBAC)

Platform mengimplementasikan Role-Based Access Control (RBAC) yang terbagi ke dalam 4 tingkatan peran:

| Role Code | Nama Role | Persona Target | Tanggung Jawab & Hak Akses Utama | Batasan & Scope Guard |
| :--- | :--- | :--- | :--- | :--- |
| `ROLE_SUPERADMIN` | **Superadmin / System Owner** | Lead System Architect, IT Operator, DevOps | Akses menyeluruh ke semua modul, konfigurasi Server Endpoint URL, pergantian API secret token, audit metrik konsumsi token/GPU, manajemen vault sistem, dan bypass seluruh batas kuota. | Tidak ada batasan akses fungsional. |
| `ROLE_PROFESSIONAL`| **Professional / Power Creator** | Desainer, Content Creator, Analis Riset, Marketer | Akses ke Multi-Agent Switcher lengkap, render video Remotion resolusi tinggi (MP4 tanpa watermark), Image Studio resolusi ultra dengan custom seed/sampling, Voice Mode prioritas latensi rendah, riwayat chat tak terbatas, dan kustomisasi server URL pribadi. | Dibatasi oleh alokasi kuota komputasi bulanan tier Pro. |
| `ROLE_CONSUMER` | **Consumer / General User** | Pengguna Harian, Pelajar, Eksplorer AI | Akses AI Chat standar (General Assistant), Web Search aktif, Image Studio rasio standar (10 gambar/hari), Video Lab template harian (video dengan watermark preview), Voice Mode interaktif standar, simpan ke Camera Roll. | Terkunci pada Default Agent; opsi konfigurasi server dinonaktifkan; ekspor video membawa watermark. |
| `ROLE_GUEST` | **Guest / Demo Simulator** | Client Evaluator, Reviewer Publik | Akses instan ke Interactive Simulator Staging dengan *pre-seeded realistic showcases*; dilengkapi **Floating Quick Role Switcher** 1-klik untuk merasakan seluruh persona tanpa registrasi. | Sesi sementara (*in-memory sandbox*); perubahan data tidak persisten ke database permanen; rate-limit 10 request/sesi. |

---

## 2. Arsitektur Mode & Mekanisme Quick Switch Role

### 2.1 Dual-Mode Operation: Production Hybrid + Demo Staging Simulator
1. **Mode Full-Stack Production**:
   - Mendukung autentikasi berbasis JWT token / Bearer Header dan session cookie aman.
   - Endpoint API backend terproteksi dengan middleware validasi RBAC ketat.
   - Integrasi langsung ke Hermes Core Agent Runtime dan penyedia model AI.
2. **Mode Demo Interactive Staging Simulator**:
   - Berjalan pada kanvas interaktif berbasis web yang membungkus aplikasi dalam *mockup frame* seluler iOS / VisionOS.
   - Menghadirkan widget mengambang **Quick Role Switcher Pill** di pojok kanan layar.
   - Memuat data percontohan realistis (*seed showcases*): riwayat chat teknis & kreatif, 20+ aset galeri gambar & video, serta komposisi video Remotion interaktif.

### 2.2 Spesifikasi Komponen Quick Role Switcher
- **Tampilan**: Floating glass pill semi-transparan (`backdrop-blur-md`, border `1px solid rgba(255,255,255,0.3)`) dengan indikator lencana role aktif.
- **Interaksi**: 1 ketukan/klik membuka popover pemilihan role (`Superadmin`, `Professional`, `Consumer`, `Guest`).
- **Reaktivitas**: State aplikasi memperbarui konteks peran secara instan (0 detik reload), memicu perubahan visual pada menu navigasi, hak tombol ekspor, serta lencana header secara real-time.

---

## 3. Matriks Prioritas Fitur (Metode MoSCoW)

Spesifikasi kebutuhan fitur dikelompokkan dengan ketat menggunakan metode MoSCoW untuk menjamin pengiriman rilis v1.0 yang solid dan tepat waktu:

### 3.1 Must-Have (P0 - MVP Inti Wajib 100% Berfungsi)
- [x] **P0-01: Autentikasi, Profil & Quick Role Switcher Pill**
  - Form login/register elegan bertema spatial glass.
  - Floating Quick Role Switcher untuk evaluasi instan 4 peran pada Staging Simulator.
- [x] **P0-02: Multimodal Chat AI & Server-Sent Events (SSE) Streaming**
  - Antarmuka chat responsif dengan streaming respons real-time (TTFT ≤ 650 ms).
  - Unggah lampiran gambar (PNG, JPG, WebP) dan dokumen dengan analisis visi.
  - Pemformatan Markdown kaya (tabel, blockquote, math, dan code highlight dengan tombol copy).
- [x] **P0-03: Web Search Augmented Responses & Grounding Citations**
  - Toggle Web Search di area input chat.
  - Tampilan status pencarian aktif (*"Searching the web..."*).
  - Kutipan bernomor interaktif (`[1]`, `[2]`) yang dapat diklik untuk membuka modal referensi sumber.
- [x] **P0-04: Multi-Agent Specialist Switcher**
  - Komponen pemilihan spesialis: *General Assistant*, *Business Analyst*, *Creative Writer / Art Director*.
  - Pergantian persona dinamis yang mengubah system prompt dan format keluaran tanpa reload.
- [x] **P0-05: AI Image Studio & Camera Roll Download**
  - Antarmuka pembuatan gambar Text-to-Image dengan preview shimmer loading.
  - Seleksi rasio aspek: `1:1 (Persegi)`, `16:9 (Lanskap)`, dan `9:16 (Vertikal/Story)`.
  - Tombol simpan ke galeri lokal / unduh berkas gambar biner (Web) dan integrasi Photo Library (iOS).
- [x] **P0-06: AI Video Lab berbasis Remotion Engine**
  - Story-to-Video sequencer dengan canvas Remotion Player `@remotion/player` 60 FPS.
  - Timeline kontrol: Play, Pause, Scrubber, Frame Counter, dan Aspect Ratio.
  - Sintesis audio narator ganda (*Dual-speaker TTS*: Suara Pria Ardi & Wanita Gadis).
  - Ekspor/Render MP4 H.264 (bersih untuk Pro/Admin, watermark untuk Consumer/Guest).
- [x] **P0-07: Hands-Free Voice Mode & Spatial Orb Visualizer**
  - Antarmuka audio dua arah layar penuh dengan visualisasi bola spasial fluida (Graphite Frost Orb).
  - Voice Activity Detection (VAD) otomatis berhenti mendengar pada keheningan ≥ 750 ms.
  - Fitur *Barge-in*: AI seketika memotong bicara saat pengguna berbicara kembali.
- [x] **P0-08: Unified Media Gallery & System Settings**
  - Grid terpadu menyimpan semua riwayat (Gambar, Video, Audio, Chat).
  - Pengaturan URL server endpoint kustom, API token auth, dan bersihkan cache media.
- [x] **P0-09: Desain Spasial VisionOS White / Graphite Frost**
  - Token visual spatial glass: sudut lengkung 24–32px, border specular glow 1px, backdrop blur 24px.
- [x] **P0-10: Paket Distribusi iOS Sideload (.ipa) & Interactive Simulator Staging**
  - Pipeline GitHub Actions CI/CD (`.github/workflows/build-ios.yml`) untuk build biner `.ipa`.
  - Simulator Staging berbasis browser dengan bingkai perangkat mobile interaktif.

### 3.2 Should-Have (P1 - Nilai Tambah Kritis v1.1)
- [x] **P1-01: Prompt Magic Enhancer**: Tombol 1-klik untuk mengoptimasi prompt teks menjadi prompt sinematik profesional.
- [x] **P1-02: Token & Resource Consumption Meter**: Indikator meteran grafis pemakaian token dan alokasi GPU.
- [x] **P1-03: Multiple Audio Visualizer Themes**: Pilihan tampilan visualizer (Spatial Fluid Sphere, Horizontal Waveform, Spectrum Bars).
- [x] **P1-04: Batch Download & Multi-Select Gallery**: Kemampuan memilih beberapa media sekaligus untuk ekspor ZIP.
- [x] **P1-05: Dark/Light Adaptive Spatial Glass**: Transisi halus antara tema Pure White Frost dan Deep Graphite Frost.

### 3.3 Could-Have (P2 - Fitur Sekunder Masa Depan)
- [ ] **P2-01: Custom Voice Cloning Profile**: Pengunggahan sampel suara 15 detik untuk replikasi suara pengguna.
- [ ] **P2-02: Collaborative Video Canvas**: Berbagi tautan proyek Remotion untuk penyuntingan bersama.
- [ ] **P2-03: Cloud Push Notification for Background Renders**: Notifikasi push saat video 4K berdurasi panjang selesai dirender.

### 3.4 Won't-Have (Batas Ruang Lingkup v1.0 / Anti-Scope Creep)
- [ ] Pengajuan ke Apple App Store publik berbayar (Fokus v1.0 adalah paket sideload `.ipa` via AltStore/SideStore/Scarlet dan Staging Simulator).
- [ ] Integrasi cluster AI on-premise luring (*air-gapped hardware*) tanpa jaringan.
- [ ] Payment gateway live banking (Menggunakan tier mockup simulation & balance demo untuk v1.0).

---

## 4. Kebutuhan Fungsional Rinci (Functional Requirements)

### Modul 1: Autentikasi, Profil & Quick Role Switcher
- **FR-01.1**: Sistem harus menyediakan formulir login berbasis email dan password dengan validasi format instan.
- **FR-01.2**: Sistem harus menyediakan komponen mengambang (*floating pill*) **Quick Switch Role** pada mode demo staging simulator.
- **FR-01.3**: Memilih role pada switcher (`Superadmin`, `Professional`, `Consumer`, `Guest`) harus memperbarui izin akses dan context aplikasi secara seketika (< 50 ms) tanpa memicu reload browser.
- **FR-01.4**: Sistem harus menerapkan *client-side route guard* dan *feature gate* yang mengunci atau menampilkan dialog promosi saat role non-otorisasi mencoba mengeksekusi fitur premium.

### Modul 2: Multimodal Chat AI & Multi-Agent Switcher
- **FR-02.1**: Antarmuka chat harus mendukung masukan teks panjang, serta lampiran multi-gambar (PNG, JPG, WebP hingga 10MB per file) dan berkas teks.
- **FR-02.2**: Respons asisten AI harus dialirkan menggunakan Server-Sent Events (SSE) dengan efek *smooth typing* dan TTFT ≤ 650 ms.
- **FR-02.3**: Pesan asisten harus memformat sintaks Markdown secara lengkap: tabel data, kutipan, daftar bertingkat, dan blok kode dengan penyorotan warna (*syntax highlighting*) dan tombol salin 1-klik.
- **FR-02.4**: Sistem harus menyediakan saklar toggle *Web Search*. Saat diaktifkan, sistem mengeksekusi penelusuran web dan menyematkan lencana kutipan (*grounding citation badges*) yang dapat diklik untuk menampilkan panel sumber rujukan.
- **FR-02.5**: Sistem harus menyediakan pemilih agen spesialis (*Multi-Agent Specialist Switcher*) dengan minimal 3 profil:
  1. *General Assistant*: Pembantu serbaguna, gaya bahasa kasual profesional.
  2. *Business Analyst*: Ahli analisis strategi, output berstruktur tabel, metrik KPI, dan pemisahan asumsi.
  3. *Creative Writer / Art Director*: Spesialis narasi sinematik, penyusunan naskah video, dan deskripsi visual kaya.
- **FR-02.6**: Pengguna dapat menghentikan streaming kapan saja (*Abort Stream*) dan memutar ulang pesan via Text-to-Speech (*Read Aloud*).

### Modul 3: AI Image Studio
- **FR-03.1**: Input studio menyediakan kolom *Prompt*, *Negative Prompt*, tombol *Prompt Enhance*, dan pemilihan rasio aspek:
  - `1:1` Square (1024x1024)
  - `16:9` Landscape (1280x720)
  - `9:16` Vertical Story / Reels (720x1280)
- **FR-03.2**: Pengguna dapat memilih preset gaya artistik: *VisionOS Spatial Glass*, *Photorealistic Cinematic*, *Anime 3D Shonen*, *Cyberpunk Neon*, dan *Minimalist Bauhaus*.
- **FR-03.3**: Role `Professional` dan `Superadmin` dapat mengatur parameter lanjutan: *Sampling Steps* (20–50), *CFG Scale* (1–20), dan *Seed Value*.
- **FR-03.4**: Saat generasi berlangsung, kartu preview menampilkan efek shimmer glass loading dinamis dengan perkiraan durasi (maksimal 10 detik).
- **FR-03.5**: Setiap gambar yang selesai digenerasi dapat diunduh langsung (*Download to Photos/Camera Roll*) sebagai berkas biner `.png` dan otomatis tersinkronisasi ke Media Gallery.

### Modul 4: AI Video Lab (Remotion Engine & Dual-Speaker Audio)
- **FR-04.1**: Sistem harus mengintegrasikan canvas Remotion Player (`@remotion/player`) untuk pemutaran sekuens video animasi 60 FPS secara mulus.
- **FR-04.2**: Pengguna dapat memilih template video dinamis: *Spatial Product Reveal*, *Bento Tech News*, *Cinematic Title Intro*, dan *Explainer Dialog*.
- **FR-04.3**: Sistem mendukung konfigurasi dialog dua pembicara (*Dual-Speaker TTS Audio*):
  - *Speaker A (Narator Pria)*: Suara `id-ID-ArdiNeural` / Aksen Berwibawa.
  - *Speaker B (Narator Wanita)*: Suara `id-ID-GadisNeural` / Aksen Ramah.
- **FR-04.4**: Editor Timeline menyediakan kontrol interaktif:
  - Scrubber penjelajah waktu dengan penanda detik dan nomor frame.
  - Tombol Play / Pause / Rewind / Fullscreen.
  - Editor teks per-scene yang memperbarui tampilan kanvas Remotion secara reaktif.
- **FR-04.5**: Ekspor Video:
  - Role `Superadmin` & `Professional`: Render video MP4 H.264 bersih tanpa watermark dengan resolusi penuh (1080p).
  - Role `Consumer` & `Guest`: Render video resolusi 720p dengan watermark transparan *"Hermes Super AI - Free Tier"*.

### Modul 5: Hands-Free Voice Mode
- **FR-05.1**: Mode suara menyediakan antarmuka imersif layar penuh dengan latar belakang *Graphite Frost Spatial Glass*.
- **FR-05.2**: Visualisasi audio dirender menggunakan kanvas bola spasial fluida (*Spatial Orb*) yang merespons secara dinamis terhadap amplitudo suara mikrofon pengguna dan output suara AI.
- **FR-05.3**: Voice Activity Detection (VAD) otomatis menghentikan status *Listening* dan beralih ke *Thinking* saat hening mencapai ambang batas ≥ 750 ms.
- **FR-05.4**: Transkrip percakapan dua arah ditampilkan secara live di bawah bola visualizer dengan tipografi kaca semi-transparan.
- **FR-05.5**: Kemampuan *Barge-in*: Saat AI sedang berbicara (*Speaking State*), jika pengguna mulai berbicara, audio AI seketika terputus (*immediate mute/abort*) dan sistem kembali ke *Listening State*.

### Modul 6: Unified Media Gallery & System Settings
- **FR-06.1**: Galeri menyajikan tata letak kisi (*masonry/bento grid*) dari seluruh aset yang digenerasi oleh pengguna (Gambar, Video Remotion, Klip Audio, Percakapan Chat).
- **FR-06.2**: Filter cepat berdasarkan tab kategori: `All`, `Images`, `Videos`, `Audio`, `Favorites`.
- **FR-06.3**: Pencarian real-time berdasarkan kata kunci prompt atau tag deskriptif.
- **FR-06.4**: Modal Inspeksi Detail: Menampilkan pratinjau media resolusi penuh, parameter metadata (Model, Prompt, Aspect Ratio, Seed, Timestamp), tombol Salin Prompt, Download, dan Hapus.
- **FR-06.5**: Panel System Settings:
  - Konfigurasi URL Endpoint Server Backend (khusus Pro/Admin).
  - Manajemen Secret Token Auth kustom.
  - Indikator penggunaan penyimpanan cache lokal dan tombol *Clear Media Cache*.

### Modul 7: Standar Visual VisionOS White / Graphite Frost
- **FR-07.1**: Seluruh panel, kartu, dan lembar modal harus menerapkan efek kaca buram (*frosted glass*) dengan `backdrop-filter: blur(24px) saturate(180%)`.
- **FR-07.2**: Border terluar setiap kartu menggunakan garis tepi specular `1px solid rgba(255, 255, 255, 0.25)` untuk menciptakan efek pembiasan cahaya spasial 3D.
- **FR-07.3**: Sudut kurvatur kartu dan dialog harus memiliki kelengkungan tinggi (*border-radius* 24px hingga 32px), dan tombol aksi utama menggunakan *rounded-full* (9999px).
- **FR-07.4**: Seluruh teks harus mempertahankan kontras rasio minimal 4.5:1 (WCAG AA) terhadap latar belakang kaca tembus pandang.

### Modul 8: Paket Mobile iOS (.ipa CI/CD) & Interactive Simulator Staging
- **FR-08.1**: Repositori harus memiliki alur kerja otomatis GitHub Actions (`.github/workflows/build-ios.yml`) yang memvalidasi build dan memproduksi biner iOS `.ipa` siap sideload (kompatibel dengan AltStore/SideStore/Scarlet).
- **FR-08.2**: Simulator Staging harus dapat dijalankan pada browser dengan viewport seluler responsif, membingkai tampilan antarmuka dalam frame perangkat iPhone/VisionOS lengkap dengan Safe Area dan Dynamic Island simulation.

---

## 5. User Stories & Acceptance Criteria Komprehensif (Gherkin Format)

Dokumen ini memetakan kriteria penerimaan fungsional secara 1:1 terhadap sasaran kriteria keberhasilan bisnis (AC-01 sampai AC-08):

---

### US-01: Multimodal Chat Streaming & Multi-Agent Switcher (Mapping: AC-01)
*Sebagai Pengguna (Consumer / Pro / Admin),*  
*Saya ingin berinteraksi dengan AI melalui pesan teks dan lampiran visual dengan respons streaming cepat serta dapat mengganti spesialis agen,*  
*Agar saya mendapatkan jawaban komprehensif yang sesuai dengan bidang analisis yang saya butuhkan tanpa jeda yang mengganggu.*

#### Skenario 1.1: Streaming SSE Berhasil dengan TTFT Cepat (Happy Path)
- **Given** Pengguna telah membuka modul Multimodal Chat.
- **When** Pengguna mengetik *"Rancang strategi go-to-market untuk produk SaaS AI"* dan menekan tombol Kirim.
- **Then** Waktu respon awal (*Time-To-First-Token / TTFT*) tercapai dalam waktu ≤ 650 ms.
- **And** Respons teks muncul secara bertahap (*streaming*) dengan animasi ketikan halus.
- **And** Format Markdown seperti bullet points, teks tebal, dan tabel dirender secara sempurna di atas panel kaca VisionOS.

#### Skenario 1.2: Analisis Gambar Multimodal (Happy Path)
- **Given** Pengguna berada di antarmuka Chat.
- **When** Pengguna melampirkan berkas gambar berformat PNG berukuran 2.5 MB dan menambahkan prompt *"Jelaskan komposisi visual arsitektur ini"*.
- **Then** Thumbnail gambar tampil di dalam bubble chat pengguna dengan sudut melengkung 16px.
- **And** Indikator status menampilkan *"Hermes sedang menganalisis visual..."*.
- **And** AI mengembalikan deskripsi mendalam mengenai elemen gambar tersebut.

#### Skenario 1.3: Validasi Batas Ukuran File Unggahan (Edge / Error Case)
- **Given** Pengguna berada di antarmuka Chat dengan role Consumer.
- **When** Pengguna mencoba mengunggah berkas gambar berukuran 12 MB (melebihi batas maksimal 5 MB untuk Consumer).
- **Then** Sistem menolak pengunggahan berkas tersebut.
- **And** Muncul notifikasi toast peringatan: *"Ukuran berkas melebihi batas maksimal 5 MB untuk akun Consumer. Tingkatkan ke Pro untuk kuota 10 MB."*.
- **And** Pesan tidak terkirim ke server.

#### Skenario 1.4: Pergantian Agen Spesialis (Multi-Agent Switcher)
- **Given** Pengguna berstatus `Professional` atau `Superadmin`.
- **When** Pengguna membuka pemilih agen dan beralih dari *"General Assistant"* ke *"Business Analyst"*.
- **Then** Lencana agen di bilah atas chat berubah menjadi *"Business Analyst"* dengan aksen warna Cyan Spatial.
- **And** Kueri berikutnya dijawab dengan pendekatan metodologi bisnis (swot, KPI matriks, kalkulasi ROI) tanpa memerlukan reload halaman.

---

### US-02: Web Search Augmented Responses & Grounding Citations (Mapping: AC-02)
*Sebagai Pengguna Riset,*  
*Saya ingin mengaktifkan pencarian web cerdas saat bertanya topik terkini,*  
*Agar jawaban yang saya terima didukung oleh fakta mutakhir yang dapat diverifikasi melalui tautan rujukan langsung.*

#### Skenario 2.1: Menghasilkan Jawaban dengan Kutipan Rujukan Web (Happy Path)
- **Given** Saklar toggle *Web Search* diaktifkan oleh pengguna.
- **When** Pengguna menanyakan *"Berapa perkiraan rilis headset Apple Vision Pro generasi kedua?"*.
- **Then** Sistem menampilkan indikator pencarian *"Mencari fakta di web..."* selama 1-2 detik.
- **And** Respons AI memuat minimal dua lencana kutipan numerik (misal: `[1]`, `[2]`).
- **When** Pengguna mengklik lencana `[1]`.
- **Then** Muncul modal kartu kaca (*Spatial Citation Popover*) yang memuat judul artikel rujukan, favicon, domain situs, dan cuplikan ringkasan berita aslinya.

#### Skenario 2.2: Penonaktifan Web Search untuk Inferensi Murni
- **Given** Saklar toggle *Web Search* dalam posisi nonaktif (*Off*).
- **When** Pengguna meminta pembuatan kode pemrograman Python algoritma sorting.
- **Then** Sistem langsung menjalankan model bahasa internal tanpa melakukan pemanggilan penelusuran jaringan eksternal.
- **And** Waktu latensi TTFT berkurang menjadi < 450 ms.

---

### US-03: Image Studio Generation & Camera Roll Download (Mapping: AC-03)
*Sebagai Kreator Konten Visual,*  
*Saya ingin membuat karya seni visual dengan rasio aspek tertentu dan mengunduhnya ke galeri perangkat,*  
*Agar saya memiliki materi grafis siap pakai untuk media sosial dan presentasi.*

#### Skenario 3.1: Generasi Gambar Rasio 9:16 Vertikal (Happy Path)
- **Given** Pengguna berada di tab AI Image Studio.
- **When** Pengguna memasukkan prompt *"Futuristic cybernetic city covered in frosted glass, cinematic lighting, 8k"*.
- **And** Pengguna memilih rasio aspek *"9:16 (Vertical Story)"* dan preset gaya *"VisionOS Spatial Glass"*.
- **And** Pengguna menekan tombol *"Generate Image"*.
- **Then** Area kanvas menampilkan kartu skeleton berkilau (*shimmer loading animation*).
- **And** Gambar beresolusi tajam selesai dirender dalam durasi ≤ 6 detik.
- **And** Gambar otomatis tersimpan ke dalam koleksi Media Gallery pengguna.

#### Skenario 3.2: Menyimpan Gambar ke Camera Roll / Photos (Platform Specific)
- **Given** Gambar hasil kreasi telah tampil di kanvas pratinjau.
- **When** Pengguna mengklik tombol *"Download to Photos / Camera Roll"*.
- **Then** Jika dijalankan pada browser Web/Simulator, berkas biner `.png` resolusi penuh diunduh ke folder Downloads.
- **And** Jika dijalankan pada aplikasi mobile iOS biner `.ipa`, sistem meminta izin akses Photo Library dan menyimpan gambar langsung ke album foto perangkat.
- **And** Notifikasi toast sukses muncul: *"Gambar berhasil disimpan ke Galeri Foto"*.

#### Skenario 3.3: Validasi Masukan Prompt Kosong (Validation Case)
- **Given** Kolom prompt teks dalam kondisi kosong.
- **When** Pengguna menekan tombol *"Generate Image"*.
- **Then** Tombol bergetar (*subtle shake animation*) dan tetap nonaktif.
- **And** Tampil pesan panduan: *"Silakan masukkan deskripsi visual terlebih dahulu"*.

---

### US-04: Video Lab Remotion MP4 Render & Dual-Speaker Audio (Mapping: AC-04)
*Sebagai Produser Konten Video,*  
*Saya ingin menyusun video narasi dengan dua pembicara otomatis dan mempratinjaunya pada player 60 FPS,*  
*Agar saya dapat memproduksi video edukasi pendek berkualitas siaran tanpa perangkat lunak editing eksternal.*

#### Skenario 4.1: Pratinjau Interaktif Timeline Remotion Player (Happy Path)
- **Given** Pengguna membuka modul AI Video Lab.
- **When** Pengguna memilih template *"Spatial Product Reveal"*.
- **Then** Remotion Player memuat kanvas video dengan frame rate stabil 60 FPS.
- **When** Pengguna menggeser slider scrubber ke detik ke-5 dan mengubah teks headline menjadi *"Revolusi Hermes Super AI"*.
- **Then** Pratinjau kanvas Remotion seketika memperbarui teks tersebut pada frame yang aktif secara reaktif tanpa re-render penuh.

#### Skenario 4.2: Render Video MP4 dengan Dual-Speaker Audio (Happy Path)
- **Given** Pengguna memasukkan naskah dialog dua karakter (Speaker A: Ardi, Speaker B: Gadis).
- **When** Pengguna berstatus `Professional` mengklik tombol *"Render High-Def MP4"*.
- **Then** Mesin Remotion memproses kompilasi video secara server-side/headless dalam durasi ≤ 45 detik untuk durasi 30 detik.
- **And** Berkas MP4 H.264 dihasilkan dengan sinkronisasi bibir/takarir teks yang selaras dengan pergantian suara narator pria dan wanita.
- **And** Video siap diputar pada pemutar inline (*Inline Video Player*) dengan kontrol Play, Volume, Scrubber, dan Fullscreen.

#### Skenario 4.3: Pembatasan Ekspor Watermark untuk Akun Free / Consumer (RBAC Guard)
- **Given** Pengguna saat ini berstatus `Consumer / General User`.
- **When** Pengguna mengklik tombol *"Render Video"*.
- **Then** Sistem menampilkan dialog konfirmasi: *"Akun Consumer akan menghasilkan video 720p dengan watermark resmi. Beralih ke Professional untuk render 1080p tanpa watermark."*.
- **When** Pengguna menyetujui, video dirender dengan watermark semi-transparan di pojok kanan bawah.

---

### US-05: Real-time Hands-Free Voice Mode & Soundwave Visualizer (Mapping: AC-05)
*Sebagai Pengguna Mobile yang Sedang Bergerak,*  
*Saya ingin berbicara santai dengan asisten suara tanpa harus menahan tombol mikrofon,*  
*Agar saya dapat melakukan sesi brainstorming hands-free layaknya berbincang dengan mitra manusia.*

#### Skenario 5.1: Memulai Percakapan Suara Hands-Free (Happy Path)
- **Given** Pengguna mengklik tombol mikrofon mengambang untuk masuk ke Voice Mode.
- **When** Izin mikrofon browser/iOS disetujui.
- **Then** Tampilan bertransisi ke kanvas imersif *Graphite Frost Spatial Glass*.
- **And** Bola visualizer (*Spatial Orb*) aktif berdenyut lembut pada status *"Listening..."*.
- **When** Pengguna berbicara *"Jelaskan konsep arsitektur microservices dalam 3 poin singkat"*.
- **Then** Amplitudo bola visualizer membesar selaras dengan gelombang frekuensi vokal pengguna.

#### Skenario 5.2: Deteksi Keheningan Otomatis (VAD 750ms)
- **Given** Pengguna selesai mengucapkan kalimat pertanyaan.
- **When** Terjadi keheningan selama ≥ 750 ms.
- **Then** Sistem VAD otomatis mengunci input suara, mengubah status bola visualizer menjadi *"Thinking..."* dengan gradien cahaya Vision Violet.
- **And** Dalam waktu ≤ 900 ms, audio sintesis suara mulai berbicara (*Speaking State*) dan transkrip teks percakapan muncul live di layar.

#### Skenario 5.3: Pemotongan Pembicaraan Instan (Barge-in / Cut-off)
- **Given** Asisten AI sedang berada dalam status *"Speaking"* dan memutar penjelasan panjang.
- **When** Pengguna menyela dengan berkata *"Cukup, langsung ke poin kedua saja"*.
- **Then** Sistem segera menghentikan pemutaran audio AI seketika (*instant abort*).
- **And** Bola visualizer kembali ke status *"Listening..."* siap memproses instruksi terbaru pengguna.

---

### US-06: RBAC Matrix & Demo Quick Switch Role (Mapping: AC-06)
*Sebagai Klien / Evaluator Sistem,*  
*Saya ingin beralih peran pengguna secara instan melalui bilah mengambang di Staging Simulator,*  
*Agar saya dapat menguji seluruh tingkatan hak akses (Superadmin, Professional, Consumer, Guest) tanpa membuang waktu registrasi atau login berulang.*

#### Skenario 6.1: Beralih ke Role Superadmin (Happy Path)
- **Given** Pengguna berada pada Interactive Staging Simulator dengan role aktif `Guest`.
- **When** Pengguna mengklik *Quick Role Switcher Pill* dan memilih opsi *"Superadmin"*.
- **Then** Lencana peran di pojok kanan atas berubah menjadi *"Superadmin"* berwarna Electric Cyan.
- **And** Menu navigasi *"System Settings & Analytics"* seketika muncul di navigasi sidebar.
- **And** Form konfigurasi Server Endpoint URL dan Token terbuka untuk diedit.

#### Skenario 6.2: Beralih ke Role Consumer & Validasi Proteksi Fitur (RBAC Guard)
- **Given** Pengguna beralih peran ke *"Consumer"*.
- **When** Pengguna membuka menu *System Settings*.
- **Then** Kolom isian *Server Endpoint URL* dalam status read-only terkunci dengan lencana gembok.
- **And** Muncul catatan: *"Pengaturan server endpoint hanya dapat dimodifikasi oleh Superadmin atau Professional"*.

---

### US-07: Konsistensi Desain VisionOS White / Graphite Frost (Mapping: AC-07)
*Sebagai Pengguna Antarmuka Spasial,*  
*Saya ingin merasakan desain kaca modern yang tembus pandang, bersih, dengan kontras tinggi,*  
*Agar kenyamanan visual terjaga baik dalam sesi kerja siang hari maupun malam hari.*

#### Skenario 7.1: Penerapan Material Spatial Glass dan Refraksi Specular Border
- **Given** Pengguna menavigasi ke halaman manapun di aplikasi Hermes Super AI.
- **Then** Seluruh kartu kontainer menerapkan properti `backdrop-filter: blur(24px) saturate(180%)`.
- **And** Sudut setiap kartu memiliki kurvatur tinggi antara 24px hingga 32px.
- **And** Garis batas (*border*) menampilkan kilau tipis 1px semitransparan `rgba(255, 255, 255, 0.25)` yang menyerupai kaca optik Apple VisionOS.

#### Skenario 7.2: Verifikasi Rasio Kontras Aksesibilitas (WCAG AA Compliance)
- **Given** Aplikasi berjalan pada mode *Graphite Frost* maupun *White Frost*.
- **When** Dilakukan audit kontras warna pada teks judul, label tombol, dan bubble teks chat.
- **Then** Rasio kontras teks terhadap latar belakang kaca blur terbukti ≥ 4.5:1 untuk teks normal dan ≥ 3:1 untuk teks besar, memenuhi kepatuhan standar WCAG AA.

---

### US-08: Paket iOS Sideload (.ipa CI/CD) & Interactive Staging Simulator (Mapping: AC-08)
*Sebagai Pengembang & Penguji Aplikasi Seluler,*  
*Saya ingin berkas repositori menghasilkan biner iOS .ipa siap sideload via GitHub Actions dan dapat diuji pada web staging simulator,*  
*Agar proses verifikasi pada perangkat iPhone nyata maupun pratinjau browser dapat dilakukan tanpa hambatan sertifikat pengembang berbayar.*

#### Skenario 8.1: Validasi Workflow Kompilasi GitHub Actions (.ipa)
- **Given** Terdapat commit perubahan baru pada branch utama repositori.
- **When** Alur kerja `.github/workflows/build-ios.yml` dipicu di GitHub Actions.
- **Then** Langkah kompilasi menyelesaikan build seluler dan menghasilkan artefak berkas biner `HermesSuperAI.ipa` yang valid dalam daftar build artifacts.
- **And** Berkas biner tersebut dapat diinstal melalui alat sideload populer (AltStore, SideStore, atau Scarlet).

#### Skenario 8.2: Operasi Interaktif pada Web Staging Simulator
- **Given** Penguji membuka tautan simulator staging `/staging/hermes-super-ai/` di browser web modern.
- **Then** Simulator memuat frame bingkai perangkat bergerak (iPhone mockup) dengan bezel dan rasio layar yang proporsional.
- **And** Seluruh fungsi 5 pilar (Chat, Image Studio, Video Lab, Voice Mode, Gallery) dapat berinteraksi secara mulus tanpa galat fatal pada konsol JavaScript.

---

## 6. Spesifikasi Desain, Token Visual & Komponen Spatial Glass

### 6.1 Tabel Token Desain VisionOS White / Graphite Frost

```json
{
  "theme": "VisionOS Spatial Glass",
  "tokens": {
    "colors": {
      "surface_white_frost": "rgba(255, 255, 255, 0.65)",
      "surface_graphite_frost": "rgba(28, 28, 30, 0.75)",
      "surface_glass_modal": "rgba(20, 20, 24, 0.85)",
      "border_specular_light": "rgba(255, 255, 255, 0.25)",
      "border_specular_dark": "rgba(255, 255, 255, 0.12)",
      "accent_cyan_glow": "#38bdf8",
      "accent_violet_glow": "#818cf8",
      "accent_amber_glow": "#f59e0b",
      "text_primary_light": "#0f172a",
      "text_primary_dark": "#f8fafc",
      "text_secondary_muted": "rgba(226, 232, 240, 0.65)"
    },
    "effects": {
      "backdrop_blur": "blur(24px) saturate(180%)",
      "backdrop_blur_heavy": "blur(40px) saturate(200%)",
      "shadow_spatial_float": "0 20px 50px -10px rgba(0, 0, 0, 0.35)",
      "shadow_glow_cyan": "0 0 25px rgba(56, 189, 248, 0.45)",
      "shadow_glow_violet": "0 0 25px rgba(129, 140, 248, 0.45)"
    },
    "geometry": {
      "radius_card_outer": "28px",
      "radius_card_inner": "20px",
      "radius_modal": "32px",
      "radius_pill_button": "9999px",
      "border_width_specular": "1px"
    },
    "animation": {
      "spring_gentle": "cubic-bezier(0.16, 1, 0.3, 1)",
      "duration_hover": "200ms",
      "duration_modal": "350ms"
    }
  }
}
```

### 6.2 Hirarki Komponen Utama UI/UX
1. **`SpatialHeaderBar`**: Bilah navigasi atas transparan memuat Logo Hermes Super AI, Status Koneksi Bridge, Kuota Token, dan *Role Switcher Pill*.
2. **`BentoNavigationDock`**: Bilah navigasi bawah mengambang (*floating blur dock*) untuk berpindah antara 5 layar utama:
   - `Tab 1: Chat Multimodal`
   - `Tab 2: Image Studio`
   - `Tab 3: Video Lab`
   - `Tab 4: Voice Mode`
   - `Tab 5: Gallery & Settings`
3. **`RemotionPlayerCanvas`**: Komponen pembungkus player video Remotion yang dilengkapi bilah scrubbing interaktif dan penanda timestamp frame.
4. **`SpatialVoiceOrb`**: Komponen kanvas audio WebGL/2D yang memvisualisasikan gelombang suara 3D dengan partikel pendaran kaca.

---

## 7. Arsitektur API Backend Bridge, Protokol Streaming & Konfigurasi Lingkungan

### 7.1 Daftar Endpoint REST & Streaming API (Production Bridge)

| Method | Endpoint Route | Role Akses | Deskripsi & Kontrak Payload |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/v1/auth/login` | Public | Autentikasi kredensial pengguna. Mengembalikan token JWT dan profil peran. |
| `POST` | `/api/v1/auth/role-switch` | All (Demo) | Endpoint peralihan cepat peran simulator (`target_role`). Mengembalikan session sementara. |
| `GET` | `/api/v1/user/profile` | Consumer+ | Mengambil profil pengguna aktif, sisa kuota komputasi, dan role saat ini. |
| `POST` | `/api/v1/chat/completions` | Consumer+ | Endpoint streaming percakapan teks & multimodal melalui protokol Server-Sent Events (SSE). |
| `POST` | `/api/v1/chat/search` | Consumer+ | Endpoint penelusuran web cerdas. Mengembalikan ringkasan data fakta beserta rujukan sitasi. |
| `POST` | `/api/v1/image/generate` | Consumer+ | Memicu komputasi text-to-image. Parameter: `prompt`, `aspect_ratio`, `style_preset`, `seed`. |
| `POST` | `/api/v1/video/remotion/render` | Pro, Admin | Memicu kompilasi server-side Remotion video MP4. Parameter: `script_scenes`, `voice_a`, `voice_b`. |
| `GET` | `/api/v1/video/status/:jobId` | Consumer+ | Polling status kompilasi render video Remotion (`queued`, `rendering`, `completed`, `failed`). |
| `GET` | `/api/v1/gallery/assets` | Consumer+ | Mengambil daftar aset galeri tersimpan dengan parameter filter kategori, pencarian, dan pagination. |
| `DELETE`| `/api/v1/gallery/assets/:id` | Pro, Admin | Menghapus aset media tertentu dari database galeri pengguna. |
| `GET` | `/api/v1/system/health` | Public | Healthcheck endpoint backend bridge dan engine konektor Hermes runtime. |
| `POST` | `/api/v1/system/settings` | Admin Only | Memperbarui endpoint URL server backend, secret auth token, dan manajemen alokasi cache. |

### 7.2 Struktur Berkas Variabel Lingkungan (`.env.example`)

```ini
# ========================================================
# HERMES SUPER AI - PRODUCTION & SIMULATOR RUNTIME CONFIG
# ========================================================

# Host Server & Jaringan
PORT=3000
NODE_ENV=production
API_BASE_URL=http://localhost:3000
ALLOWED_CORS_ORIGIN="*"

# Hermes Core Agent Runtime Integration
HERMES_API_ENDPOINT=http://127.0.0.1:8642
HERMES_API_SECRET_TOKEN=super_hermes_secure_token_change_in_prod

# Feature Flags Sistem
ENABLE_WEB_SEARCH=true
ENABLE_VIDEO_REMOTION=true
ENABLE_VOICE_MODE=true
ENABLE_DEMO_ROLE_SWITCHER=true

# Remotion Video Engine Rendering
REMOTION_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
REMOTION_MAX_CONCURRENCY=2
VIDEO_RENDER_TIMEOUT_MS=60000
OUTPUT_MEDIA_DIR=/home/devcurl/workspace-webui/hermes-super-ai/storage/media

# Sintesis Audio & Voice Activity Detection (VAD)
TTS_DEFAULT_VOICE_A=id-ID-ArdiNeural
TTS_DEFAULT_VOICE_B=id-ID-GadisNeural
VAD_SILENCE_TIMEOUT_MS=750

# Client Simulator Staging
VITE_APP_NAME="Hermes Super AI"
VITE_THEME_DEFAULT=graphite-frost
VITE_ENABLE_MOCK_FALLBACK=true
```

---

## 8. Matriks Skenario Pengujian Menyeluruh (End-to-End Test Matrix)

Matriks berikut menguji secara ketat kesesuaian implementasi terhadap kriteria penerimaan fungsional, performa, keamanan, dan pengalaman pengguna:

| Test Case ID | Modul Sasaran | Deskripsi Skenario Uji | Prosedur Langkah Pengujian | Ekspektasi Hasil Uji | Kriteria Sukses (AC) | Tingkat Keparahan |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-01** | Chat Streaming | Streaming SSE Real-time & Latensi Respons | 1. Ketik prompt pada chat.<br>2. Kirim pesan dan mulai timer.<br>3. Amati kedatangan token awal. | Token pertama diterima di layar dalam waktu ≤ 650 ms; teks mengalir kontinu tanpa lag visual. | AC-01 (KPI-01) | Critical (P0) |
| **TC-02** | Agent Switcher | Pergantian Profil Agen Spesialis | 1. Buka dropdown agent switcher.<br>2. Pilih "Business Analyst".<br>3. Kirim pertanyaan komparasi produk. | Format respon seketika mengadopsi persona analis bisnis; sistem prompt ter-update tanpa reload halaman. | AC-01 | High (P0) |
| **TC-03** | Web Search | Penelusuran Web & Verifikasi Kutipan | 1. Aktifkan toggle Web Search.<br>2. Tanyakan berita terkini.<br>3. Klik lencana sitasi [1]. | Indikator pencarian muncul; respon menyertakan minimal 1 sitasi yang menampilkan modal rujukan URL valid. | AC-02 | High (P0) |
| **TC-04** | Image Studio | Generasi Gambar Rasio 16:9 & Preset Style | 1. Masukkan prompt gambar.<br>2. Pilih rasio 16:9 & preset VisionOS.<br>3. Klik Generate. | Kartu loading shimmer aktif; gambar selesai dirender ≤ 6 detik dan tersimpan otomatis ke galeri. | AC-03 (KPI-02) | Critical (P0) |
| **TC-05** | Image Studio | Unduh ke Photos / Camera Roll | 1. Buka pratinjau gambar.<br>2. Klik tombol "Download to Photos". | Berkas `.png` biner terunduh di browser; memicu integrasi album foto jika pada aplikasi seluler. | AC-03 | Critical (P0) |
| **TC-06** | Video Lab | Interaktivitas Timeline Remotion Player | 1. Buka Video Lab.<br>2. Ubah teks adegan pada editor.<br>3. Geser scrubber timeline dan tekan Play. | Player Remotion 60 FPS reaktif merefleksikan perubahan teks seketika tanpa re-render manual. | AC-04 | Critical (P0) |
| **TC-07** | Video Lab | Render Video MP4 & Audio Dual-Speaker | 1. Input naskah 2 pembicara.<br>2. Tekan tombol Render Video (Role Pro).<br>3. Putar di inline player. | Video MP4 terkompilasi ≤ 45 detik; dialog narator pria dan wanita terdengar bergantian selaras takarir. | AC-04 (KPI-03) | Critical (P0) |
| **TC-08** | Video Lab | Penegakan Watermark pada Role Consumer | 1. Alihkan role ke Consumer.<br>2. Lakukan render video.<br>3. Periksa berkas keluaran. | Video hasil render memuat watermark semi-transparan "Hermes Super AI - Free Tier" di sudut layar. | AC-04 | High (P1) |
| **TC-09** | Voice Mode | Interaksi Suara Hands-free & Deteksi VAD | 1. Masuk ke Voice Mode.<br>2. Ucapkan pertanyaan via mikrofon.<br>3. Diam selama ≥ 750 ms. | Bola spasial bereaksi terhadap suara; VAD mengalihkan status ke Thinking setelah 750ms; AI membalas suara ≤ 900ms. | AC-05 (KPI-04) | Critical (P0) |
| **TC-10** | Voice Mode | Pengujian Fitur Pemotongan Suara (Barge-in) | 1. Saat AI sedang berbicara, potong dengan ucapan baru pengguna.<br>2. Amati pemutaran audio AI. | Audio AI seketika berhenti memutar dan visualizer kembali ke status mendengarkan (*Listening*). | AC-05 | Critical (P0) |
| **TC-11** | Quick Switcher | Reaktivitas Pergantian Role & Guard RBAC | 1. Klik Quick Role Switcher Pill.<br>2. Pilih bergantian 4 peran.<br>3. Verifikasi ketersediaan menu admin. | Status aplikasi berganti seketika; menu Settings & Analytics hanya dapat diakses oleh Superadmin. | AC-06 | Critical (P0) |
| **TC-12** | Desain VisionOS | Pengujian Rasio Kontras Aksesibilitas | 1. Inspeksi elemen teks pada latar kaca blur.<br>2. Hitung rasio kontras warna. | Seluruh teks penting lulus standar kontras minimal WCAG AA (rasio ≥ 4.5:1 terhadap background blur). | AC-07 (KPI-06) | High (P0) |
| **TC-13** | CI/CD & Build | Validasi Kompilasi Artefak iOS `.ipa` | 1. Trigger alur kerja `.github/workflows/build-ios.yml`.<br>2. Periksa output artefak build. | Alur kerja sukses 100% tanpa error; artefak biner `.ipa` siap sideload berhasil dipublikasikan. | AC-08 (KPI-05) | Critical (P0) |

---

## 9. Matriks Keterlacakan Kebutuhan (Requirements Traceability Matrix)

| Kebutuhan Bisnis (BRD) | Kriteria Sukses (AC) | Fitur PRD | User Story | Skenario Uji | Status Eksekusi |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Multimodal AI Assistant | AC-01 (TTFT ≤ 650ms) | P0-02 (Chat SSE) & P0-04 (Agent Switcher) | US-01 | TC-01, TC-02 | Baseline Disetujui |
| Grounding Knowledge Citations | AC-02 (Citations modal) | P0-03 (Web Search Integration) | US-02 | TC-03 | Baseline Disetujui |
| Text-to-Image Creation Studio | AC-03 (Render ≤ 6s, Camera Roll) | P0-05 (Image Studio & Download) | US-03 | TC-04, TC-05 | Baseline Disetujui |
| Story-to-Video Remotion Engine | AC-04 (Render ≤ 45s, Dual TTS) | P0-06 (Video Lab & Player) | US-04 | TC-06, TC-07, TC-08 | Baseline Disetujui |
| Real-time Audio Conversation | AC-05 (Latency ≤ 900ms, VAD) | P0-07 (Voice Mode & Barge-in) | US-05 | TC-09, TC-10 | Baseline Disetujui |
| Tata Kelola Akses Multi-Peran | AC-06 (4 Role Matrix, Quick Switch) | P0-01 (RBAC & Role Switcher Pill) | US-06 | TC-11 | Baseline Disetujui |
| Estetika Spasial Apple VisionOS | AC-07 (Glassmorphism, WCAG AA) | P0-09 (VisionOS White/Graphite Frost) | US-07 | TC-12 | Baseline Disetujui |
| Distribusi Sideload Seluler | AC-08 (GitHub CI/CD .ipa build) | P0-10 (iOS Workflow & Staging Frame) | US-08 | TC-13 | Baseline Disetujui |

---

## 10. Panduan Handoff Rekayasa Lintas Tim

Dokumen ini menjadi pedoman spesifikasi resmi bagi spesialis-spesialis rekayasa lanjutan:

1. **Ke `team-ux-ui` (UI/UX Designer & Art Director)**:
   - Terapkan token desain spatial glass pada Bab 6 ke dalam aset visual, mockups, dan simulator interaktif.
   - Buat ikon aplikasi (*App Icon*) bertema VisionOS White / Graphite Frost dengan kedalaman 3D dan kurvatur khas Apple.
2. **Ke `team-architect` (System Architect)**:
   - Desain arsitektur teknis client-server, pipeline rendering Remotion berkinerja tinggi, alur Web Speech API/AudioContext, dan skema caching media.
3. **Ke `team-engineer` (Software Engineer)**:
   - Implementasikan antarmuka frontend seluler dan web, komponen `@remotion/player`, store state RBAC reaktif, alur kerja GitHub Actions `.github/workflows/build-ios.yml`, serta backend bridge REST & SSE streaming.
4. **Ke `team-qa-security` (QA & Security Auditor)**:
   - Lakukan verifikasi pengujian berbasis skenario TC-01 hingga TC-13 dan audit keamanan RBAC sebelum status rilis produksi diberikan.

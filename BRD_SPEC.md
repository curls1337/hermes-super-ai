# Business Requirements Document (BRD) & Matriks RBAC
## Aplikasi: Hermes Super AI (Mobile iOS & Web App)

**Versi Dokumen:** 1.0  
**Tanggal:** 12 November 2026  
**Slug Proyek:** `hermes-super-ai`  
**Target Platform:** Mobile iOS (`.ipa` sideload distribution via GitHub CI/CD), *Interactive Simulator Staging*, dan Backend Bridge API  
**Tema Desain:** VisionOS White / Graphite Frost (Apple Spatial Glass, Minimalis, Super Bersih, Kontras Presisi, Glassmorphism, *High Rounded Curvature*)  
**Penyusun:** Business Analyst (`team-business-analyst`)  
**Status Dokumen:** Siap Ditinjau & Dieksekusi Arsitek, UI/UX Designer, & Software Engineer  

---

## 0. Klasifikasi Kebutuhan: FACT vs ASSUMPTION vs PROPOSAL

Untuk menjamin kepatuhan tata kelola kebutuhan bisnis, seluruh poin spesifikasi diklasifikasikan ke dalam tiga tingkatan kepastian:

| Kategori | Deskripsi & Ruang Lingkup | Status Validasi |
| :--- | :--- | :--- |
| **FACT** | Kebutuhan inti yang telah disetujui dalam brief: <br>1. Nama aplikasi **Hermes Super AI** (Mobile iOS & Web App).<br>2. Lima pilar kemampuan: (1) Multimodal Chat AI (Real-time SSE Streaming, Web Search, Multi-Agent Specialist Switcher); (2) Image Generation & Studio (Prompt to Image, Aspect Ratio Selector, Download to Photos/Camera Roll); (3) Video Lab Generation (Text/Story to Video, Remotion Native Render MP4, Dual-speaker TTS Audio, Inline Video Player); (4) Voice Mode (Hands-free Conversational Audio Interface ala ChatGPT Advanced Voice); (5) Gallery / Vault & System Settings (API Server URL, Token Auth, Storage).<br>3. Paket pengiriman mencakup Mobile iOS (.ipa via GitHub CI/CD), Interactive Simulator Staging, dan Backend Bridge API.<br>4. Bahasa desain visual adalah **VisionOS White / Graphite Frost** (Apple Spatial Glass, blur effect, kurvatur sudut tinggi 24–32px).<br>5. Identitas visual resmi mencakup pembuatan **Logo & App Icon khusus** berstandar Apple HIG (Squircle 1024x1024, transparan/refraksi es, elegan, dan mudah dikenali). | **Terkonfirmasi (Brief Pemilik)** |
| **ASSUMPTION** | 1. Backend Bridge API berjalan pada arsitektur hybrid Node.js/TypeScript atau Python FastAPI yang menjembatani klien mobile/web dengan Hermes Core agent runtime.<br>2. Mesin TTS dual-speaker memanfaatkan kombinasi suara pria dan wanita (misal model Edge TTS atau ElevenLabs/OpenAI TTS kompatibel) untuk dialog narasi Video Lab.<br>3. Remotion render engine berjalan secara server-side pada backend bridge atau headless container chromium untuk menghasilkan berkas MP4 H.264 standar.<br>4. Fitur "Download to Camera Roll" pada browser/simulator mengunduh file biner media langsung, sedangkan pada native iOS menggunakan integrasi photo library permission (`PHPhotoLibrary`). | **Asumsi Teknis (Perlu review Arsitek)** |
| **PROPOSAL** | 1. **Demo Role Quick Switcher:** Panel mengambang (*floating pill*) pada Interactive Simulator Staging yang memungkinkan evaluator beralih peran instan (`Superadmin`, `Professional`, `Consumer`, `Guest`) tanpa relogin.<br>2. **Spatial Voice Orb Visualizer:** Animasi gelombang audio 3D/fluid canvas responsif terhadap amplitude STT/TTS pada Voice Mode.<br>3. **Vault Hybrid Storage:** Sinkronisasi cerdas antara penyimpanan lokal (IndexedDB/CoreData) dengan cache server untuk operasi offline-first berkinerja tinggi. | **Usulan Analis (Menunggu Persetujuan Pemilik)** |

---

## 1. Ringkasan Eksekutif, Masalah Bisnis & Proposisi Nilai

### 1.1 Latar Belakang & Masalah Bisnis
Adopsi teknologi kecerdasan buatan generatif saat ini masih terfragmentasi ke dalam layanan-layanan silo yang terpisah:
1. **Fragmentasi Alat Kreatif:** Pengguna harus berganti-ganti aplikasi antara antarmuka teks (chat), generator gambar, studio render video, dan asisten suara interaktif. Hal ini menyebabkan hilangnya konteks percakapan dan menurunkan produktivitas.
2. **Ketiadaan Spesialisasi Agen Multi-Domain:** Kebanyakan aplikasi chat AI bersifat monolitik satu persona, tidak memiliki kemampuan berganti spesialis (misal Business Analyst, System Architect, Creative Director, Financial Researcher) dalam satu sesi terpadu.
3. **Kompleksitas Produksi Video Narasi:** Pembuatan video vertikal (Reels/Shorts/TikTok) atau presentasi berbasis cerita memerlukan penggabungan manual naskah, sintesis suara dua pembicara (*dual-speaker conversation*), perakitan frame, dan rendering video yang memakan waktu lama.
4. **Antarmuka Mobile yang Kaku:** Kebanyakan aplikasi AI mobile menyajikan tampilan web-view datar tanpa sentuhan estetika spasial modern, respons haptik, dan interaksi suara *hands-free* instan.
5. **Privasi & Portabilitas Server:** Profesional dan kreator membutuhkan kontrol mandiri terhadap endpoint API, token otentikasi kustom, serta penyimpanan lokal untuk aset galeri/vault mereka.

### 1.2 Proposisi Nilai (*Value Proposition*)

#### A. Segmen Konsumen (*General Consumer / Everyday Creator*)
- **All-in-One Super Assistant:** Menggabungkan pencarian fakta web cerdas, pembuatan gambar artistik dalam berbagai rasio (1:1, 16:9, 9:16), dan percakapan suara alami tanpa mengetik (*hands-free voice mode*).
- **Pengalaman VisionOS Elegan:** Tampilan antarmuka *Apple Spatial Glass* yang sangat bersih, transparan dengan efek refraksi es (*Graphite Frost*), kurvatur lembut, dan respons visual mikro yang memanjakan mata.
- **Simpan Langsung ke Galeri HP:** Hasil kreasi gambar dan video dapat disimpan langsung ke Camera Roll perangkat dengan satu sentuhan.

#### B. Segmen Profesional (*Power Creator, Researcher, & Business Specialist*)
- **Multi-Agent Specialist Switcher:** Beralih konteks analisis secara instan ke peran spesialis tertentu dengan persona teroptimasi.
- **Video Lab Remotion Native:** Menghasilkan video narasi beranimasi tajam dengan narator ganda (dual-speaker) langsung menjadi berkas MP4 beresolusi tinggi tanpa aplikasi editing video terpisah.
- **Grounding Citations & Web Search:** Setiap jawaban berbasis pencarian dilengkapi tautan rujukan dan kutipan yang dapat diverifikasi (*auditable knowledge*).
- **Kustomisasi API & Kedaulatan Data:** Fleksibilitas menghubungkan aplikasi ke server backend kustom atau instance Hermes mandiri, dengan manajemen token privat dan ekspor vault.

### 1.3 Indikator Keberhasilan Bisnis (*Business KPIs*)

| ID KPI | Metrik Utama | Target Keberhasilan |
| :--- | :--- | :--- |
| **KPI-01** | *Time-to-First-Token (TTFT)* pada Chat SSE Streaming | ≤ 650 ms dari pengiriman prompt hingga token pertama muncul di layar. |
| **KPI-02** | Kecepatan Generasi Gambar di Studio | ≤ 6 detik untuk render visual resolusi standar (1024x1024 / 9:16). |
| **KPI-03** | Waktu Rendering Remotion Video Lab | ≤ 45 detik untuk video berdurasi 30 detik (MP4 1080p dengan audio dual-speaker). |
| **KPI-04** | Latensi Voice Mode Interaktif (Barge-in / Voice-to-Voice) | ≤ 900 ms antara henti bicara pengguna dan respon suara pertama. |
| **KPI-05** | Tingkat Keberhasilan Sideload iOS (.ipa CI/CD) | 100% build otomatis sukses menghasilkan artefak `.ipa` valid pada setiap rilis Git. |
| **KPI-06** | Kepuasan Evaluasi Tampilan (*Visual Polish Score*) | ≥ 95% pemangku kepentingan menyetujui estetika *VisionOS White / Graphite Frost*. |

---

## 2. Definisi Role & Matriks Hak Akses (RBAC Matrix)

### 2.1 Definisi Role Pengguna

1. **`Superadmin / System Owner`**
   - Pemilik platform dengan hak wewenang penuh atas seluruh konfigurasi sistem, audit log, manajemen kuota/token, pemilihan default engine, pengaturan server endpoint, serta kemampuan manajemen data vault sistem secara menyeluruh.
2. **`Professional / Creator (Power User)`**
   - Pengguna tingkat mahir (kreator konten, analis, manajer produk). Memiliki akses penuh ke *Multi-Agent Specialist Switcher*, pembuatan video tingkat lanjut di *Video Lab* (Remotion render tak terbatas durasi standar, pengaturan suara narator ganda kustom), pengaturan resolusi gambar ultra, dan konfigurasi API server kustom personal.
3. **`Consumer / General User`**
   - Pengguna harian yang memanfaatkan chat AI multimodal, pencarian web cerdas, pembuatan gambar rasio standar, mode suara *hands-free*, penyimpanan ke Camera Roll lokal, dan rendering video lab berbasis template kurasi harian.
4. **`Guest / Demo (Staging Simulator)`**
   - Akses publik atau tamu pada *Interactive Simulator Staging*. Memiliki batasan frekuensi eksekusi (*rate limit*), namun dapat mencoba seluruh fitur dengan sampel data terisi (*pre-seeded showcases*). Pada simulator, role ini didukung fitur **Quick Switch Role**.

> **Mekanisme Quick Switch Role (Khusus Staging / Interactive Simulator):**  
> Pada bilah status atas Simulator Staging, disediakan komponen *Role Switcher Pill*. Penguji dapat memilih salah satu dari 4 role dengan satu ketukan. Sistem secara reaktif mengubah status antarmuka, membuka/menutup fitur terkunci, dan menampilkan lencana role aktif (`Admin`, `Pro`, `User`, `Guest`).

### 2.2 Matriks Hak Akses CRUD & Fitur (RBAC Matrix)

**Keterangan Izin:**
- **C** = Create (Buat / Kirim / Generate)
- **R** = Read (Lihat / Tampilkan / Putar)
- **U** = Update (Ubah / Modifikasi)
- **D** = Delete (Hapus / Bersihkan)
- **X** = Execute / Export (Unduh / Render / Ekspor)
- **—** = Tidak Diizinkan (*Forbidden / Blocked by Guard*)

| Modul & Fitur | `Superadmin` | `Professional` | `Consumer` | `Guest / Demo` | Aturan Validasi & Scope Guard |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **1. Multimodal Chat AI** | | | | | |
| - Kirim Pesan & SSE Real-time Streaming | C, R | C, R | C, R | C, R (Rate-limit 10/sesi) | Guard memvalidasi ketersediaan token API atau kuota demo. |
| - Multi-Agent Specialist Switcher | C, R, U | C, R, U | R (Default agent) | R (Preset contoh) | Non-Pro terkunci pada agen Default; Pro bebas memilih spesialis. |
| - Unggah File & Gambar ke Chat | C, R, D | C, R, D | C, R, D (Max 5MB) | C, R (Max 2MB, no save) | Validasi MIME type: PNG, JPEG, WebP, PDF. |
| - Ekspor & Hapus Riwayat Percakapan | R, D, X | R, D, X | R, D, X | R (Sesi sementara) | Tamu tidak dapat menghapus riwayat sistem permanen. |
| **2. Web Search & Grounding Citations** | | | | | |
| - Toggle Web Search Aktif/Nonaktif | C, R, U | C, R, U | C, R, U | R (Selalu aktif default) | Melakukan kueri pencarian eksternal untuk memperbarui fakta. |
| - Akses Tautan Sumber & Verifikasi Kutipan | R, X | R, X | R, X | R, X | Membuka link referensi di in-app modal atau browser eksternal. |
| **3. Image Generation & Studio** | | | | | |
| - Generate Gambar dari Teks Prompt | C, R | C, R | C, R | C, R (Max 3/hari) | Mendukung generator provider aktif. |
| - Pemilihan Aspect Ratio (1:1, 16:9, 9:16) | C, U | C, U | C, U | C, U | Mengatur canvas frame rasio generator visual. |
| - Download to Camera Roll / iOS Photos | X | X | X | X (Watermarked demo) | Memicu API bridge native iOS atau unduhan berkas web langsung. |
| - Hapus Gambar dari Galeri Studio | D | D | D | — | Tamu tidak diizinkan menghapus aset publik/contoh. |
| **4. Video Lab Generation** | | | | | |
| - Generate Video dari Teks/Naskah Cerita | C, R | C, R | C, R (Template saja) | R (Preview sampel) | Pro & Admin dapat merancang script multi-adegan bebas. |
| - Sintesis Audio Dual-Speaker TTS | C, R, U | C, R, U | R (Preset default) | R (Sampel audio) | Mengatur karakter suara Pembicara 1 & 2 secara terpisah. |
| - Remotion Native MP4 Render | X | X | X (Batas max 15 dtk) | — (Hanya play pre-rendered) | Beban render MP4 dijalankan via headless engine. |
| - Inline Video Player & Playback Control | R, X | R, X | R, X | R, X | Kontrol pemutaran, scrubber, volume, fullscreen. |
| **5. Voice Mode (Hands-free Conversational)** | | | | | |
| - Buka Voice Session & Mikrofon Aktif | C, R | C, R | C, R | C, R (Maks 2 menit) | Akses izin audio mikrofon perangkat. |
| - Hands-free Voice Activity Detection (VAD) | R, U | R, U | R, U | R | Deteksi henti bicara otomatis tanpa perlu tekan tombol terus-menerus. |
| - Visualisasi Audio Wave / Spatial Orb | R | R | R | R | Animasi interaktif visualizer VisionOS White/Graphite Frost. |
| - Interupsi Percakapan (*Barge-in*) | X | X | X | X | Menghentikan audio narasi asisten saat pengguna mulai bicara. |
| **6. Gallery / Vault Management** | | | | | |
| - Lihat Koleksi Chat, Gambar & Video | R | R | R | R (Sampel showcase) | Menampilkan seluruh media yang dihasilkan akun terkait. |
| - Filter Media per Tipe & Tanggal | R | R | R | R | Filter: Semua, Gambar, Video, Voice Memo, Catatan. |
| - Ekspor Seluruh Vault (ZIP/JSON) | X | X | X | — | Mengemas seluruh aset lokal ke berkas arsip terunduh. |
| - Pembersihan Total (*Purge Vault*) | D | D | D | — | Menghapus database lokal perangkat pengguna. |
| **7. System Settings & API Server Bridge** | | | | | |
| - Ubah URL Endpoint Backend Bridge | U, X | U, X | — (Hidden) | — (Hidden) | Memungkinkan koneksi ke server pribadi (*Custom Hermes Node*). |
| - Kelola Token Otorisasi (API Bearer Key) | U, D | U, D | — (Hidden) | — (Hidden) | Disimpan di secure storage / keychain lokal pengguna. |
| - Pemilihan Tema VisionOS (Frost / White) | U | U | U | U | Mengubah aksen spatial glass antarmuka secara lokal. |
| - Reset Konfigurasi ke Pengaturan Awal | X | X | X | — | Mengembalikan preferensi sistem ke default awal pabrik. |
| **8. Staging Simulator Control** | | | | | |
| - Quick Switch Role Pill | X | X | X | X (Aktif di Demo) | Mengubah hak peran aktif untuk evaluasi QA dan demonstrasi. |

### 2.3 Matriks Akses Layar & Navigasi Aplikasi

Antarmuka utama Hermes Super AI mengusung **Floating Spatial Glass Navigation Bar** dengan 5 menu utama:

| Layar / Menu | `Superadmin` | `Professional` | `Consumer` | `Guest / Demo` |
| :--- | :---: | :---: | :---: | :---: |
| **1. Chat AI Space** (SSE Stream, Multi-Agent Switcher, Web Search) | Penuh | Penuh | Penuh (Agen Terbatas) | Mode Demo |
| **2. Image Studio** (Prompt-to-Image, Aspect Ratio, Camera Roll) | Penuh | Penuh | Penuh | Mode Demo |
| **3. Video Lab** (Story-to-Video, Remotion Render, Dual-Speaker) | Penuh | Penuh | Mode Template | Sampel Only |
| **4. Voice Mode** (Hands-free Duplex, Spatial Orb Visualizer) | Penuh | Penuh | Penuh | Demo 2 Menit |
| **5. Vault & Settings** (Gallery, Server Bridge URL, Token Key, Theme) | Penuh | Penuh (Personal) | Galeri & Tema | Galeri Sampel |

---

## 3. Alur Proses Bisnis Inti (*End-to-End User Journey*)

### 3.1 Alur Chat Multimodal & Multi-Agent Specialist Switcher

```
[Pengguna]
   │
   ├─► 1. Buka Tab 'Chat AI Space'
   │      - Pilih Spesialis: [General Assistant | Business Analyst | Tech Architect | Copywriter]
   │      - Aktifkan Toggle: [Web Search: ON/OFF]
   │
   ├─► 2. Masukkan Pesan Prompt / Unggah Lampiran (Gambar/Dokumen)
   │
[Client App (iOS/Web)]
   │
   ├─► 3. Mengirim HTTP POST ke `/api/chat/stream` dengan Bearer Token
   │
[Hermes Backend Bridge]
   │
   ├─► 4. Memverifikasi Role & Model Routing
   │      - Jika Web Search ON: Jalankan Tool `web_search` -> Ekstraksi Fakta & Rujukan
   │      - Pasang Konteks Spesialis Terpilih (System Prompt Injection)
   │
   ├─► 5. Streaming Respon via Server-Sent Events (SSE)
   │
[Client App (iOS/Web)]
   │
   ├─► 6. Real-time Token Rendering (Markdown, Syntax Highlight, Math KaTeX)
   ├─► 7. Tampilkan Citation Badges yang dapat diklik (Link grounding referensi)
   └─► 8. Simpan Riwayat Sesi ke Vault Lokal
```

### 3.2 Alur Image Generation & Studio

```
[Pengguna]
   │
   ├─► 1. Buka Layar 'Image Studio'
   ├─► 2. Ketik Deskripsi Visual (Prompt) & Prompt Negatif opsional
   ├─► 3. Pilih Aspect Ratio:
   │      [ 1:1 Square (1024x1024) | 16:9 Landscape (1280x720) | 9:16 Portrait (720x1280) ]
   ├─► 4. Tekan Tombol 'Generate Visual'
   │
[Client App & Backend Bridge]
   │
   ├─► 5. Dispatch Request ke `/api/image/generate`
   ├─► 6. Tampilkan Spatial Shimmer Loading Placeholder di Frame VisionOS Glass
   ├─► 7. Engine memproses sintesis grafis & mengembalikan URL biner gambar
   │
[Hasil & Aksi Pengguna]
   │
   ├─► 8. Tampilkan Gambar Hasil Resolusi Penuh dengan Kontrol Zoom/Pan
   ├─► 9. Aksi Satu Sentuhan:
          ├─► 'Download to Photos' -> Simpan ke iOS Camera Roll / Unduh Berkas
          ├─► 'Save to Vault' -> Katalogisasi di Galeri Hermes
          └─► 'Send to Video Lab' -> Jadikan Aset Visual Adegan Video
```

### 3.3 Alur Video Lab Generation (Remotion Native MP4 & Dual-Speaker Audio)

```
[Pengguna]
   │
   ├─► 1. Buka Tab 'Video Lab'
   ├─► 2. Masukkan Ide Pokok / Naskah Dialog Cerita
   ├─► 3. Konfigurasi Narator Ganda:
   │      - Speaker A (Suara Pria - Formal / Antusias)
   │      - Speaker B (Suara Wanita - Jelas / Informatif)
   │      - Gaya Visual: [Modern Minimalist | Spatial VisionOS | Cinematic Motion]
   │
[Backend Bridge & Remotion Pipeline]
   │
   ├─► 4. Penguraian Adegan (Scene Splitting & Subtitle Timing Alignment)
   ├─► 5. Sintesis Audio Paralel:
   │      - Generate TTS Speaker A (`audio_track_a.mp3`)
   │      - Generate TTS Speaker B (`audio_track_b.mp3`)
   │      - Gabungkan & Normalisasi Audio Waveform (`master_audio.aac`)
   ├─► 6. Render Komposisi Remotion (Headless React Render Engine):
   │      - Render Frame Latar Beranimasi, Subtitle Dinamis, Transisi Efek Kaca
   │      - Muxing Video Canvas + Master Audio menjadi format MP4 H.264
   │
[Client App (iOS/Web)]
   │
   ├─► 7. Pemutaran Instan pada Inline Video Player VisionOS
   ├─► 8. Opsi: Unduh MP4 ke Penyimpanan Lokal atau Bagikan (Share Sheet)
```

### 3.4 Alur Voice Mode (Hands-free Conversational Audio Interface)

```
[Pengguna]
   │
   ├─► 1. Ketuk Ikon 'Voice Mode' (Floating Microphone Orb)
   │
[Client Audio Engine]
   │
   ├─► 2. Inisialisasi Audio Session & Izin Mikrofon
   ├─► 3. Spatial Orb Visualizer mulai berdenyut halus (*Graphite Frost Glow*)
   │
[Alur Interaksi Bicara]
   │
   ├─► 4. Pengguna Berbicara secara Bebas
   ├─► 5. Voice Activity Detection (VAD) mendeteksi jeda bicara (threshold 700ms hening)
   ├─► 6. Audio dikirim ke STT Engine -> Menghasilkan Teks Prompt
   ├─► 7. Hermes Core memproses respon secara kilat
   ├─► 8. Streaming TTS mengembalikan potongan audio respon secara berurutan
   ├─► 9. Speaker memutar suara respon; Spatial Orb menari selaras dengan frekuensi audio
   │
[Fitur Interupsi / Barge-in]
   │
   └─► 10. Jika pengguna memotong bicara saat asisten bersuara:
           - Audio playback seketika berhenti (*instant mute*)
           - Buffer audio dibatalkan
           - Sistem beralih mendengar input baru pengguna tanpa jeda kaku
```

---

## 4. Spesifikasi Teknis Integrasi Hermes & Backend Bridge

### 4.1 Arsitektur Kontrak API Backend Bridge

Backend Bridge menyediakan abstraksi antarmuka yang bersih antara Hermes Engine dan antarmuka pengguna:

| Endpoint | Metode | Autentikasi | Deskripsi & Format Payload |
| :--- | :---: | :---: | :--- |
| `/api/auth/session` | `GET/POST` | Opsional | Validasi kredensial pengguna atau inisialisasi sesi Guest. |
| `/api/agents` | `GET` | Bearer Token | Daftar spesialis AI aktif (id, nama, avatar, deskripsi, capabilities). |
| `/api/chat/stream` | `POST` | Bearer Token | SSE stream percakapan multimodal. Payload: `{ messages, agent_id, web_search_enabled, attachments }`. Mengembalikan event stream `token`, `citation`, `done`. |
| `/api/image/generate` | `POST` | Bearer Token | Pembuatan gambar. Payload: `{ prompt, negative_prompt, aspect_ratio, style }`. Mengembalikan `{ image_url, width, height, id }`. |
| `/api/video/render` | `POST` | Bearer Token | Memicu render Remotion MP4. Payload: `{ title, script, speaker_a_voice, speaker_b_voice, template }`. Mengembalikan status pekerjaan render atau direct video URL. |
| `/api/video/status/:id` | `GET` | Bearer Token | Polling progress render video (`progress: 0..100%`, `status: pending|rendering|completed|failed`). |
| `/api/voice/session` | `POST` | Bearer Token | Inisialisasi stream audio duplex atau WebSocket token untuk interaksi suara berlatensi rendah. |
| `/api/vault/media` | `GET/POST` | Bearer Token | Manajemen penyimpanan aset cloud cadangan pengguna. |

### 4.2 Desain Visual & Art Direction: VisionOS White / Graphite Frost

Standar visual aplikasi mengikuti filosofi *Spatial Computing Human Interface Guidelines* serta standar UI/UX profesional:

#### A. Design Brief Delapan Unsur Wajib (Standar `team-ux-ui`)
1. **Konteks:** Aplikasi Super AI Multimodal generasi baru (Chat, Image Studio, Video Lab Remotion, Voice Mode) untuk mobile iOS (`.ipa`), Android (`.apk`), dan Web Simulator Staging interaktif.
2. **Target Pengguna:** Pengguna kasual/konsumen (menginginkan kemudahan 1-sentuhan, prompt instan, hasil estetik) dan profesional/kreator konten (membutuhkan kontrol parameter lanjutan, rendering 1080p, dan kedaulatan server).
3. **Vibe & Karakteristik:** VisionOS Apple Spatial Glass, futuristik, ultra-clean, minimalis, mewah (*sophisticated dark-ice / frosted white*), responsif dan taktil.
4. **Referensi:** Apple VisionOS UI, iOS 18 Liquid Glass, ChatGPT Advanced Voice Orb, Linear.app (ketajaman garis & tipografi mikro), dan Remotion Studio.
5. **Warna & Palet Token:**
   - *Latar Belakang:* Graphite Frost (`#0F1115` / `rgba(15, 17, 21, 0.85)`) dan VisionOS White Frost (`#F8FAFC` / `rgba(255, 255, 255, 0.70)`).
   - *Aksen Spatial:* Electric Cyan / Ice Blue (`#38BDF8`), Soft Violet Ambient Glow (`#A855F7`), dan Pure White Specular Highlight (`rgba(255, 255, 255, 0.40)`).
   - *Permukaan Kaca:* `backdrop-blur-3xl`, `saturate-180`, border `1px solid rgba(255, 255, 255, 0.15)`.
6. **Tipografi:** SF Pro Display (Judul & Heading) dan SF Pro Text (Body & Input) dengan kontras tinggi (WCAG AAA) terhadap panel kaca.
7. **Struktur & Tata Letak:** Arsitektur 5 Layar Komersial (Onboarding/Role Switcher, Home Dashboard Bento Grid, Multimodal Studio Hub, Unified Media Vault, Settings/Server Config) dengan *Floating Spatial Glass Navigation Bar*.
8. **Hindari:** Dilarang menggunakan desain datar satu layar polos, tombol prompt raksasa yang mendominasi layar (>32px), nesting card berlebihan ("box-in-a-box"), warna jenuh norak, dan elemen yang menutupi *touch zone* jempol.

#### B. Spesifikasi Identitas Visual: Logo & App Icon Resmi
Sesuai arahan eksplisit pemilik (*"sekalian buatkan logonya dan icon nya, saya ingin sebagus mungkin dan mudah digunakan"*):
- **Bentuk & Format:** Apple Squircle Standar HIG (1024x1024 px master SVG & PNG).
- **Konsep Visual:** *The Spatial Neural Caduceus / Quantum Core* — perpaduan sayap Hermes klasik yang distilisasi menjadi lintasan energi spasial tiga dimensi bercahaya (*ambient gradient glow*) di dalam kubus kaca es (*frosted graphite cube*).
- **Kedalaman & Pencahayaan:** Refraksi specular atas (sudut 45 derajat), bayangan jatuh lembut (*soft ambient drop shadow*), dan pendaran neon es di pusat inti (*neural core*).
- **Keterbacaan Ikon:** Sangat mudah dikenali pada ukuran kecil (60x60 px di Home Screen iOS) maupun ukuran besar (1024x1024 px di App Store).

#### C. Ergonomi Chat Prompt Box & Action Toolbar (Standar `ai-workspace-ui-design`)
- **Ukuran Tombol Aksi:** Tombol aksi pada bilah prompt (lampiran, mikrofon, kirim/submit) wajib berukuran ringkas dan ergonomis: `28px` (`size-7`) hingga `30px` (`size-7.5`). Dilarang memakai tombol besar `36px+` yang memakan ruang vertikal.
- **Skala Ikon:** Ikon berukuran `15px`–`16px` dengan ketebalan garis seragam (`stroke-width: 1.75 - 2.0`).
- **Kontras Tonal Tombol Kirim:** Saat kosong, tombol send berada dalam status *disabled* bernuansa redup (`bg-slate-800/80 text-slate-500 border border-slate-700/50 opacity-40`); saat input teks/lampiran terdeteksi, bertransisi halus ke aksen menyala (*active accent*).
- **Dead Zone Elimination:** Meminimalkan jarak vertikal antara placeholder teks dan baris aksi (`py-2 gap-1.5`), menjaga seluruh kontrol pembantu sejajar secara horizontal (*single baseline*).
- **Dua Tingkat Header Agen (*Two-Tier Flow*):** Kartu agen multi-spesialis memisahkan baris meta sistem (kategori & model badge di kiri, status dot di kanan) dengan baris identitas pahlawan (nama & peran) yang diposisikan di atas squircle avatar kokoh (*grounded pedestal*).

### 4.3 Kebutuhan Variabel Lingkungan (`.env.example`)

```ini
# ==========================================
# HERMES SUPER AI - ENVIRONMENT CONFIGURATION
# ==========================================

# Server Host & Port
PORT=3000
NODE_ENV=production
API_BASE_URL=http://localhost:3000

# Hermes Core Engine & Bridge Auth
HERMES_API_ENDPOINT=http://127.0.0.1:8642
HERMES_API_SECRET_TOKEN=super_hermes_secure_token_change_in_prod

# Feature Flags
ENABLE_WEB_SEARCH=true
ENABLE_VIDEO_REMOTION=true
ENABLE_VOICE_MODE=true
ENABLE_DEMO_ROLE_SWITCHER=true

# Video Lab & Remotion Render Config
REMOTION_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
VIDEO_RENDER_TIMEOUT_MS=60000
OUTPUT_MEDIA_DIR=/home/devcurl/workspace-webui/hermes-super-ai/storage/media

# Voice & Audio Synthesis Config
TTS_DEFAULT_VOICE_A=id-ID-ArdiNeural
TTS_DEFAULT_VOICE_B=id-ID-GadisNeural
VAD_SILENCE_TIMEOUT_MS=750

# Client Staging Simulator
VITE_APP_NAME="Hermes Super AI"
VITE_THEME_DEFAULT=graphite-frost
```

---

## 5. Kriteria Keberhasilan & Acceptance Criteria (AC-01 sampai AC-08)

Setiap implementasi fitur wajib lulus pengujian berbasis skenario penerimaan berikut:

### AC-01: Multimodal Chat Streaming & Multi-Agent Switcher
- **Deskripsi:** Pengguna dapat mengirim pesan teks dan lampiran, menerima respon dengan streaming SSE tanpa jeda patah, serta berganti persona agen spesialis dengan mulus.
- **Kriteria Keberhasilan:**
  1. Waktu respon awal (*TTFT*) ≤ 650 ms melalui protokol Server-Sent Events.
  2. Dropdown / Carousel *Agent Switcher* menampilkan minimal 3 agen spesialis (misal: *General Assistant*, *Business Analyst*, *Creative Writer*).
  3. Pemilihan agen mengubah gaya narasi respon dan system prompt secara instan tanpa perlu memuat ulang aplikasi (*no full reload*).
  4. Format teks matematika, kode berwana (*syntax highlighted*), dan tabel markdown dirender dengan rapi pada lapisan kaca VisionOS.

### AC-02: Web Search Augmented Responses & Grounding Citations
- **Deskripsi:** Ketika opsi Web Search aktif, sistem memperkaya respon dengan data fakta mutakhir dari web dan menyertakan rujukan yang dapat diklik.
- **Kriteria Keberhasilan:**
  1. Toggle saklar *Web Search* dapat dihidupkan/dimatikan dengan mudah di bilah input chat.
  2. Saat aktif, indikator visual "Mencari di Web..." muncul sesaat sebelum streaming jawaban dimulai.
  3. Respon menyertakan minimal 1 lencana kutipan numerik (*citation badge* seperti `[1]`, `[2]`) yang jika ditekan menampilkan judul situs, URL, dan cuplikan informasi terkait.

### AC-03: Image Studio Generation & Camera Roll Download
- **Deskripsi:** Pengguna dapat membuat karya visual berkualitas tinggi dari deskripsi teks, memilih rasio aspek, dan mengunduh hasilnya langsung ke galeri foto.
- **Kriteria Keberhasilan:**
  1. Pengguna dapat memilih 3 rasio dimensi utama: `1:1 (Persegi)`, `16:9 (Lanskap)`, dan `9:16 (Vertikal/Story)`.
  2. Proses generasi menampilkan efek shimmer/pendaran kaca selama proses komputasi (maksimal 10 detik).
  3. Tombol "Download to Photos / Camera Roll" berfungsi tanpa galat: pada browser web mengunduh berkas biner `.png`/`.jpg`, dan pada perangkat iOS native memicu penyimpanan ke Photo Library perangkat.

### AC-04: Video Lab Remotion MP4 Render & Dual-Speaker Audio
- **Deskripsi:** Pembuatan video otomatis berbasis React Remotion dengan sintesis audio dua karakter (pembicara pria & wanita) dan pemutar video inline.
- **Kriteria Keberhasilan:**
  1. Pengguna dapat memasukkan naskah cerita dan memilih dua karakter suara berbeda (Speaker A & B).
  2. Engine Remotion merender video MP4 H.264 secara lokal atau headless dengan audio dual-speaker yang sinkron sempurna dengan teks takarir (*subtitles*).
  3. Video hasil render dapat diputar langsung di layar aplikasi menggunakan *Inline Video Player* dengan kontrol pemutaran penuh (Play, Pause, Scrubber, Fullscreen).

### AC-05: Real-time Hands-Free Voice Mode & Soundwave Visualizer
- **Deskripsi:** Antarmuka percakapan suara interaktif dua arah tanpa perlu menahan tombol bicara (*hands-free*), dilengkapi visualisasi gelombang spasial dan deteksi interupsi.
- **Kriteria Keberhasilan:**
  1. Mode suara aktif dengan satu ketukan; VAD mendeteksi suara pengguna dan berhenti mendengar secara otomatis saat hening ≥ 750 ms.
  2. Terdapat visualisasi audio dinamis berbentuk *Spatial Orb / Soundwave* yang bereaksi terhadap intensitas frekuensi suara (baik suara pengguna maupun suara asisten).
  3. Mendukung fitur *Barge-in*: Asisten seketika berhenti berbicara dan mendengarkan kembali saat pengguna mulai memotong pembicaraan.

### AC-06: RBAC Matrix & Demo Quick Switch Role
- **Deskripsi:** Penegakan hak akses peran pengguna sesuai matriks RBAC serta ketersediaan tombol pergantian peran cepat pada mode Staging Simulator.
- **Kriteria Keberhasilan:**
  1. Tersedia 4 role teruji: `Superadmin`, `Professional`, `Consumer`, dan `Guest`.
  2. Pada Interactive Simulator Staging, elemen *Quick Switch Role Pill* mengambang di layar memungkinkan penguji beralih role secara instan.
  3. Hak akses layar, menu pengaturan server URL, dan batasan render video secara presisi mengikuti matriks izin yang telah didefinisikan pada Bab 2.

### AC-07: VisionOS White / Graphite Frost Spatial Glass UI Consistency
- **Deskripsi:** Seluruh komponen visual mengusung konsistensi desain spatial glassmorphism bernuansa es putih mutiara atau grafit beku dengan lengkungan sudut tinggi.
- **Kriteria Keberhasilan:**
  1. Seluruh kartu, sheet, dan modal menggunakan *border-radius* melengkung tinggi (24px - 32px) dengan border semi-transparan `1px rgba(255,255,255,0.25)`.
  2. Teks tetap terbaca tajam dan lulus uji kontras minimal WCAG AA pada seluruh latar belakang kaca blur.
  3. Animasi transisi tab dan pemunculan modal terasa halus (*smooth spring physics* 60 FPS).

### AC-08: iOS Sideload Build (.ipa CI/CD) & Interactive Simulator Staging
- **Deskripsi:** Ketersediaan alur CI/CD otomatis untuk menghasilkan paket biner iOS `.ipa` siap sideload (misal via AltStore, SideStore, atau Scarlet) dan web staging simulator yang interaktif.
- **Kriteria Keberhasilan:**
  1. Repositori dilengkapi alur kerja GitHub Actions (`.github/workflows/build-ios.yml`) untuk kompilasi biner iOS `.ipa`.
  2. Aplikasi simulator staging dapat dijalankan secara lokal/web pada port tertentu dengan tampilan responsif seluler (*mobile-viewport frame* lengkap dengan bezel iPhone/VisionOS mockup).
  3. Semua interaksi simulasi (Chat, Gambar, Video Player, Voice Visualizer) berfungsi penuh pada browser tanpa galat console yang menghalangi pengujian.

---

## 6. Ringkasan Eksekusi & Handoff Spesialis

Dokumen ini menjadi acuan tunggal (*single source of truth*) bagi tahapan rekayasa selanjutnya:
- **`team-architect`:** Merancang struktur arsitektur sistem, skema database, antarmuka bridge, dan alur integrasi Remotion & Audio.
- **`team-ux-ui`:** Merancang desain wireframe, spatial design tokens, layout mobile iOS, dan komponen VisionOS White/Graphite Frost.
- **`team-engineer`:** Mengimplementasikan kode frontend mobile/web, endpoint backend bridge, engine Remotion, dan pipeline CI/CD GitHub Actions.
- **`team-qa`:** Menyusun test suite dan memvalidasi kriteria AC-01 hingga AC-08 sebelum rilis produksi.

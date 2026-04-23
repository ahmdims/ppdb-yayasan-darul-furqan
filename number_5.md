# Pertanyaan 5 — Kebutuhan Pembuatan Aplikasi

## Sistem Informasi Yayasan Darul Furqan Pariaman

---

## 1. Gambaran Umum Aplikasi

Aplikasi yang akan dibuat adalah **Website Sekolah Terintegrasi** dengan modul PPDB Online yang mencakup:

- Halaman publik digital sekolah (profil, berita, galeri, kontak)
- Portal PPDB Online untuk calon siswa / wali murid
- Panel administrasi back-end untuk staf sekolah

Aplikasi berbasis web yang dapat diakses dari browser di perangkat apapun (desktop, tablet, dan smartphone).

---

## 2. Kebutuhan Software

### 2.1 Lingkungan Pengembangan (Development)

| Kategori                         | Software                             | Keterangan                                         |
| -------------------------------- | ------------------------------------ | -------------------------------------------------- |
| **Bahasa Pemrograman Back-End**  | PHP 8.2+                             | Stabil, performa tinggi, ekosistem luas            |
| **Framework Back-End**           | Laravel 11                           | MVC, ORM Eloquent, autentikasi bawaan, artisan CLI |
| **Bahasa Pemrograman Front-End** | HTML5 / CSS3 / JavaScript            | Standar web modern                                 |
| **Framework CSS**                | Tailwind CSS atau Bootstrap 5        | Mempercepat styling dan responsivitas              |
| **JavaScript Runtime**           | Node.js (untuk build tools)          | Diperlukan untuk Vite/npm                          |
| **Build Tool**                   | Vite                                 | Bundler modern, digunakan oleh Laravel             |
| **Database**                     | MySQL 8.0+                           | Relasional, handal, sesuai desain database         |
| **Cache & Session**              | Redis (opsional, bisa file/database) | Performa caching                                   |
| **Code Editor**                  | Visual Studio Code                   | Gratis, plugin ekosistem PHP/Laravel               |
| **Version Control**              | Git + GitHub / GitLab                | Pelacakan perubahan kode                           |
| **API Testing**                  | Postman                              | Uji endpoint API jika menggunakan REST             |
| **Database GUI**                 | TablePlus / DBeaver / phpMyAdmin     | Manajemen database visual                          |
| **Local Development**            | Laragon / XAMPP / Laravel Herd       | Server lokal untuk pengembangan                    |

### 2.2 Paket & Library Utama (Laravel Ecosystem)

| Library                                   | Fungsi                                                 |
| ----------------------------------------- | ------------------------------------------------------ |
| `laravel/breeze` atau `laravel/jetstream` | Sistem autentikasi (login, register, verifikasi email) |
| `spatie/laravel-permission`               | Manajemen role & permission multi-level                |
| `spatie/laravel-medialibrary`             | Upload dan manajemen file/gambar                       |
| `barryvdh/laravel-dompdf`                 | Generate PDF (kartu peserta, laporan)                  |
| `maatwebsite/excel`                       | Export data pendaftar ke Excel                         |
| `intervention/image`                      | Resize dan optimasi gambar upload                      |
| `laravel/sanctum`                         | Autentikasi token API                                  |
| `tightenco/ziggy`                         | Routing di sisi JavaScript                             |
| `livewire/livewire`                       | Komponen interaktif tanpa full SPA (opsional)          |

### 2.3 Lingkungan Produksi (Deployment)

| Kategori                | Software / Layanan                    | Keterangan                                |
| ----------------------- | ------------------------------------- | ----------------------------------------- |
| **Web Server**          | Nginx (direkomendasikan) atau Apache  | Reverse proxy untuk PHP-FPM               |
| **PHP Process Manager** | PHP-FPM 8.2+                          | Performa lebih baik dari mod_php          |
| **Database Server**     | MySQL 8.0 / MariaDB 10.6+             | Di server VPS atau managed DB             |
| **SSL/TLS**             | Let's Encrypt (Certbot)               | HTTPS gratis, wajib untuk keamanan data   |
| **OS Server**           | Ubuntu Server 22.04 LTS               | Stabil, banyak dokumentasi                |
| **Panel Hosting**       | Cyberpanel / cPanel / Runcloud        | Manajemen server lebih mudah (opsional)   |
| **Object Storage**      | MinIO (self-host) atau Cloudflare R2  | Penyimpanan file upload (gambar, dokumen) |
| **Email Service**       | SMTP Gmail / Mailgun / Mailtrap (dev) | Kirim notifikasi email ke wali murid      |
| **Backup Otomatis**     | Spatie Laravel Backup                 | Backup database & file otomatis terjadwal |

### 2.4 Software Pendukung Lainnya

| Software                             | Fungsi                                     |
| ------------------------------------ | ------------------------------------------ |
| **Figma** (gratis)                   | Desain UI/UX wireframe dan prototype       |
| **Draw.io / Lucidchart**             | Membuat diagram (ERD, use case, flowchart) |
| **Notion / Trello**                  | Manajemen proyek dan task assignment tim   |
| **WhatsApp Business API** (opsional) | Notifikasi status PPDB via WhatsApp        |
| **Google Analytics / Matomo**        | Analitik kunjungan website                 |

---

## 3. Kebutuhan Hardware

### 3.1 Hardware untuk Tim Pengembang

| Peran                    | Spesifikasi Minimum                      | Spesifikasi Rekomendasi           |
| ------------------------ | ---------------------------------------- | --------------------------------- |
| **Full-Stack Developer** | Processor: Intel Core i5 / AMD Ryzen 5   | Intel Core i7 / AMD Ryzen 7       |
|                          | RAM: 8 GB                                | 16 GB                             |
|                          | Storage: 256 GB SSD                      | 512 GB NVMe SSD                   |
|                          | OS: Windows 10/11 atau macOS atau Ubuntu | Windows 11 / macOS Ventura+       |
|                          | Monitor: 1920×1080 (1 layar)             | Dual monitor 1920×1080            |
|                          | Koneksi Internet: 10 Mbps                | 25 Mbps+                          |
| **Front-End Developer**  | Sama seperti di atas                     | Sama seperti di atas              |
| **Database Designer**    | Processor: Core i5, RAM: 8 GB            | Core i7, RAM: 16 GB               |
| **UI/UX Designer**       | Processor: Core i5, RAM: 8 GB            | Core i7, RAM 16 GB, GPU dedicated |

### 3.2 Hardware Server Produksi

#### Opsi A: VPS (Virtual Private Server) — Rekomendasi

Cocok untuk skala awal sekolah dengan ratusan hingga ribuan pengguna.

| Spesifikasi     | Nilai                                                 |
| --------------- | ----------------------------------------------------- |
| **vCPU**        | 2 Core (minimum) / 4 Core (rekomendasi)               |
| **RAM**         | 2 GB (minimum) / 4 GB (rekomendasi)                   |
| **SSD Storage** | 40 GB (OS + App) + storage terpisah untuk file upload |
| **Bandwidth**   | 2 TB/bulan                                            |
| **OS**          | Ubuntu Server 22.04 LTS                               |
| **Provider**    | IDCloudHost / Niagahoster / DigitalOcean / Vultr      |

#### Opsi B: Shared Hosting — Untuk Anggaran Terbatas

Dapat digunakan di tahap awal jika trafik masih rendah.

| Spesifikasi        | Nilai                              |
| ------------------ | ---------------------------------- |
| **PHP Versi**      | 8.2+ (harus tersedia)              |
| **MySQL**          | 5.7+ (disediakan hosting)          |
| **Storage**        | Minimal 5 GB                       |
| **Email**          | Mendukung SMTP outgoing            |
| **SSL**            | Gratis Let's Encrypt               |
| **Contoh Hosting** | Hostinger, Niagahoster, DomaiNesia |

#### Opsi C: Cloud Managed (Skala Lebih Besar)

Jika sekolah berkembang pesat dan membutuhkan high availability.

| Layanan                          | Fungsi                 |
| -------------------------------- | ---------------------- |
| **AWS EC2 / GCP Compute Engine** | Server aplikasi        |
| **AWS RDS / Cloud SQL**          | Managed database MySQL |
| **AWS S3 / GCS**                 | Penyimpanan file       |
| **Cloudflare**                   | CDN dan proteksi DDoS  |

### 3.3 Hardware di Sekolah (Client-Side)

| Perangkat                      | Spesifikasi Minimum                                 | Kegunaan                     |
| ------------------------------ | --------------------------------------------------- | ---------------------------- |
| **Komputer / Laptop Operator** | Processor: Core i3, RAM: 4 GB, Browser modern       | Akses panel admin            |
| **Smartphone (Wali Murid)**    | Android 8.0+ / iOS 13+ dengan browser Chrome/Safari | Akses portal PPDB online     |
| **Printer**                    | Printer A4 inkjet/laser                             | Cetak kartu peserta, laporan |
| **Internet Sekolah**           | Minimal 10 Mbps                                     | Operasional sehari-hari      |

---

## 4. Estimasi Kebutuhan Pengelola / Admin Aplikasi

### 4.1 Struktur Tim Pengelola

| Jabatan                 | Jumlah           | Tanggung Jawab                                                                            |
| ----------------------- | ---------------- | ----------------------------------------------------------------------------------------- |
| **Super Administrator** | 1 orang          | Kepala IT / Koordinator Sistem. Mengelola akun admin, backup, pengaturan sistem, keamanan |
| **Admin Konten**        | 1–2 orang        | Staf TU / Humas. Mengelola berita, pengumuman, galeri, profil sekolah                     |
| **Operator PPDB**       | 1–2 orang        | Staf Pendaftaran. Verifikasi berkas, proses pendaftaran, cetak kartu, laporan             |
| **Kepala Sekolah**      | 1 orang per unit | Memantau laporan, menyetujui pengumuman penting                                           |

**Total minimal**: **4–6 orang** pengelola aplikasi

### 4.2 Kompetensi yang Diperlukan Tiap Peran

#### Super Administrator

- Memahami dasar pengelolaan server / hosting (mengunggah file, pengaturan domain)
- Mampu melakukan backup dan restore database
- Mengerti dasar keamanan website (ubah password berkala, pantau log)
- Literasi digital yang baik

#### Admin Konten

- Terbiasa menggunakan komputer dan internet
- Kemampuan menulis artikel/berita yang baik
- Dapat mengoperasikan editor teks sederhana (seperti WordPress editor)
- Mampu resize foto sebelum upload

#### Operator PPDB

- Mampu mengoperasikan sistem komputer sehari-hari
- Teliti dalam verifikasi data dan dokumen
- Mampu menggunakan spreadsheet Excel (untuk review data export)
- Komunikatif (untuk menghubungi wali murid jika diperlukan)

#### Kepala Sekolah

- Hanya memerlukan kemampuan membaca laporan di dashboard
- Login dan pantau statistik pendaftaran

### 4.3 Kebutuhan Pelatihan

| Pelatihan                                          | Peserta       | Durasi Estimasi |
| -------------------------------------------------- | ------------- | --------------- |
| Orientasi sistem & login pertama                   | Semua admin   | 1–2 jam         |
| Pengelolaan konten (berita, galeri, pengumuman)    | Admin Konten  | 3–4 jam         |
| Operasional PPDB (verifikasi, ubah status, export) | Operator PPDB | 4–6 jam         |
| Manajemen pengguna & pengaturan sistem             | Super Admin   | 4–6 jam         |
| Pembuatan manual/panduan penggunaan                | Tim IT        | 1–2 hari kerja  |

---

## 5. Kebutuhan Non-Fungsional

### 5.1 Keamanan

- Autentikasi dengan password di-hash (bcrypt)
- HTTPS wajib di seluruh halaman
- Proteksi CSRF (bawaan Laravel)
- Validasi input server-side untuk semua form
- Rate limiting pada endpoint login (mencegah brute force)
- Upload file hanya format tertentu dengan validasi MIME type
- Session timeout untuk admin panel
- Audit log setiap aksi penting admin

### 5.2 Performa

- Halaman publik target loading < 3 detik
- Optimasi gambar otomatis saat upload (compress & resize)
- Caching halaman publik yang tidak sering berubah
- Lazy loading pada gambar galeri
- Pagination pada tabel data pendaftar

### 5.3 Ketersediaan

- Target uptime: 99.5%
- Backup database otomatis setiap hari (retensi 7 hari)
- Backup file upload mingguan
- Monitoring uptime (UptimeRobot — gratis)

### 5.4 Kemudahan Penggunaan (Usability)

- Antarmuka responsif (mobile-first)
- Formulir pendaftaran PPDB multi-step dengan progress indicator
- Pesan error dan validasi yang jelas dan informatif
- Konfirmasi sebelum tindakan destruktif (hapus data)
- Panel admin intuitif tanpa perlu keahlian teknis tinggi

---

## 6. Rencana Pengembangan (Development Timeline)

| Fase                               | Kegiatan                                                     | Durasi Estimasi   |
| ---------------------------------- | ------------------------------------------------------------ | ----------------- |
| **Fase 1** — Analisis & Desain     | Finalisasi kebutuhan, desain database, wireframe UI          | 2 minggu          |
| **Fase 2** — Setup & Infrastruktur | Setup server, domain, SSL, environment pengembangan          | 3 hari            |
| **Fase 3** — Sprint 1 (Core)       | Beranda, Profil, PPDB Online, Auth, Panel Admin dasar        | 3 minggu          |
| **Fase 4** — Sprint 2 (Content)    | Berita, Pengumuman, Galeri, CMS, Kontak                      | 2 minggu          |
| **Fase 5** — Sprint 3 (Extended)   | Guru, Fasilitas, Ekskul, Prestasi, Laporan, Export           | 2 minggu          |
| **Fase 6** — Testing & QA          | Unit testing, integration testing, UAT bersama pihak sekolah | 1–2 minggu        |
| **Fase 7** — Deployment & Training | Deploy ke produksi, pelatihan admin, handover                | 1 minggu          |
| **Total**                          |                                                              | **~12–14 minggu** |

---

## 7. Ringkasan Kebutuhan

| Kategori             | Item Utama                                                                       |
| -------------------- | -------------------------------------------------------------------------------- |
| **Software Dev**     | PHP 8.2, Laravel 11, MySQL 8, VS Code, Git, Node.js                              |
| **Software Prod**    | Ubuntu Server, Nginx, PHP-FPM, Let's Encrypt, Redis                              |
| **Hardware Dev**     | PC/Laptop i5+ / 8GB RAM / 256GB SSD per developer                                |
| **Hardware Server**  | VPS 2 vCPU / 4 GB RAM / 40 GB SSD (rekomendasi)                                  |
| **Hardware Sekolah** | PC operator, printer A4, internet min. 10 Mbps                                   |
| **Tim Pengelola**    | 4–6 orang (1 Super Admin, 1–2 Admin Konten, 1–2 Operator PPDB, 1 Kepala Sekolah) |
| **Pelatihan**        | ~1–2 hari pelatihan per peran admin                                              |

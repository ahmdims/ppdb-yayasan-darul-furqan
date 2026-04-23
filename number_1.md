# Pertanyaan 1 — Analisis Fitur Aplikasi

## Sistem Informasi Cerdas dengan Digitalisasi Profil Sekolah

### Yayasan Darul Furqan Pariaman

---

## Latar Belakang Analisis

Berdasarkan studi kasus, Yayasan Darul Furqan Pariaman mengelola:

- **PAUD** (Pendidikan Anak Usia Dini)
- **SDIT Alam** (Sekolah Dasar Islam Terpadu)
- **Pondok Pesantren**

Masalah utama yang dihadapi:

1. Belum memiliki website resmi
2. Penyampaian informasi hanya lewat lisan & brosur fisik
3. Proses PPDB masih manual
4. Jangkauan informasi terbatas pada masyarakat sekitar

**Solusi**: Website sekolah terintegrasi dengan modul PPDB online, profil sekolah digital, dan sistem manajemen konten.

---

## Identifikasi Aktor / Pengguna Sistem

| Aktor                        | Deskripsi                                     |
| ---------------------------- | --------------------------------------------- |
| **Pengunjung Umum**          | Masyarakat yang mengakses website tanpa login |
| **Calon Siswa / Wali Murid** | Mendaftar PPDB & memantau status pendaftaran  |
| **Admin Sekolah**            | Mengelola semua konten & data aplikasi        |
| **Kepala Sekolah**           | Memantau laporan & menyetujui pengumuman      |
| **Guru / Staff**             | Mengakses informasi internal tertentu         |

---

## Daftar Fitur Lengkap

### MODUL 1 — HALAMAN PUBLIK (Front-End)

#### 1.1 Beranda / Home

- Hero section dengan tagline & CTA (Call to Action) pendaftaran
- Ringkasan profil singkat yayasan
- Highlight berita & pengumuman terbaru
- Statistik sekolah (jumlah siswa, guru, prestasi)
- Galeri foto unggulan
- Akses cepat ke PPDB Online
- Informasi kontak singkat & lokasi peta

#### 1.2 Profil Sekolah

- **Tentang Yayasan**: Sejarah pendirian, perkembangan, dan legalitas Yayasan Darul Furqan Pariaman
- **Visi & Misi**: Visi dan misi sekolah yang jelas dan terstruktur
- **Sambutan Kepala Sekolah**: Pesan resmi dari pimpinan lembaga
- **Struktur Organisasi**: Diagram hierarki kepengurusan yayasan dan sekolah
- **Akreditasi & Legalitas**: Informasi status akreditasi dan nomor izin operasional

#### 1.3 Program Pendidikan

- **Profil PAUD**: Kurikulum, usia masuk, jadwal belajar
- **Profil SDIT Alam**: Program unggulan, kurikulum berbasis alam & Islam
- **Profil Pondok Pesantren**: Program hafalan, kegiatan pesantren, jadwal kegiatan
- Perbandingan program / tingkatan sekolah

#### 1.4 Data Guru & Staff

- Daftar guru dengan foto, nama, jabatan, dan bidang studi
- Filter berdasarkan unit sekolah (PAUD / SDIT / Pesantren)
- Kualifikasi pendidikan dan pengalaman mengajar

#### 1.5 Fasilitas Sekolah

- Galeri foto fasilitas (ruang kelas, perpustakaan, masjid, asrama, dll)
- Deskripsi tiap fasilitas
- Fasilitas ramah lingkungan / alam (school branding SDIT Alam)

#### 1.6 Ekstrakurikuler

- Daftar kegiatan ekstrakurikuler (pramuka, tahfidz, seni, olahraga, dll)
- Jadwal kegiatan
- Foto dokumentasi kegiatan

#### 1.7 Prestasi

- Daftar prestasi siswa dan sekolah (akademik & non-akademik)
- Filter berdasarkan tahun dan tingkatan
- Dokumentasi piala / sertifikat

#### 1.8 Berita & Artikel

- Daftar berita/artikel yang dapat difilter berdasarkan kategori dan tanggal
- Halaman detail berita dengan gambar dan konten lengkap
- Berbagi berita ke media sosial (share button)
- Pencarian berita

#### 1.9 Pengumuman

- Daftar pengumuman resmi sekolah
- Kategori: PPDB, Akademik, Umum
- Tanda "Baru" / label urgensi
- Arsip pengumuman

#### 1.10 Galeri

- Galeri foto dan video kegiatan sekolah
- Filter berdasarkan kategori (kegiatan, fasilitas, prestasi)
- Lightbox viewer untuk foto
- Video embed YouTube/Vimeo

#### 1.11 Kontak

- Formulir kontak online (nama, email, pesan)
- Informasi alamat lengkap + peta (Google Maps embed)
- Nomor telepon / WhatsApp
- Email resmi sekolah
- Jam operasional kantor

---

### MODUL 2 — PPDB ONLINE (Penerimaan Peserta Didik Baru)

#### 2.1 Informasi PPDB

- Persyaratan pendaftaran per unit sekolah
- Jadwal PPDB (buka pendaftaran, tes, pengumuman, daftar ulang)
- Biaya pendaftaran dan cara pembayaran
- FAQ (Pertanyaan yang Sering Diajukan)
- Unduh formulir / brosur dalam format PDF

#### 2.2 Pendaftaran Online

- Registrasi akun wali murid (email & password)
- Formulir pendaftaran online multi-step:
  - **Step 1**: Data calon siswa (nama, tanggal lahir, jenis kelamin, asal sekolah)
  - **Step 2**: Data orang tua/wali (nama, pekerjaan, nomor HP, alamat)
  - **Step 3**: Upload dokumen (foto, akta kelahiran, KK, rapor)
  - **Step 4**: Pilih unit sekolah yang dituju
  - **Step 5**: Konfirmasi & submit
- Validasi data real-time (format email, nomor HP, dll)
- Nomor pendaftaran otomatis

#### 2.3 Pembayaran Biaya Pendaftaran

- Upload bukti pembayaran
- Status verifikasi pembayaran oleh admin

#### 2.4 Pantau Status Pendaftaran

- Login dengan akun yang didaftarkan
- Lihat status: Menunggu Verifikasi → Diverifikasi → Lulus Seleksi → Daftar Ulang
- Notifikasi perubahan status (via email atau halaman)
- Unduh surat keterangan / kartu peserta

#### 2.5 Pengumuman Hasil Seleksi

- Halaman publik pengumuman kelulusan berdasarkan nomor pendaftaran
- Informasi tahap daftar ulang bagi yang diterima

---

### MODUL 3 — PANEL ADMIN (Back-End)

#### 3.1 Autentikasi Admin

- Login admin dengan email & password terenkripsi
- Manajemen sesi (timeout otomatis)
- Multi-level akses: Super Admin, Admin, Operator

#### 3.2 Dashboard Admin

- Statistik ringkas: total pendaftar, yang diverifikasi, yang diterima
- Grafik pendaftaran harian/mingguan
- Daftar tugas/notifikasi terbaru
- Shortcut ke modul yang sering diakses

#### 3.3 Manajemen Konten (CMS)

- **Kelola Berita**: tambah, edit, hapus, publish/unpublish berita
- **Kelola Pengumuman**: tambah, edit, atur tanggal tayang
- **Kelola Galeri**: upload, kategorikan, hapus foto/video
- **Kelola Profil Sekolah**: edit konten visi, misi, sejarah, sambutan
- **Kelola Fasilitas**: tambah/edit daftar fasilitas + gambar
- **Kelola Prestasi**: tambah/edit data prestasi
- **Kelola Ekstrakurikuler**: tambah/edit kegiatan & jadwal

#### 3.4 Manajemen Guru & Staff

- Tambah, edit, hapus data guru & staff
- Upload foto profil

#### 3.5 Manajemen PPDB

- Lihat daftar semua pendaftar beserta detailnya
- Filter & pencarian pendaftar (nama, unit sekolah, status)
- Ubah status pendaftar (verifikasi, seleksi, terima/tolak, daftar ulang)
- Verifikasi bukti pembayaran
- Export data pendaftar ke Excel/PDF
- Cetak kartu peserta / surat keterangan

#### 3.6 Manajemen Jadwal PPDB

- Tambah & edit jadwal tahapan PPDB
- Pengaturan buka/tutup pendaftaran online

#### 3.7 Manajemen Pesan Masuk

- Lihat pesan dari formulir kontak
- Tandai sebagai sudah dibaca/dibalas

#### 3.8 Pengaturan Website

- Kelola informasi kontak sekolah (alamat, telepon, email)
- Kelola tampilan slider/banner beranda
- Pengaturan SEO (title, meta description)
- Backup & restore data

#### 3.9 Manajemen Pengguna Admin

- Tambah/hapus akun admin
- Atur peran (Super Admin / Admin / Operator)
- Log aktivitas admin

---

## Rangkuman Fitur per Prioritas

### Prioritas Tinggi (MVP — Harus Ada)

| No  | Fitur                                     | Modul     |
| --- | ----------------------------------------- | --------- |
| 1   | Beranda informatif                        | Front-End |
| 2   | Profil Sekolah lengkap                    | Front-End |
| 3   | PPDB Online (pendaftaran & pantau status) | PPDB      |
| 4   | Berita & Pengumuman                       | Front-End |
| 5   | Kontak & Peta Lokasi                      | Front-End |
| 6   | Panel Admin & CMS dasar                   | Back-End  |
| 7   | Manajemen data PPDB                       | Back-End  |

### Prioritas Sedang (Should Have)

| No  | Fitur                   | Modul     |
| --- | ----------------------- | --------- |
| 8   | Galeri foto & video     | Front-End |
| 9   | Data Guru & Staff       | Front-End |
| 10  | Fasilitas Sekolah       | Front-End |
| 11  | Program Pendidikan      | Front-End |
| 12  | Pembayaran & verifikasi | PPDB      |

### Prioritas Rendah (Nice to Have)

| No  | Fitur                           | Modul     |
| --- | ------------------------------- | --------- |
| 13  | Ekstrakurikuler & Prestasi      | Front-End |
| 14  | Export laporan PPDB (Excel/PDF) | Back-End  |
| 15  | Statistik Dashboard Admin       | Back-End  |
| 16  | SEO & pengaturan lanjutan       | Back-End  |

---

## Kesimpulan

Aplikasi website Yayasan Darul Furqan Pariaman perlu mengintegrasikan **3 modul utama** (Halaman Publik, PPDB Online, Panel Admin) dengan total **≥ 35 fitur** yang saling berkaitan. Fokus utama adalah digitalisasi profil sekolah untuk meningkatkan jangkauan informasi dan otomatisasi proses PPDB untuk menggantikan sistem manual yang ada saat ini. Dengan semua fitur ini, sekolah dapat meningkatkan efisiensi operasional, memperluas jangkauan informasi, dan memperkuat school branding Yayasan Darul Furqan Pariaman.

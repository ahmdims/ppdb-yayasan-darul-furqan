# Pertanyaan 3 — Desain Database Lengkap

## Sistem Informasi Yayasan Darul Furqan Pariaman

> File SQL lengkap tersedia di: `pertanyaan_3.sql`

---

## Ringkasan Database

| Info          | Detail                                     |
| ------------- | ------------------------------------------ |
| Nama Database | `db_darul_furqan`                          |
| Platform      | MySQL 8.0+                                 |
| Charset       | utf8mb4 (Unicode penuh, mendukung emoji)   |
| Collation     | utf8mb4_unicode_ci                         |
| Engine        | InnoDB (mendukung foreign key & transaksi) |
| Total Tabel   | **24 tabel**                               |
| Total View    | **2 view pelaporan**                       |

---

## Arsitektur Database — Kelompok Tabel

### Grup 1: Sistem & Autentikasi (3 tabel)

```
roles ──────────────┐
                    ├──> admin_users ──> admin_activity_logs
wali_murid ─────────┘
```

### Grup 2: Profil & CMS (3 tabel)

```
profil_sekolah (singleton)
unit_sekolah ──> struktur_organisasi (self-referencing)
```

### Grup 3: SDM Sekolah (3 tabel)

```
unit_sekolah ──> guru_staff <── jabatan_guru
```

### Grup 4: Konten Sekolah (5 tabel)

```
unit_sekolah ──> fasilitas
unit_sekolah ──> ekstrakurikuler
unit_sekolah ──> prestasi
kategori_berita ──> berita <── admin_users
                    pengumuman <── admin_users
```

### Grup 5: Galeri & Media (2 tabel)

```
kategori_galeri ──> galeri <── admin_users
```

### Grup 6: Komunikasi (1 tabel)

```
pesan_kontak <── admin_users (read_by)
```

### Grup 7: PPDB (6 tabel inti)

```
tahun_ppdb ──> fase_ppdb     <── unit_sekolah
tahun_ppdb ──> persyaratan_ppdb <── unit_sekolah
tahun_ppdb ──> calon_siswa   <── wali_murid + unit_sekolah
               calon_siswa ──> dokumen_pendaftaran <── persyaratan_ppdb + admin_users
               calon_siswa ──> pembayaran_ppdb     <── admin_users
               calon_siswa ──> riwayat_status_ppdb <── admin_users
               calon_siswa ──> notifikasi_ppdb
```

### Grup 8: Pengaturan (2 tabel)

```
pengaturan_website (key-value store)
slider_banner
```

---

## Deskripsi Tabel Lengkap

### 1. `roles`

**Tujuan**: Master data peran/role untuk admin.

| Kolom          | Tipe               | Keterangan                                                                  |
| -------------- | ------------------ | --------------------------------------------------------------------------- |
| `id`           | TINYINT UNSIGNED   | PK auto increment                                                           |
| `name`         | VARCHAR(50) UNIQUE | Kode role: `super_admin`, `admin_konten`, `operator_ppdb`, `kepala_sekolah` |
| `display_name` | VARCHAR(100)       | Nama tampilan di UI                                                         |
| `description`  | TEXT               | Deskripsi kewenangan                                                        |

**Data Awal**: 4 role (Super Admin, Admin Konten, Operator PPDB, Kepala Sekolah)

---

### 2. `admin_users`

**Tujuan**: Akun pengguna back-end sistem.

| Kolom           | Tipe                | Keterangan                                   |
| --------------- | ------------------- | -------------------------------------------- |
| `id`            | INT UNSIGNED        | PK auto increment                            |
| `role_id`       | TINYINT UNSIGNED    | FK → roles.id                                |
| `name`          | VARCHAR(150)        | Nama lengkap admin                           |
| `email`         | VARCHAR(191) UNIQUE | Email login                                  |
| `password`      | VARCHAR(255)        | bcrypt hash, TIDAK pernah disimpan plaintext |
| `avatar`        | VARCHAR(255)        | Path foto profil                             |
| `is_active`     | TINYINT(1)          | Status akun aktif/nonaktif                   |
| `last_login_at` | TIMESTAMP           | Waktu login terakhir                         |

**Keamanan**: Password di-hash dengan bcrypt (cost factor ≥ 12).

---

### 3. `admin_activity_logs`

**Tujuan**: Audit trail semua aksi admin.

| Kolom        | Tipe            | Keterangan                                         |
| ------------ | --------------- | -------------------------------------------------- |
| `id`         | BIGINT UNSIGNED | PK auto increment (besar untuk log jangka panjang) |
| `admin_id`   | INT UNSIGNED    | FK → admin_users.id                                |
| `action`     | VARCHAR(100)    | Jenis aksi: `create`, `update`, `delete`, `login`  |
| `module`     | VARCHAR(100)    | Modul yang diakses: `berita`, `ppdb`, `galeri`     |
| `ip_address` | VARCHAR(45)     | Mendukung IPv4 dan IPv6                            |

---

### 4. `wali_murid`

**Tujuan**: Akun portal PPDB untuk orang tua/wali.

| Kolom               | Tipe                | Keterangan                                       |
| ------------------- | ------------------- | ------------------------------------------------ |
| `id`                | INT UNSIGNED        | PK auto increment                                |
| `email`             | VARCHAR(191) UNIQUE | Email login, juga sebagai penerima notifikasi    |
| `password`          | VARCHAR(255)        | bcrypt hash                                      |
| `is_email_verified` | TINYINT(1)          | Verifikasi email sebelum bisa submit pendaftaran |
| `email_verified_at` | TIMESTAMP           | Waktu verifikasi email                           |

---

### 5. `profil_sekolah`

**Tujuan**: Konten statis profil yayasan — **singleton** (satu baris data).

| Kolom                   | Tipe          | Keterangan                      |
| ----------------------- | ------------- | ------------------------------- |
| `nama_yayasan`          | VARCHAR(200)  | Yayasan Darul Furqan Pariaman   |
| `sejarah`               | LONGTEXT      | Narasi sejarah panjang          |
| `visi`, `misi`          | TEXT/LONGTEXT | Visi-misi sekolah               |
| `sambutan_kepala`       | LONGTEXT      | Teks sambutan kepala sekolah    |
| `latitude`, `longitude` | DECIMAL       | Koordinat GPS untuk Google Maps |
| `logo`                  | VARCHAR(255)  | Path logo utama sekolah         |

**Bisnis proses**: Admin hanya dapat mengedit (tidak menambah/menghapus).

---

### 6. `unit_sekolah`

**Tujuan**: Master data unit pendidikan di bawah yayasan.

| Kode        | Nama                          |
| ----------- | ----------------------------- |
| `PAUD`      | PAUD Darul Furqan             |
| `SDIT`      | SDIT Alam Darul Furqan        |
| `PESANTREN` | Pondok Pesantren Darul Furqan |

Digunakan sebagai **foreign key di hampir semua tabel** untuk memisahkan data antar unit.

---

### 7. `struktur_organisasi`

**Tujuan**: Bagan organisasi dengan hierarki self-referencing.

- `parent_id` → FK ke tabel yang sama (node anak merujuk ke node induk)
- Memungkinkan pohon hierarki tidak terbatas kedalamannya
- `unit_id = NULL` = posisi di level yayasan

---

### 8. `guru_staff`

**Tujuan**: Data lengkap SDM pengajar dan tenaga kependidikan.

| Kolom              | Tipe               | Keterangan                       |
| ------------------ | ------------------ | -------------------------------- |
| `nip`              | VARCHAR(30) UNIQUE | Nomor Induk Pegawai (boleh null) |
| `pendidikan`       | VARCHAR(50)        | S1, S2, S3, D3                   |
| `pengalaman_tahun` | TINYINT            | Lama pengalaman mengajar         |
| `is_active`        | TINYINT(1)         | Status aktif/pensiun/resign      |

---

### 9. `berita`

**Tujuan**: Konten artikel dan berita sekolah.

| Kolom          | Tipe                | Keterangan                         |
| -------------- | ------------------- | ---------------------------------- |
| `slug`         | VARCHAR(320) UNIQUE | URL-friendly identifier (SEO)      |
| `status`       | ENUM                | `draft` / `published` / `archived` |
| `views`        | INT UNSIGNED        | Counter jumlah dibaca              |
| `published_at` | TIMESTAMP           | Dapat dijadwalkan di masa depan    |

**Index**: `status`, `published_at` untuk performa query halaman publik.

---

### 10. `pengumuman`

**Tujuan**: Pengumuman resmi sekolah.

| Kolom            | Tipe         | Keterangan                            |
| ---------------- | ------------ | ------------------------------------- |
| `is_urgent`      | TINYINT(1)   | Flag pengumuman penting (label merah) |
| `tayang_mulai`   | DATE         | Mulai ditampilkan ke publik           |
| `tayang_selesai` | DATE         | Berhenti ditampilkan otomatis         |
| `lampiran`       | VARCHAR(255) | Path file PDF lampiran                |

---

### 11. `calon_siswa` _(Tabel Utama PPDB)_

**Tujuan**: Data lengkap calon siswa pendaftar PPDB — tabel terpenting di modul PPDB.

**Status Flow**:

```
draft
  └─> submitted
        └─> menunggu_verifikasi_berkas
              ├─> berkas_lengkap
              │     └─> menunggu_pembayaran
              │           └─> pembayaran_terverifikasi
              │                 ├─> lulus_seleksi
              │                 │     ├─> daftar_ulang ──> diterima
              │                 │     └─> mengundurkan_diri
              │                 └─> tidak_lulus
              └─> berkas_tidak_lengkap (kembali ke wali untuk dilengkapi)
```

**Nomor Pendaftaran Format**: `PPDB-[TAHUN]-[KODE_UNIT]-[NOMER_URUT]`  
Contoh: `PPDB-2026-SDIT-0001`

---

### 12. `dokumen_pendaftaran`

**Tujuan**: Menyimpan referensi file dokumen yang diupload calon siswa.

- Setiap baris = 1 file dokumen
- Satu pendaftar bisa memiliki banyak dokumen (one-to-many)
- Admin dapat verifikasi setiap dokumen secara individual
- `status_verif`: `menunggu` → `valid` / `tidak_valid`

---

### 13. `pembayaran_ppdb`

**Tujuan**: Rekam jejak pembayaran biaya pendaftaran.

- Relasi 1-to-1 dengan `calon_siswa` (UNIQUE constraint pada `calon_siswa_id`)
- Admin upload bukti transfer dan memverifikasi
- `status`: `belum_bayar` → `menunggu_verifikasi` → `terverifikasi` / `ditolak`

---

### 14. `riwayat_status_ppdb`

**Tujuan**: Audit trail perubahan status pendaftar.

- Setiap perubahan status dicatat beserta siapa yang mengubah dan kapan
- Penting untuk transparansi dan investigasi jika ada sengketa

---

### 15. `pengaturan_website`

**Tujuan**: Konfigurasi website menggunakan pola key-value store.

| Key                | Value                   | Grup |
| ------------------ | ----------------------- | ---- |
| `site_title`       | Yayasan Darul Furqan... | umum |
| `ppdb_is_open`     | 1                       | ppdb |
| `maintenance_mode` | 0                       | umum |

Pola ini memungkinkan admin menambah pengaturan baru tanpa migrasi database.

---

## Entity Relationship Diagram (Teks)

```
┌──────────────┐         ┌────────────────┐
│  admin_users │────────>│     roles      │
└──────┬───────┘         └────────────────┘
       │
       ├──────────────────────────────────────┐
       │                                      │
       v                                      v
┌──────────────┐    ┌───────────────┐  ┌─────────────────┐
│    berita    │    │  pengumuman   │  │ activity_logs   │
└──────────────┘    └───────────────┘  └─────────────────┘

┌──────────────┐         ┌────────────────┐
│  wali_murid  │────────>│  calon_siswa   │
└──────────────┘         └───────┬────────┘
                                 │
                    ┌────────────┼────────────┐
                    v            v            v
             ┌──────────┐ ┌──────────┐ ┌──────────────┐
             │ dokumen_ │ │pembayar- │ │  riwayat_    │
             │pendaftar │ │an_ppdb   │ │ status_ppdb  │
             └──────────┘ └──────────┘ └──────────────┘
                    │
                    v
             ┌──────────────┐
             │ persyaratan_ │
             │    ppdb      │
             └──────────────┘

┌──────────────┐     ┌──────────┐
│  tahun_ppdb  │────>│fase_ppdb │
└──────────────┘     └──────────┘

┌──────────────────────────────────────────────────────────────┐
│                         unit_sekolah                         │
│  (direferensi oleh: guru_staff, fasilitas, ekstrakurikuler,  │
│   prestasi, calon_siswa, fase_ppdb, persyaratan_ppdb)        │
└──────────────────────────────────────────────────────────────┘
```

---

## Relasi Antar Tabel (Foreign Keys)

| Tabel                 | Kolom FK         | Merujuk ke               | ON DELETE |
| --------------------- | ---------------- | ------------------------ | --------- |
| `admin_users`         | `role_id`        | `roles.id`               | RESTRICT  |
| `admin_activity_logs` | `admin_id`       | `admin_users.id`         | RESTRICT  |
| `struktur_organisasi` | `parent_id`      | `struktur_organisasi.id` | SET NULL  |
| `struktur_organisasi` | `unit_id`        | `unit_sekolah.id`        | SET NULL  |
| `guru_staff`          | `unit_id`        | `unit_sekolah.id`        | RESTRICT  |
| `guru_staff`          | `jabatan_id`     | `jabatan_guru.id`        | SET NULL  |
| `fasilitas`           | `unit_id`        | `unit_sekolah.id`        | SET NULL  |
| `ekstrakurikuler`     | `unit_id`        | `unit_sekolah.id`        | SET NULL  |
| `prestasi`            | `unit_id`        | `unit_sekolah.id`        | SET NULL  |
| `berita`              | `kategori_id`    | `kategori_berita.id`     | SET NULL  |
| `berita`              | `admin_id`       | `admin_users.id`         | RESTRICT  |
| `pengumuman`          | `admin_id`       | `admin_users.id`         | RESTRICT  |
| `galeri`              | `kategori_id`    | `kategori_galeri.id`     | SET NULL  |
| `galeri`              | `admin_id`       | `admin_users.id`         | RESTRICT  |
| `pesan_kontak`        | `read_by`        | `admin_users.id`         | SET NULL  |
| `fase_ppdb`           | `tahun_id`       | `tahun_ppdb.id`          | CASCADE   |
| `fase_ppdb`           | `unit_id`        | `unit_sekolah.id`        | RESTRICT  |
| `persyaratan_ppdb`    | `unit_id`        | `unit_sekolah.id`        | RESTRICT  |
| `persyaratan_ppdb`    | `tahun_id`       | `tahun_ppdb.id`          | RESTRICT  |
| `calon_siswa`         | `wali_id`        | `wali_murid.id`          | RESTRICT  |
| `calon_siswa`         | `unit_id`        | `unit_sekolah.id`        | RESTRICT  |
| `calon_siswa`         | `tahun_id`       | `tahun_ppdb.id`          | RESTRICT  |
| `dokumen_pendaftaran` | `calon_siswa_id` | `calon_siswa.id`         | CASCADE   |
| `dokumen_pendaftaran` | `syarat_id`      | `persyaratan_ppdb.id`    | SET NULL  |
| `dokumen_pendaftaran` | `verified_by`    | `admin_users.id`         | SET NULL  |
| `pembayaran_ppdb`     | `calon_siswa_id` | `calon_siswa.id`         | CASCADE   |
| `pembayaran_ppdb`     | `verified_by`    | `admin_users.id`         | SET NULL  |
| `riwayat_status_ppdb` | `calon_siswa_id` | `calon_siswa.id`         | CASCADE   |
| `notifikasi_ppdb`     | `calon_siswa_id` | `calon_siswa.id`         | CASCADE   |

---

## Normalisasi Database

Database dirancang mengikuti **Bentuk Normal Ketiga (3NF)**:

- **1NF** ✅ Setiap sel berisi nilai atomik; tidak ada repeating groups
- **2NF** ✅ Semua atribut non-key bergantung penuh pada primary key
- **3NF** ✅ Tidak ada ketergantungan transitif antar atribut non-key

Pengecualian terkontrol (denormalisasi demi performa):

- `calon_siswa.no_hp_ortu` disimpan langsung (redundan dengan `wali_murid.phone`) agar riwayat pendaftaran tidak berubah jika wali mengubah profilnya.
- `riwayat_status_ppdb.status_lama` dan `status_baru` disimpan sebagai string, bukan FK, agar riwayat tetap valid jika ENUM status berubah di masa depan.

---

## Contoh Query Bisnis Proses

### 1. Ambil semua pendaftar aktif dengan status pembayaran

```sql
SELECT
    cs.nomor_pendaftaran,
    cs.nama_lengkap,
    u.nama                  AS unit,
    cs.status               AS status_pendaftaran,
    COALESCE(p.status, 'belum_bayar') AS status_bayar
FROM calon_siswa cs
JOIN unit_sekolah u ON cs.unit_id = u.id
LEFT JOIN pembayaran_ppdb p ON p.calon_siswa_id = cs.id
WHERE cs.tahun_id = (SELECT id FROM tahun_ppdb WHERE is_aktif = 1)
ORDER BY cs.submitted_at DESC;
```

### 2. Statistik pendaftar per unit untuk dashboard

```sql
SELECT * FROM v_statistik_ppdb
WHERE tahun_ajaran = '2026/2027';
```

### 3. Cari berita yang dipublikasikan berdasarkan kategori

```sql
SELECT b.judul, b.slug, b.ringkasan, b.foto_cover, b.published_at, k.nama AS kategori
FROM berita b
LEFT JOIN kategori_berita k ON b.kategori_id = k.id
WHERE b.status = 'published'
  AND b.published_at <= NOW()
ORDER BY b.published_at DESC
LIMIT 10;
```

### 4. Ambil pengumuman aktif untuk halaman publik

```sql
SELECT judul, isi, kategori, is_urgent, tayang_selesai
FROM pengumuman
WHERE status = 'published'
  AND tayang_mulai <= CURDATE()
  AND (tayang_selesai IS NULL OR tayang_selesai >= CURDATE())
ORDER BY is_urgent DESC, created_at DESC;
```

### 5. Verifikasi semua dokumen selesai sebelum status bisa diubah

```sql
SELECT
    cs.id,
    cs.nama_lengkap,
    COUNT(dp.id)                                 AS total_dokumen,
    SUM(dp.status_verif = 'valid')               AS dokumen_valid,
    SUM(dp.status_verif = 'tidak_valid')         AS dokumen_invalid,
    SUM(dp.status_verif = 'menunggu')            AS dokumen_menunggu
FROM calon_siswa cs
JOIN dokumen_pendaftaran dp ON dp.calon_siswa_id = cs.id
WHERE cs.id = ?
GROUP BY cs.id;
```

### 6. Riwayat perubahan status satu pendaftar

```sql
SELECT
    rs.created_at,
    rs.status_lama,
    rs.status_baru,
    rs.keterangan,
    au.name AS diubah_oleh
FROM riwayat_status_ppdb rs
LEFT JOIN admin_users au ON rs.admin_id = au.id
WHERE rs.calon_siswa_id = ?
ORDER BY rs.created_at ASC;
```

---

## Keamanan Data

1. **Password**: Semua password di-hash dengan bcrypt, tidak pernah disimpan plaintext
2. **File Upload**: Path file disimpan di database, file aktual di storage server (bukan root publik)
3. **Soft Delete**: Tabel penting menggunakan `is_active` flag daripada menghapus data
4. **Audit Trail**: Semua perubahan penting dicatat di `admin_activity_logs` dan `riwayat_status_ppdb`
5. **Constraint**: Foreign key dengan `ON DELETE CASCADE` hanya pada relasi anak (dokumen, riwayat), sementara relasi master menggunakan `RESTRICT` untuk mencegah penghapusan tidak sengaja

---

## Ringkasan Tabel

| No  | Nama Tabel          | Grup   | Baris Estimasi    |
| --- | ------------------- | ------ | ----------------- |
| 1   | roles               | Auth   | 4 (statis)        |
| 2   | admin_users         | Auth   | < 50              |
| 3   | admin_activity_logs | Auth   | Jutaan (log)      |
| 4   | wali_murid          | Auth   | Ratusan – ribuan  |
| 5   | profil_sekolah      | CMS    | 1 (singleton)     |
| 6   | unit_sekolah        | CMS    | 3 (statis)        |
| 7   | struktur_organisasi | CMS    | < 50              |
| 8   | jabatan_guru        | SDM    | < 30              |
| 9   | guru_staff          | SDM    | Puluhan – ratusan |
| 10  | fasilitas           | Konten | < 50              |
| 11  | ekstrakurikuler     | Konten | < 30              |
| 12  | prestasi            | Konten | Ratusan           |
| 13  | kategori_berita     | Konten | < 20              |
| 14  | berita              | Konten | Ratusan – ribuan  |
| 15  | pengumuman          | Konten | Puluhan – ratusan |
| 16  | kategori_galeri     | Media  | < 20              |
| 17  | galeri              | Media  | Ratusan           |
| 18  | pesan_kontak        | Kontak | Puluhan – ratusan |
| 19  | tahun_ppdb          | PPDB   | < 20 (per tahun)  |
| 20  | fase_ppdb           | PPDB   | < 50              |
| 21  | persyaratan_ppdb    | PPDB   | < 50              |
| 22  | calon_siswa         | PPDB   | Ratusan per tahun |
| 23  | dokumen_pendaftaran | PPDB   | Ribuan            |
| 24  | pembayaran_ppdb     | PPDB   | Ratusan per tahun |
| 25  | riwayat_status_ppdb | PPDB   | Ribuan            |
| 26  | notifikasi_ppdb     | PPDB   | Ribuan            |
| 27  | pengaturan_website  | Config | < 50              |
| 28  | slider_banner       | Config | < 10              |

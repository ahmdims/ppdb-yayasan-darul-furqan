// main.js — Darul Furqan Website Interactivity

// Navbar scroll effect
const navbar = document.getElementById('navbar');
if (navbar) {
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 30);
  });
}

// Hamburger menu
const hamburger = document.getElementById('hamburger');
const navLinks  = document.getElementById('navLinks');
if (hamburger && navLinks) {
  hamburger.addEventListener('click', () => {
    navLinks.classList.toggle('open');
    hamburger.classList.toggle('open');
  });
  // Close on link click
  navLinks.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => { navLinks.classList.remove('open'); hamburger.classList.remove('open'); });
  });
}

// Tab switching
document.querySelectorAll('.tab-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const target = btn.dataset.tab;
    const parent = btn.closest('.tabs-wrapper') || document;
    parent.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    parent.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    btn.classList.add('active');
    const content = document.getElementById(target);
    if (content) content.classList.add('active');
  });
});

// Filter buttons
document.querySelectorAll('.filter-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const group = btn.closest('.galeri-filter') || btn.closest('.prestasi-filter');
    if (group) group.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
  });
});

// Status check form (PPDB)
const statusForm = document.getElementById('statusCheckForm');
if (statusForm) {
  statusForm.addEventListener('submit', e => {
    e.preventDefault();
    const noInput = document.getElementById('noPendaftaran');
    const resultEl = document.getElementById('statusResult');
    if (!noInput || !resultEl) return;
    const val = noInput.value.trim().toUpperCase();
    // Simulate result
    if (val === 'DF-2025-SDIT-0001') {
      resultEl.innerHTML = `
        <div class="status-badge status-diterima">✅ DITERIMA</div>
        <div style="font-size:.9rem;">
          <strong>Nomor Pendaftaran:</strong> ${val}<br/>
          <strong>Nama:</strong> Ahmad Fauzan<br/>
          <strong>Program:</strong> SDIT Alam Darul Furqan<br/>
          <strong>Tahun Ajaran:</strong> 2025/2026<br/>
          <p style="margin-top:.75rem;color:#065f46;font-weight:600;">Selamat! Peserta dinyatakan DITERIMA. Silakan datang ke sekolah untuk proses selanjutnya.</p>
        </div>`;
    } else if (val) {
      resultEl.innerHTML = `
        <div class="status-badge status-menunggu">⏳ MENUNGGU</div>
        <div style="font-size:.9rem;">
          <strong>Nomor Pendaftaran:</strong> ${val}<br/>
          <p style="margin-top:.75rem;color:#d97706;">Pendaftaran Anda masih dalam proses verifikasi. Silakan cek kembali dalam 1–3 hari kerja.</p>
        </div>`;
    } else {
      resultEl.innerHTML = `<p style="color:#ef4444;font-size:.9rem;">Nomor pendaftaran tidak ditemukan. Pastikan nomor yang dimasukkan benar.</p>`;
    }
    resultEl.classList.add('show');
    resultEl.style.background = '#f0fdf4';
    resultEl.style.border = '1px solid #bbf7d0';
    resultEl.style.borderRadius = '12px';
    resultEl.style.padding = '1.5rem';
  });
}

// PPDB multi-step form
let currentStep = 1;
const totalSteps = 4;

function updateSteps() {
  document.querySelectorAll('.step-item').forEach((el, i) => {
    el.classList.remove('active', 'done');
    if (i + 1 < currentStep) el.classList.add('done');
    if (i + 1 === currentStep) el.classList.add('active');
  });
  document.querySelectorAll('.form-step').forEach((el, i) => {
    el.style.display = i + 1 === currentStep ? 'block' : 'none';
  });
  const prev = document.getElementById('prevBtn');
  const next = document.getElementById('nextBtn');
  const submit = document.getElementById('submitBtn');
  if (prev) prev.style.display = currentStep > 1 ? 'inline-flex' : 'none';
  if (next) next.style.display = currentStep < totalSteps ? 'inline-flex' : 'none';
  if (submit) submit.style.display = currentStep === totalSteps ? 'inline-flex' : 'none';
}

function showPpdbToast(message) {
  let toast = document.getElementById('ppdbToast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'ppdbToast';
    toast.className = 'ppdb-toast';
    document.body.appendChild(toast);
  }

  toast.textContent = message;
  toast.classList.add('show');

  clearTimeout(showPpdbToast.hideTimer);
  showPpdbToast.hideTimer = setTimeout(() => {
    toast.classList.remove('show');
  }, 2800);
}

function getFieldLabel(field) {
  const group = field.closest('.form-group');
  const label = group ? group.querySelector('.form-label') : null;
  if (label) {
    return label.textContent.replace('*', '').trim();
  }

  return field.placeholder || 'Kolom wajib diisi';
}

function validateCurrentStep() {
  const steps = document.querySelectorAll('.form-step');
  const activeStep = steps[currentStep - 1];
  if (!activeStep) return { isValid: true, missingFields: [] };

  const requiredFields = activeStep.querySelectorAll('[required]');
  let isValid = true;
  const missingFields = [];

  requiredFields.forEach(field => {
    const value = field.type === 'checkbox' || field.type === 'radio' ? field.checked : field.value.trim();
    if (!value) {
      isValid = false;
      field.classList.add('is-invalid');
      missingFields.push(getFieldLabel(field));
    } else {
      field.classList.remove('is-invalid');
    }
  });

  if (!isValid && missingFields.length) {
    showPpdbToast(`⚠️ Peringatan: mohon isi ${missingFields[0]}${missingFields.length > 1 ? ` dan ${missingFields.length - 1} field lainnya` : ''}`);
    const firstInvalid = activeStep.querySelector('.is-invalid');
    if (firstInvalid && typeof firstInvalid.focus === 'function') {
      firstInvalid.focus({ preventScroll: true });
    }
  }

  return { isValid, missingFields };
}

function generateRegistrationCode() {
  const programField = document.querySelector('#ppdbForm select.form-select');
  const programValue = programField ? programField.value : 'SDIT';
  const year = new Date().getFullYear();
  const randomNumber = String(Math.floor(Math.random() * 9000) + 1000);

  return `DF-${year}-${programValue || 'SDIT'}-${randomNumber}`;
}

const ppdbForm = document.getElementById('ppdbForm');
if (ppdbForm) {
  ppdbForm.addEventListener('submit', e => {
    e.preventDefault();

    const validation = validateCurrentStep();
    if (!validation.isValid) return;

    const code = generateRegistrationCode();
    const studentNameInput = ppdbForm.querySelector('input[placeholder="Nama sesuai akta kelahiran"]');
    const studentName = studentNameInput ? studentNameInput.value.trim() : 'Calon Siswa';

    const modal = document.createElement('div');
    modal.style.cssText = `
      position: fixed;
      inset: 0;
      background: rgba(15, 23, 42, .6);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 9999;
      padding: 1.25rem;
    `;

    modal.innerHTML = `
      <div style="max-width:520px;width:100%;background:#fff;border-radius:20px;padding:1.75rem;box-shadow:0 24px 60px rgba(15,23,42,.25);">
        <div style="width:56px;height:56px;border-radius:999px;background:#dcfce7;color:#047857;display:flex;align-items:center;justify-content:center;font-size:1.7rem;font-weight:800;margin:0 auto 1rem;">✓</div>
        <h2 style="text-align:center;font-size:1.5rem;font-weight:800;color:#0f172a;margin-bottom:.35rem;">Pendaftaran Berhasil</h2>
        <p style="text-align:center;color:#64748b;font-size:.95rem;margin-bottom:1.25rem;">Terima kasih, ${studentName}. Data Anda sudah tersimpan.</p>
        <div style="background:#f0fdf4;border:1px solid #bbf7d0;border-radius:16px;padding:1.25rem;text-align:center;margin-bottom:1.25rem;">
          <div style="font-size:.8rem;font-weight:700;color:#047857;letter-spacing:.08em;text-transform:uppercase;margin-bottom:.4rem;">Kode Pendaftaran</div>
          <div style="font-size:1.4rem;font-weight:800;color:#065f46;letter-spacing:.08em;font-family:monospace;">${code}</div>
        </div>
        <div style="background:#fff7ed;border:1px solid #fdba74;border-radius:14px;padding:1rem;margin-bottom:1.25rem;">
          <p style="font-size:.9rem;font-weight:700;color:#9a3412;margin-bottom:.5rem;">Info Dummy</p>
          <ul style="margin:0;padding-left:1.1rem;color:#c2410c;font-size:.88rem;display:flex;flex-direction:column;gap:.35rem;">
            <li>Kode ini bisa dipakai untuk cek status pendaftaran.</li>
            <li>Nomor ini bersifat dummy untuk demo alur PPDB.</li>
            <li>Simpan kode ini sebelum menutup halaman.</li>
          </ul>
        </div>
        <button type="button" id="closePpdbModal" style="width:100%;padding:.8rem 1rem;border:none;border-radius:12px;background:linear-gradient(135deg, var(--primary-light), var(--primary-dark));color:#fff;font-weight:700;cursor:pointer;">Tutup</button>
      </div>
    `;

    document.body.appendChild(modal);

    const closeModal = () => {
      modal.remove();
      ppdbForm.reset();
      currentStep = 1;
      updateSteps();
    };

    modal.querySelector('#closePpdbModal')?.addEventListener('click', closeModal);
    modal.addEventListener('click', event => {
      if (event.target === modal) closeModal();
    });
  });
}

const nextBtn = document.getElementById('nextBtn');
const prevBtn = document.getElementById('prevBtn');
if (nextBtn) nextBtn.addEventListener('click', () => {
  const validation = validateCurrentStep();
  if (!validation.isValid) return;
  if (currentStep < totalSteps) {
    currentStep++;
    updateSteps();
    window.scrollTo({ top: 400, behavior: 'smooth' });
  }
});
if (prevBtn) prevBtn.addEventListener('click', () => { if (currentStep > 1) { currentStep--; updateSteps(); } });
if (document.querySelector('.form-step')) updateSteps();

// Contact form
const contactForm = document.getElementById('contactForm');
if (contactForm) {
  contactForm.addEventListener('submit', e => {
    e.preventDefault();
    const btn = contactForm.querySelector('button[type=submit]');
    btn.textContent = '✅ Pesan Terkirim!';
    btn.disabled = true;
    btn.style.background = '#065f46';
    setTimeout(() => { contactForm.reset(); btn.textContent = 'Kirim Pesan'; btn.disabled = false; btn.style.background = ''; }, 3000);
  });
}

// Admin sidebar toggle
const sidebarToggle   = document.getElementById('sidebarToggle');
const adminSidebar    = document.getElementById('adminSidebar');
const sidebarOverlay  = document.getElementById('sidebarOverlay');
if (sidebarToggle && adminSidebar) {
  sidebarToggle.addEventListener('click', () => {
    adminSidebar.classList.toggle('open');
    if (sidebarOverlay) sidebarOverlay.classList.toggle('show');
  });
  if (sidebarOverlay) {
    sidebarOverlay.addEventListener('click', () => {
      adminSidebar.classList.remove('open');
      sidebarOverlay.classList.remove('show');
    });
  }
}

// Smooth page entrance
document.body.style.opacity = '0';
window.addEventListener('DOMContentLoaded', () => {
  document.body.style.transition = 'opacity .35s ease';
  document.body.style.opacity = '1';
});

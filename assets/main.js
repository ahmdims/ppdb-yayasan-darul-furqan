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

const nextBtn = document.getElementById('nextBtn');
const prevBtn = document.getElementById('prevBtn');
if (nextBtn) nextBtn.addEventListener('click', () => { if (currentStep < totalSteps) { currentStep++; updateSteps(); window.scrollTo({ top: 400, behavior: 'smooth' }); } });
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

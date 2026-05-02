import re, os

BASE = r"d:\Users\DIMAS\Downloads\Tugas\nomor_4"

SOCIAL_ICONS = """            <a href="#" class="social-btn" aria-label="Instagram"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg></a>
            <a href="#" class="social-btn" aria-label="Facebook"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg></a>
            <a href="#" class="social-btn" aria-label="YouTube"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg></a>
            <a href="#" class="social-btn" aria-label="WhatsApp"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413Z"/></svg></a>"""

MAP_ICON = """<svg class="contact-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-2.003 3.5-4.697 3.5-8.327a8 8 0 0 0-16 0c0 3.63 1.556 6.326 3.5 8.327a19.58 19.58 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.145.742Z" clip-rule="evenodd"/></svg>"""
PHONE_ICON = """<svg class="contact-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path fill-rule="evenodd" d="M1.5 4.5a3 3 0 0 1 3-3h1.372c.86 0 1.61.586 1.819 1.42l1.105 4.423a1.875 1.875 0 0 1-.694 1.955l-1.293.97c-.135.101-.164.249-.126.352a11.285 11.285 0 0 0 6.697 6.697c.103.038.25.009.352-.126l.97-1.293a1.875 1.875 0 0 1 1.955-.694l4.423 1.105c.834.209 1.42.959 1.42 1.82V19.5a3 3 0 0 1-3 3h-2.25C8.552 22.5 1.5 15.448 1.5 6.75V4.5Z" clip-rule="evenodd"/></svg>"""
MAIL_ICON = """<svg class="contact-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M1.5 8.67v8.58a3 3 0 0 0 3 3h15a3 3 0 0 0 3-3V8.67l-8.928 5.493a3 3 0 0 1-3.144 0L1.5 8.67Z"/><path d="M22.5 6.908V6.75a3 3 0 0 0-3-3h-15a3 3 0 0 0-3 3v.158l9.714 5.978a1.5 1.5 0 0 0 1.572 0L22.5 6.908Z"/></svg>"""

def full_footer(asset="assets"):
    admin_link = "admin/login.html" if asset == "assets" else "../admin/login.html"
    prefix = "" if asset == "assets" else "../"
    return f"""  <footer class="footer">
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand-col">
          <div class="footer-brand">
            <img src="{asset}/logo.png" class="brand-logo-img" alt="Logo Darul Furqan" />
          </div>
          <p class="footer-tagline">Membentuk generasi cerdas, berakhlak mulia, dan berdaya saing untuk masa depan bangsa.</p>
          <div class="footer-social">
{SOCIAL_ICONS}
          </div>
        </div>
        <div>
          <h4 class="footer-heading">Navigasi</h4>
          <ul class="footer-links">
            <li><a href="{prefix}index.html">Beranda</a></li>
            <li><a href="{prefix}profil.html">Profil Sekolah</a></li>
            <li><a href="{prefix}ppdb.html">PPDB Online</a></li>
            <li><a href="{prefix}berita.html">Berita &amp; Artikel</a></li>
            <li><a href="{prefix}galeri.html">Galeri</a></li>
            <li><a href="{prefix}prestasi.html">Prestasi</a></li>
            <li><a href="{prefix}kontak.html">Kontak</a></li>
          </ul>
        </div>
        <div>
          <h4 class="footer-heading">Program</h4>
          <ul class="footer-links">
            <li><a href="{prefix}profil.html#program">PAUD Darul Furqan</a></li>
            <li><a href="{prefix}profil.html#program">SDIT Alam</a></li>
            <li><a href="{prefix}profil.html#program">Pondok Pesantren</a></li>
          </ul>
        </div>
        <div>
          <h4 class="footer-heading">Kontak</h4>
          <ul class="footer-contact-list">
            <li>
              {MAP_ICON}
              <span>Jl. Raya Pariaman, Kota Pariaman, Sumatera Barat</span>
            </li>
            <li>
              {PHONE_ICON}
              <span>0751-XXXXX</span>
            </li>
            <li>
              {MAIL_ICON}
              <span>info@darulfurqan.sch.id</span>
            </li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&#169; 2025 Yayasan Darul Furqan Pariaman. Semua hak dilindungi.</p>
        <a href="{admin_link}" class="footer-admin-link">Admin Panel</a>
      </div>
    </div>
  </footer>"""

def remove_brand_text(html):
    # single-line: <div><div class="brand-name">...</div><div class="brand-sub">...</div></div>
    html = re.sub(r'\s*<div>\s*<div class="brand-name">[^<]*</div>\s*<div class="brand-sub">[^<]*</div>\s*</div>', '', html)
    # multi-line version
    html = re.sub(r'\s*<div>\s*\n\s*<div class="brand-name">[^<]*</div>\s*\n\s*<div class="brand-sub">[^<]*</div>\s*\n\s*</div>', '', html)
    # standalone brand-name + brand-sub without wrapper (footer case)
    html = re.sub(r'\s*<div class="brand-name">[^<]*</div>\s*\n?\s*<div class="brand-sub">[^<]*</div>', '', html)
    # standalone brand-name alone
    html = re.sub(r'\s*<div class="brand-name">[^<]*</div>', '', html)
    return html

def fix_footer(html, asset="assets"):
    html = re.sub(r'[ \t]*<footer class="footer">.*?</footer>', full_footer(asset), html, flags=re.DOTALL)
    return html

# public pages
for name in ["index.html","profil.html","ppdb.html","berita.html","galeri.html","prestasi.html","kontak.html"]:
    path = os.path.join(BASE, name)
    with open(path, encoding="utf-8") as f:
        html = f.read()
    html = remove_brand_text(html)
    html = fix_footer(html, "assets")
    with open(path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"OK {name}")

# admin dashboard - only remove brand text from sidebar
path = os.path.join(BASE, "admin", "dashboard.html")
with open(path, encoding="utf-8") as f:
    html = f.read()
html = remove_brand_text(html)
with open(path, "w", encoding="utf-8") as f:
    f.write(html)
print("OK admin/dashboard.html")

print("Done!")

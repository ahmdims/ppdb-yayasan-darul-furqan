#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Transform HTML files: emoji → SVG, logo, blank images"""

import os, re

BASE = r"d:\Users\DIMAS\Downloads\Tugas\nomor_4"

# ── SVG path data ─────────────────────────────────────────────────────────────
P = {
  "map":      """<path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-2.003 3.5-4.697 3.5-8.327a8 8 0 0 0-16 0c0 3.63 1.556 6.326 3.5 8.327a19.58 19.58 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.145.742Z" clip-rule="evenodd"/>""",
  "phone":    """<path fill-rule="evenodd" d="M1.5 4.5a3 3 0 0 1 3-3h1.372c.86 0 1.61.586 1.819 1.42l1.105 4.423a1.875 1.875 0 0 1-.694 1.955l-1.293.97c-.135.101-.164.249-.126.352a11.285 11.285 0 0 0 6.697 6.697c.103.038.25.009.352-.126l.97-1.293a1.875 1.875 0 0 1 1.955-.694l4.423 1.105c.834.209 1.42.959 1.42 1.82V19.5a3 3 0 0 1-3 3h-2.25C8.552 22.5 1.5 15.448 1.5 6.75V4.5Z" clip-rule="evenodd"/>""",
  "mail":     """<path d="M1.5 8.67v8.58a3 3 0 0 0 3 3h15a3 3 0 0 0 3-3V8.67l-8.928 5.493a3 3 0 0 1-3.144 0L1.5 8.67Z"/><path d="M22.5 6.908V6.75a3 3 0 0 0-3-3h-15a3 3 0 0 0-3 3v.158l9.714 5.978a1.5 1.5 0 0 0 1.572 0L22.5 6.908Z"/>""",
  "chat":     """<path fill-rule="evenodd" d="M4.848 2.771A49.144 49.144 0 0 1 12 2.25c2.43 0 4.817.178 7.152.52 1.978.292 3.348 2.024 3.348 3.97v6.02c0 1.946-1.37 3.678-3.348 3.97a48.901 48.901 0 0 1-3.476.383.39.39 0 0 0-.297.17l-2.755 4.133a.75.75 0 0 1-1.248 0l-2.755-4.133a.39.39 0 0 0-.297-.17 48.9 48.9 0 0 1-3.476-.384c-1.978-.29-3.348-2.024-3.348-3.97V6.741c0-1.946 1.37-3.68 3.348-3.97Z" clip-rule="evenodd"/>""",
  "clock":    """<path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25ZM12.75 6a.75.75 0 0 0-1.5 0v6c0 .414.336.75.75.75h4.5a.75.75 0 0 0 0-1.5h-3.75V6Z" clip-rule="evenodd"/>""",
  "trophy":   """<path fill-rule="evenodd" d="M5.166 2.621v.858c-1.035.148-2.059.33-3.071.543a.75.75 0 0 0-.584.859 6.753 6.753 0 0 0 6.138 5.6 6.73 6.73 0 0 0 2.743 1.346A6.707 6.707 0 0 1 9.279 15H8.54c-1.036 0-1.875.84-1.875 1.875V19.5h-.75a2.25 2.25 0 0 0-2.25 2.25c0 .414.336.75.75.75h15a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-2.25-2.25h-.75v-2.625c0-1.036-.84-1.875-1.875-1.875h-.739a6.706 6.706 0 0 1-1.112-3.173 6.73 6.73 0 0 0 2.743-1.347 6.753 6.753 0 0 0 6.139-5.6.75.75 0 0 0-.585-.858 47.077 47.077 0 0 0-3.07-.543V2.62a.75.75 0 0 0-.658-.744 49.798 49.798 0 0 0-6.093-.377c-2.063 0-4.096.128-6.093.377a.75.75 0 0 0-.657.744Zm0 2.629c0 1.196.312 2.32.857 3.294A5.266 5.266 0 0 1 3.16 5.337a45.6 45.6 0 0 1 2.006-.343v.256Zm13.5 0v-.256c.674.1 1.343.214 2.006.343a5.265 5.265 0 0 1-2.863 3.207 6.72 6.72 0 0 0 .857-3.294Z" clip-rule="evenodd"/>""",
  "star":     """<path fill-rule="evenodd" d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.006 5.404.434c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.434 2.082-5.005Z" clip-rule="evenodd"/>""",
  "user":     """<path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd"/>""",
  "chart":    """<path d="M18.375 2.25c-1.035 0-1.875.84-1.875 1.875v15.75c0 1.035.84 1.875 1.875 1.875h.75c1.035 0 1.875-.84 1.875-1.875V4.125c0-1.036-.84-1.875-1.875-1.875h-.75ZM9.75 8.625c0-1.036.84-1.875 1.875-1.875h.75c1.036 0 1.875.84 1.875 1.875v11.25c0 1.035-.84 1.875-1.875 1.875h-.75a1.875 1.875 0 0 1-1.875-1.875V8.625ZM3 13.125c0-1.036.84-1.875 1.875-1.875h.75c1.036 0 1.875.84 1.875 1.875v6.75c0 1.035-.84 1.875-1.875 1.875h-.75A1.875 1.875 0 0 1 3 19.875v-6.75Z"/>""",
  "news":     """<path fill-rule="evenodd" d="M4.125 3C3.089 3 2.25 3.84 2.25 4.875V18a3 3 0 0 0 3 3h15a3 3 0 0 1-3-3V4.875C17.25 3.839 16.41 3 15.375 3H4.125ZM12 9.75a.75.75 0 0 0 0 1.5h1.5a.75.75 0 0 0 0-1.5H12Zm-.75-2.25a.75.75 0 0 1 .75-.75h1.5a.75.75 0 0 1 0 1.5H12a.75.75 0 0 1-.75-.75ZM6 12.75a.75.75 0 0 0 0 1.5h7.5a.75.75 0 0 0 0-1.5H6Zm-.75 3.75a.75.75 0 0 1 .75-.75h7.5a.75.75 0 0 1 0 1.5H6a.75.75 0 0 1-.75-.75ZM6 6.75a.75.75 0 0 0-.75.75v3c0 .414.336.75.75.75h3a.75.75 0 0 0 .75-.75v-3A.75.75 0 0 0 9 6.75H6Z" clip-rule="evenodd"/><path d="M18.75 6.75h1.875c.621 0 1.125.504 1.125 1.125V18a1.5 1.5 0 0 1-3 0V6.75Z"/>""",
  "bell":     """<path fill-rule="evenodd" d="M5.25 9a6.75 6.75 0 0 1 13.5 0v.75c0 2.123.8 4.057 2.118 5.52a.75.75 0 0 1-.297 1.206c-1.544.57-3.16.99-4.831 1.243a3.75 3.75 0 1 1-7.48 0 24.585 24.585 0 0 1-4.831-1.244.75.75 0 0 1-.298-1.205A8.217 8.217 0 0 0 5.25 9.75V9Zm4.502 8.9a2.25 2.25 0 1 0 4.496 0 25.057 25.057 0 0 1-4.496 0Z" clip-rule="evenodd"/>""",
  "cog":      """<path fill-rule="evenodd" d="M11.078 2.25c-.917 0-1.699.663-1.85 1.567L9.05 4.889c-.02.12-.115.26-.297.348a7.493 7.493 0 0 0-.986.57c-.166.115-.334.126-.45.083L6.3 5.508a1.875 1.875 0 0 0-2.282.819l-.922 1.597a1.875 1.875 0 0 0 .432 2.385l.84.692c.095.078.17.229.154.43a7.598 7.598 0 0 0 0 1.139c.015.2-.059.352-.153.43l-.841.692a1.875 1.875 0 0 0-.432 2.385l.922 1.597a1.875 1.875 0 0 0 2.282.818l1.019-.382c.115-.043.283-.031.45.082.312.214.641.405.985.57.182.088.277.228.297.35l.178 1.071c.151.904.933 1.567 1.85 1.567h1.844c.916 0 1.699-.663 1.85-1.567l.178-1.072c.02-.12.114-.26.297-.349.344-.165.673-.356.985-.57.167-.114.335-.125.45-.082l1.02.382a1.875 1.875 0 0 0 2.28-.819l.923-1.597a1.875 1.875 0 0 0-.432-2.385l-.84-.692c-.095-.078-.17-.229-.154-.43a7.614 7.614 0 0 0 0-1.139c-.016-.2.059-.352.153-.43l.84-.692c.708-.582.891-1.59.433-2.385l-.922-1.597a1.875 1.875 0 0 0-2.282-.818l-1.02.382c-.114.043-.282.031-.449-.083a7.49 7.49 0 0 0-.985-.57c-.183-.087-.277-.227-.297-.348l-.179-1.072a1.875 1.875 0 0 0-1.85-1.567h-1.843ZM12 15.75a3.75 3.75 0 1 0 0-7.5 3.75 3.75 0 0 0 0 7.5Z" clip-rule="evenodd"/>""",
  "clipboard":"""<path fill-rule="evenodd" d="M10.5 3A1.501 1.501 0 0 0 9 4.5h6A1.5 1.5 0 0 0 13.5 3h-3Zm-2.693.178A3 3 0 0 1 10.5 1.5h3a3 3 0 0 1 2.694 1.678c.497.042.992.092 1.486.15 1.497.173 2.57 1.46 2.57 2.929V19.5a3 3 0 0 1-3 3H6.75a3 3 0 0 1-3-3V6.257c0-1.47 1.073-2.756 2.57-2.93.493-.057.989-.107 1.487-.15Z" clip-rule="evenodd"/>""",
  "users":    """<path d="M4.5 6.375a4.125 4.125 0 1 1 8.25 0 4.125 4.125 0 0 1-8.25 0ZM14.25 8.625a3.375 3.375 0 1 1 6.75 0 3.375 3.375 0 0 1-6.75 0ZM1.5 19.125a7.125 7.125 0 0 1 14.25 0v.003l-.001.119a.75.75 0 0 1-.363.63 13.067 13.067 0 0 1-6.761 1.873c-2.472 0-4.786-.684-6.76-1.873a.75.75 0 0 1-.364-.63l-.001-.122ZM17.25 19.128l-.001.144a2.25 2.25 0 0 1-.233.96 10.088 10.088 0 0 0 5.06-1.01.75.75 0 0 0 .42-.643 4.875 4.875 0 0 0-6.957-4.611 8.586 8.586 0 0 1 1.71 5.157v.003Z"/>""",
  "eye":      """<path d="M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z"/><path fill-rule="evenodd" d="M1.323 11.447C2.811 6.976 7.028 3.75 12.001 3.75c4.97 0 9.185 3.223 10.675 7.69.12.362.12.752 0 1.113-1.487 4.471-5.705 7.697-10.677 7.697-4.97 0-9.186-3.223-10.675-7.69a1.762 1.762 0 0 1 0-1.113ZM17.25 12a5.25 5.25 0 1 1-10.5 0 5.25 5.25 0 0 1 10.5 0Z" clip-rule="evenodd"/>""",
  "photo":    """<path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.97.97a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd"/>""",
  "speaker":  """<path d="M13.5 4.06c0-1.336-1.616-2.005-2.56-1.06l-4.5 4.5H4.508c-1.141 0-2.318.664-2.66 1.905A9.76 9.76 0 0 0 1.5 12c0 .898.121 1.768.35 2.595.341 1.24 1.518 1.905 2.659 1.905h1.93l4.5 4.5c.945.945 2.561.276 2.561-1.06V4.06ZM18.584 5.106a.75.75 0 0 1 1.06 0c3.808 3.807 3.808 9.98 0 13.788a.75.75 0 0 1-1.06-1.06 8.25 8.25 0 0 0 0-11.668.75.75 0 0 1 0-1.06Z"/><path d="M15.932 7.757a.75.75 0 0 1 1.061 0 6 6 0 0 1 0 8.486.75.75 0 0 1-1.06-1.061 4.5 4.5 0 0 0 0-6.364.75.75 0 0 1 0-1.06Z"/>""",
  "building": """<path fill-rule="evenodd" d="M4.5 2.25a.75.75 0 0 0 0 1.5v16.5h-.75a.75.75 0 0 0 0 1.5h16.5a.75.75 0 0 0 0-1.5h-.75V3.75a.75.75 0 0 0 0-1.5h-15ZM9 6a.75.75 0 0 0 0 1.5h1.5a.75.75 0 0 0 0-1.5H9Zm-.75 3.75A.75.75 0 0 1 9 9h1.5a.75.75 0 0 1 0 1.5H9a.75.75 0 0 1-.75-.75ZM9 12a.75.75 0 0 0 0 1.5h1.5a.75.75 0 0 0 0-1.5H9Zm3.75-5.25A.75.75 0 0 1 13.5 6H15a.75.75 0 0 1 0 1.5h-1.5a.75.75 0 0 1-.75-.75ZM13.5 9a.75.75 0 0 0 0 1.5H15A.75.75 0 0 0 15 9h-1.5Zm-.75 3.75a.75.75 0 0 1 .75-.75H15a.75.75 0 0 1 0 1.5h-1.5a.75.75 0 0 1-.75-.75ZM9 19.5v-2.25a.75.75 0 0 1 .75-.75h4.5a.75.75 0 0 1 .75.75v2.25a.75.75 0 0 1-.75.75h-4.5A.75.75 0 0 1 9 19.5Z" clip-rule="evenodd"/>""",
  "calendar": """<path d="M12.75 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM7.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM8.25 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM9.75 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM10.5 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM12 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM12.75 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM14.25 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 17.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 15.75a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5ZM15 12.75a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM16.5 13.5a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z"/><path fill-rule="evenodd" d="M6.75 2.25A.75.75 0 0 1 7.5 3v1.5h9V3A.75.75 0 0 1 18 3v1.5h.75a3 3 0 0 1 3 3v11.25a3 3 0 0 1-3 3H5.25a3 3 0 0 1-3-3V7.5a3 3 0 0 1 3-3H6V3a.75.75 0 0 1 .75-.75Zm13.5 9a1.5 1.5 0 0 0-1.5-1.5H5.25a1.5 1.5 0 0 0-1.5 1.5v7.5a1.5 1.5 0 0 0 1.5 1.5h13.5a1.5 1.5 0 0 0 1.5-1.5v-7.5Z" clip-rule="evenodd"/>""",
  "lock":     """<path fill-rule="evenodd" d="M12 1.5a5.25 5.25 0 0 0-5.25 5.25v3a3 3 0 0 0-3 3v6.75a3 3 0 0 0 3 3h10.5a3 3 0 0 0 3-3v-6.75a3 3 0 0 0-3-3v-3c0-2.9-2.35-5.25-5.25-5.25Zm3.75 8.25v-3a3.75 3.75 0 1 0-7.5 0v3h7.5Z" clip-rule="evenodd"/>""",
  "logout":   """<path fill-rule="evenodd" d="M7.5 3.75A1.5 1.5 0 0 0 6 5.25v13.5a1.5 1.5 0 0 0 1.5 1.5h6a1.5 1.5 0 0 0 1.5-1.5V15a.75.75 0 0 1 1.5 0v3.75a3 3 0 0 1-3 3h-6a3 3 0 0 1-3-3V5.25a3 3 0 0 1 3-3h6a3 3 0 0 1 3 3V9A.75.75 0 0 1 15 9V5.25a1.5 1.5 0 0 0-1.5-1.5h-6Zm10.72 4.72a.75.75 0 0 1 1.06 0l3 3a.75.75 0 0 1 0 1.06l-3 3a.75.75 0 1 1-1.06-1.06l1.72-1.72H9a.75.75 0 0 1 0-1.5h10.94l-1.72-1.72a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd"/>""",
  "search":   """<path fill-rule="evenodd" d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z" clip-rule="evenodd"/>""",
  "info":     """<path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12Zm8.706-1.442c1.146-.573 2.437.463 2.126 1.706l-.709 2.836.042-.02a.75.75 0 0 1 .67 1.34l-.04.022c-1.147.573-2.438-.463-2.127-1.706l.71-2.836-.042.02a.75.75 0 1 1-.671-1.34l.041-.022ZM12 9a.75.75 0 1 0 0-1.5A.75.75 0 0 0 12 9Z" clip-rule="evenodd"/>""",
  "pencil":   """<path d="M21.731 2.269a2.625 2.625 0 0 0-3.712 0l-1.157 1.157 3.712 3.712 1.157-1.157a2.625 2.625 0 0 0 0-3.712ZM19.513 8.199l-3.712-3.712-12.15 12.15a5.25 5.25 0 0 0-1.32 2.214l-.8 2.685a.75.75 0 0 0 .933.933l2.685-.8a5.25 5.25 0 0 0 2.214-1.32L19.513 8.2Z"/>""",
  "check":    """<path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12Zm13.36-1.814a.75.75 0 1 0-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 0 0-1.06 1.06l2.25 2.25a.75.75 0 0 0 1.14-.094l3.75-5.25Z" clip-rule="evenodd"/>""",
  "sparkle":  """<path fill-rule="evenodd" d="M9 4.5a.75.75 0 0 1 .721.544l.813 2.846a3.75 3.75 0 0 0 2.576 2.576l2.846.813a.75.75 0 0 1 0 1.442l-2.846.813a3.75 3.75 0 0 0-2.576 2.576l-.813 2.846a.75.75 0 0 1-1.442 0l-.813-2.846a3.75 3.75 0 0 0-2.576-2.576l-2.846-.813a.75.75 0 0 1 0-1.442l2.846-.813A3.75 3.75 0 0 0 7.466 7.89l.813-2.846A.75.75 0 0 1 9 4.5ZM18 1.5a.75.75 0 0 1 .728.568l.258 1.036c.236.94.97 1.674 1.91 1.91l1.036.258a.75.75 0 0 1 0 1.456l-1.036.258c-.94.236-1.674.97-1.91 1.91l-.258 1.036a.75.75 0 0 1-1.456 0l-.258-1.036a2.625 2.625 0 0 0-1.91-1.91l-1.036-.258a.75.75 0 0 1 0-1.456l1.036-.258a2.625 2.625 0 0 0 1.91-1.91l.258-1.036A.75.75 0 0 1 18 1.5Z" clip-rule="evenodd"/>""",
  "book":     """<path d="M11.25 4.533A9.707 9.707 0 0 0 6 3a9.735 9.735 0 0 0-3.25.555.75.75 0 0 0-.5.707v14.25a.75.75 0 0 0 1 .707A8.237 8.237 0 0 1 6 18.75c1.995 0 3.823.707 5.25 1.886V4.533ZM12.75 20.636A8.214 8.214 0 0 1 18 18.75c.966 0 1.89.166 2.75.47a.75.75 0 0 0 1-.708V4.262a.75.75 0 0 0-.5-.707A9.735 9.735 0 0 0 18 3a9.707 9.707 0 0 0-5.25 1.533v16.103Z"/>""",
  "academic": """<path d="M11.7 2.805a.75.75 0 0 1 .6 0A60.65 60.65 0 0 1 22.83 8.72a.75.75 0 0 1-.231 1.337 49.948 49.948 0 0 0-9.902 3.912l-.003.002c-.114.06-.227.119-.34.18a.75.75 0 0 1-.707 0A50.88 50.88 0 0 0 7.5 12.173v-.224c0-.131.067-.248.172-.311a54.615 54.615 0 0 1 4.653-2.52.75.75 0 0 0-.65-1.352 56.123 56.123 0 0 0-4.78 2.589 1.858 1.858 0 0 0-.859 1.228 49.803 49.803 0 0 0-4.634-1.527.75.75 0 0 1-.231-1.337A60.653 60.653 0 0 1 11.7 2.805Z"/><path d="M13.06 15.473a48.45 48.45 0 0 1 7.666-3.282c.134 1.414.22 2.843.255 4.284a.75.75 0 0 1-.46.711 47.87 47.87 0 0 1-8.105 2.571.75.75 0 0 1-.832-.536 48.248 48.248 0 0 1-1.168-2.554c.053-.081.108-.162.164-.243.338-.485.688-.982 1.082-1.407.367-.396.781-.745 1.398-.941Z"/><path d="M3.787 15.197a48.374 48.374 0 0 1 6.052 1.82c-.12.483-.233.967-.338 1.452a.75.75 0 0 1-.832.536A48.24 48.24 0 0 1 3 16.72a.75.75 0 0 1-.461-.71c.035-1.441.121-2.87.255-4.284.37.126.737.258 1.101.395a48.375 48.375 0 0 1-.108 3.076Z"/>""",
}

def I(name, cls="icon", color=""):
    s = f' style="color:{color}"' if color else ""
    return f'<svg class="{cls}"{s} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">{P[name]}</svg>'

SOCIAL_BLOCK = """          <div class="footer-social">
            <a href="#" class="social-btn" aria-label="Instagram"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg></a>
            <a href="#" class="social-btn" aria-label="Facebook"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg></a>
            <a href="#" class="social-btn" aria-label="YouTube"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/></svg></a>
            <a href="#" class="social-btn" aria-label="WhatsApp"><svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413Z"/></svg></a>
          </div>"""

def transform(html, is_admin=False):
    asset = "../assets" if is_admin else "assets"
    
    # 1. Replace brand-logo div (with or without inline styles)
    html = re.sub(
        r'<div class="brand-logo"(?:[^>]*)>.*?</div>',
        f'<img src="{asset}/logo.png" class="brand-logo-img" alt="Logo Darul Furqan" />',
        html, flags=re.DOTALL
    )
    
    # 2. Replace news-img-placeholder divs
    html = re.sub(
        r'<div class="news-img-placeholder">[^<]*</div>',
        f'<img src="{asset}/blank.png" class="news-img-placeholder" alt="Foto Berita" />',
        html
    )
    
    # 3. Replace galeri-placeholder divs
    html = re.sub(
        r'<div class="galeri-placeholder">[^<]*</div>',
        f'<img src="{asset}/blank.png" class="galeri-placeholder" alt="Foto Galeri" />',
        html
    )
    
    # 4. Replace galeri-card-placeholder divs
    html = re.sub(
        r'<div class="galeri-card-placeholder">[^<]*</div>',
        f'<img src="{asset}/blank.png" class="galeri-card-placeholder" alt="Foto Galeri" />',
        html
    )
    
    # 5. Social media emoji buttons
    html = html.replace('<a href="#" class="social-btn" aria-label="Instagram">📸</a>', '')
    html = html.replace('<a href="#" class="social-btn" aria-label="Facebook">👤</a>', '')
    html = html.replace('<a href="#" class="social-btn" aria-label="YouTube">▶️</a>', '')
    html = html.replace('<a href="#" class="social-btn" aria-label="WhatsApp">💬</a>', '')
    html = html.replace(
        '<div class="footer-social">',
        SOCIAL_BLOCK.replace('          <div class="footer-social">', '          <div class="footer-social-REPLACED">').replace('          <div class="footer-social-REPLACED">', '<div class="footer-social-SKIP">') + '\n          <div class="footer-social" style="display:none">'
    )
    # simpler approach: replace the whole social block pattern
    html = re.sub(
        r'<div class="footer-social">\s*<a[^>]*>📸</a>\s*<a[^>]*>👤</a>\s*<a[^>]*>▶️</a>\s*<a[^>]*>💬</a>\s*</div>',
        SOCIAL_BLOCK,
        html, flags=re.DOTALL
    )
    
    # 6. Footer contact icons (span)
    html = re.sub(r'<span class="contact-icon">📍</span>', I("map","contact-icon"), html)
    html = re.sub(r'<span class="contact-icon">📞</span>', I("phone","contact-icon"), html)
    html = re.sub(r'<span class="contact-icon">✉️</span>', I("mail","contact-icon"), html)
    
    # 7. Kontak info icons
    html = re.sub(r'<div class="kontak-info-icon">📍</div>', f'<div class="kontak-info-icon">{I("map","icon-md")}</div>', html)
    html = re.sub(r'<div class="kontak-info-icon">📞</div>', f'<div class="kontak-info-icon">{I("phone","icon-md")}</div>', html)
    html = re.sub(r'<div class="kontak-info-icon">💬</div>', f'<div class="kontak-info-icon">{I("chat","icon-md")}</div>', html)
    html = re.sub(r'<div class="kontak-info-icon">✉️</div>', f'<div class="kontak-info-icon">{I("mail","icon-md")}</div>', html)
    html = re.sub(r'<div class="kontak-info-icon">🕐</div>', f'<div class="kontak-info-icon">{I("clock","icon-md")}</div>', html)
    
    # 8. Tab buttons - remove emoji prefixes
    tab_emoji = ['📝 ', '🔍 ', 'ℹ️ ', '📣 ', '📰 ', '🎯 ', '📝 ', '📚 ', '🏫 ', '⚽ ', '🎨 ', '🌿 ', '📖 ', '🏕️ ']
    for e in tab_emoji:
        html = html.replace(f'>{e}', '>')
    
    # 9. Program icons
    html = html.replace('<div class="program-icon">🌱</div>', f'<div class="program-icon">{I("academic","icon-xl")}</div>')
    html = html.replace('<div class="program-icon">📚</div>', f'<div class="program-icon">{I("book","icon-xl")}</div>')
    html = html.replace('<div class="program-icon">🕌</div>', f'<div class="program-icon">{I("building","icon-xl")}</div>')
    
    # 10. Achievement icons
    html = html.replace('<div class="achievement-icon">🥇</div>', f'<div class="achievement-icon">{I("trophy","icon-lg","#f59e0b")}</div>')
    html = html.replace('<div class="achievement-icon">🥈</div>', f'<div class="achievement-icon">{I("trophy","icon-lg","#94a3b8")}</div>')
    html = html.replace('<div class="achievement-icon">🤖</div>', f'<div class="achievement-icon">{I("star","icon-lg","#10b981")}</div>')
    html = html.replace('<div class="achievement-icon">🎨</div>', f'<div class="achievement-icon">{I("star","icon-lg","#f59e0b")}</div>')
    
    # 11. Prestasi medals
    html = html.replace('<div class="prestasi-medal">🥇</div>', f'<div class="prestasi-medal" style="background:rgba(245,158,11,.15)">{I("trophy","icon-md","#f59e0b")}</div>')
    html = html.replace('<div class="prestasi-medal">🥈</div>', f'<div class="prestasi-medal" style="background:rgba(148,163,184,.15)">{I("trophy","icon-md","#94a3b8")}</div>')
    html = html.replace('<div class="prestasi-medal">🥉</div>', f'<div class="prestasi-medal" style="background:rgba(180,120,60,.15)">{I("trophy","icon-md","#b47c3c")}</div>')
    html = html.replace('<div class="prestasi-medal">🏅</div>', f'<div class="prestasi-medal" style="background:rgba(16,185,129,.15)">{I("star","icon-md","#10b981")}</div>')
    
    # 12. Stat card icons (prestasi page)
    html = re.sub(r'<div class="stat-card-icon icon-green">🏆</div>', f'<div class="stat-card-icon icon-green">{I("trophy","icon-lg")}</div>', html)
    html = re.sub(r'<div class="stat-card-icon icon-blue">🥇</div>', f'<div class="stat-card-icon icon-blue">{I("star","icon-lg")}</div>', html)
    html = re.sub(r'<div class="stat-card-icon icon-yellow">⭐</div>', f'<div class="stat-card-icon icon-yellow">{I("star","icon-lg")}</div>', html)
    html = re.sub(r'<div class="stat-card-icon icon-red">🌟</div>', f'<div class="stat-card-icon icon-red">{I("sparkle","icon-lg")}</div>', html)
    # Dashboard stat cards
    html = re.sub(r'<div class="stat-card-icon icon-green">📝</div>', f'<div class="stat-card-icon icon-green">{I("clipboard","icon-lg")}</div>', html)
    html = re.sub(r'<div class="stat-card-icon icon-blue">📰</div>', f'<div class="stat-card-icon icon-blue">{I("news","icon-lg")}</div>', html)
    html = re.sub(r'<div class="stat-card-icon icon-yellow">✉️</div>', f'<div class="stat-card-icon icon-yellow">{I("mail","icon-lg")}</div>', html)
    html = re.sub(r'<div class="stat-card-icon icon-red">👁️</div>', f'<div class="stat-card-icon icon-red">{I("eye","icon-lg")}</div>', html)
    
    # 13. Sidebar icons (admin dashboard)
    html = html.replace('<span class="sidebar-icon">📊</span>', f'<span class="sidebar-icon">{I("chart","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">📰</span>', f'<span class="sidebar-icon">{I("news","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">📣</span>', f'<span class="sidebar-icon">{I("speaker","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">🖼️</span>', f'<span class="sidebar-icon">{I("photo","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">🏆</span>', f'<span class="sidebar-icon">{I("trophy","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">👨‍🏫</span>', f'<span class="sidebar-icon">{I("user","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">📋</span>', f'<span class="sidebar-icon">{I("clipboard","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">👥</span>', f'<span class="sidebar-icon">{I("users","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">✉️</span>', f'<span class="sidebar-icon">{I("mail","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">⚙️</span>', f'<span class="sidebar-icon">{I("cog","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">👤</span>', f'<span class="sidebar-icon">{I("user","icon")}</span>')
    html = html.replace('<span class="sidebar-icon">🚪</span>', f'<span class="sidebar-icon">{I("logout","icon")}</span>')
    
    # 14. Topbar elements (admin)
    html = html.replace('>☰<', f'>{I("search","icon")}<')  # sidebar toggle was ☰ - use bars icon
    html = re.sub(r'<button [^>]*id="sidebarToggle"[^>]*>☰</button>',
                  f'<button id="sidebarToggle" style="background:none;border:none;cursor:pointer;display:none;color:var(--text-main);">{I("search","icon-md")}</button>',
                  html)
    html = re.sub(r'🔔\s*<div class="notif-dot">', f'{I("bell","icon-md")} <div class="notif-dot">', html)
    
    # 15. Admin login icons
    html = html.replace('<span class="login-input-icon">✉️</span>', f'<span class="login-input-icon">{I("mail","icon")}</span>')
    html = html.replace('<span class="login-input-icon">🔒</span>', f'<span class="login-input-icon">{I("lock","icon")}</span>')
    
    # 16. Visi/Misi icons in profil
    html = html.replace('<div style="font-size:2rem;margin-bottom:.75rem;">🎯</div>', f'<div style="width:48px;height:48px;background:rgba(5,150,105,.1);border-radius:10px;display:flex;align-items:center;justify-content:center;color:var(--primary);margin-bottom:.75rem;">{I("sparkle","icon-xl")}</div>')
    html = html.replace('<div style="font-size:2rem;margin-bottom:.75rem;">🚀</div>', f'<div style="width:48px;height:48px;background:rgba(5,150,105,.1);border-radius:10px;display:flex;align-items:center;justify-content:center;color:var(--primary);margin-bottom:.75rem;">{I("star","icon-xl")}</div>')
    
    # 17. Nilai-nilai icons in profil
    html = html.replace('<div style="font-size:2rem;margin-bottom:.5rem;">🕌</div>', f'<div style="margin-bottom:.5rem;color:var(--primary-dark)">{I("building","icon-xl")}</div>')
    html = html.replace('<div style="font-size:2rem;margin-bottom:.5rem;">🌿</div>', f'<div style="margin-bottom:.5rem;color:var(--primary)">{I("sparkle","icon-xl")}</div>')
    html = html.replace('<div style="font-size:2rem;margin-bottom:.5rem;">⭐</div>', f'<div style="margin-bottom:.5rem;color:#f59e0b">{I("star","icon-xl")}</div>')
    html = html.replace('<div style="font-size:2rem;margin-bottom:.5rem;">🤝</div>', f'<div style="margin-bottom:.5rem;color:var(--primary)">{I("users","icon-xl")}</div>')
    html = html.replace('<div style="font-size:2rem;margin-bottom:.5rem;">💡</div>', f'<div style="margin-bottom:.5rem;color:#d97706">{I("sparkle","icon-xl")}</div>')
    
    # 18. Teacher avatars in profil - replace emoji with user icon
    html = re.sub(r'<div style="[^"]*font-size:1\.75rem[^"]*">👨‍🏫</div>', f'<div style="display:flex;align-items:center;justify-content:center;">{I("user","icon-2xl")}</div>', html)
    html = re.sub(r'<div style="[^"]*font-size:1\.75rem[^"]*">👩‍🏫</div>', f'<div style="display:flex;align-items:center;justify-content:center;">{I("user","icon-2xl")}</div>', html)
    
    # 19. Pesan Terbaru user icons in dashboard
    html = re.sub(r'<div style="[^"]*font-size:1rem[^"]*">👤</div>', f'<div style="display:flex;align-items:center;justify-content:center;">{I("user","icon")}</div>', html)
    
    # 20. Info PPDB section header icons
    html = html.replace('<div style="font-size:1.75rem;margin-bottom:.75rem;">📅</div>', f'<div style="margin-bottom:.75rem;color:var(--primary)">{I("calendar","icon-xl")}</div>')
    html = html.replace('<div style="font-size:1.75rem;margin-bottom:.75rem;">📋</div>', f'<div style="margin-bottom:.75rem;color:var(--primary)">{I("clipboard","icon-xl")}</div>')
    html = html.replace('<div style="font-size:1.75rem;margin-bottom:.75rem;">🏫</div>', f'<div style="margin-bottom:.75rem;color:var(--primary)">{I("building","icon-xl")}</div>')
    
    # 21. PPDB badge / page hero badge - remove emoji
    html = html.replace('🎉 PPDB 2025/2026 DIBUKA!', 'PPDB 2025/2026 DIBUKA!')
    html = html.replace('🎉 ', '')
    
    # 22. Hero badge icon
    html = re.sub(r'<div class="hero-badge">\s*🌿\s*', f'<div class="hero-badge">{I("academic","icon")} ', html)
    
    # 23. Deadline clock
    html = html.replace('<span>⏰ Batas Pendaftaran: 30 Juni 2025</span>',
                        f'<span style="display:flex;align-items:center;gap:.4rem;">{I("clock","icon")} Batas Pendaftaran: 30 Juni 2025</span>')
    html = re.sub(r'<div class="ppdb-deadline">\s*<span>⏰',
                  f'<div class="ppdb-deadline" style="display:flex;align-items:center;gap:.5rem;">{I("clock","icon")} <span>', html)
    
    # 24. Button emoji cleanup
    html = html.replace('Daftar Sekarang 🚀', 'Daftar Sekarang')
    html = html.replace('🚀 Kirim Pendaftaran', 'Kirim Pendaftaran')
    html = html.replace('📨 Kirim Pesan', 'Kirim Pesan')
    
    # 25. Form section headers - remove emoji
    html = html.replace('📋 Data Calon Siswa', 'Data Calon Siswa')
    html = html.replace('👨‍👩‍👧 Data Orang Tua / Wali', 'Data Orang Tua / Wali')
    html = html.replace('📂 Unggah Dokumen', 'Unggah Dokumen')
    html = html.replace('✅ Konfirmasi Pendaftaran', 'Konfirmasi Pendaftaran')
    
    # 26. Table headers emoji
    html = html.replace('📋 Rekap PPDB 2025/2026', 'Rekap PPDB 2025/2026')
    html = html.replace('✉️ Pesan Terbaru', 'Pesan Terbaru')
    html = html.replace('👥 Pendaftar PPDB Terbaru', 'Pendaftar PPDB Terbaru')
    html = html.replace('Selamat datang, Admin! 👋', 'Selamat datang, Admin!')
    
    # 27. Maps embed
    html = html.replace('📍 Google Maps — Yayasan Darul Furqan Pariaman', 'Google Maps — Yayasan Darul Furqan Pariaman')
    
    return html

# ── Process each file ──────────────────────────────────────────────────────────
files = {
    os.path.join(BASE, "index.html"): False,
    os.path.join(BASE, "profil.html"): False,
    os.path.join(BASE, "ppdb.html"): False,
    os.path.join(BASE, "berita.html"): False,
    os.path.join(BASE, "galeri.html"): False,
    os.path.join(BASE, "prestasi.html"): False,
    os.path.join(BASE, "kontak.html"): False,
    os.path.join(BASE, "admin", "login.html"): True,
    os.path.join(BASE, "admin", "dashboard.html"): True,
}

for path, is_admin in files.items():
    with open(path, encoding="utf-8") as f:
        html = f.read()
    original_len = len(html)
    html = transform(html, is_admin)
    with open(path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"✓ {os.path.basename(path)} ({original_len} → {len(html)} chars)")

print("\nAll files transformed successfully!")

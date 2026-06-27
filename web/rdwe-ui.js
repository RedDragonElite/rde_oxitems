/* ================================================================
   RDWE-UI.js  ·  Red Dragon Web Engine · UI Framework JS
   Version  : 1.0.0
   Author   : .:: RedDragonElite ::.
   Zero-dependency. Pure vanilla JS.
================================================================ */

'use strict';

const RDWE = (() => {

  /* ══════════════════════════════════════════════════
     TABS
  ══════════════════════════════════════════════════ */
  function initTabs() {
    document.querySelectorAll('[data-rdwe-tabs]').forEach(container => {
      const buttons = container.querySelectorAll('.tab-btn');
      const panes   = container.querySelectorAll('.tab-pane');
      buttons.forEach(btn => {
        btn.addEventListener('click', () => {
          buttons.forEach(b => b.classList.remove('active'));
          panes.forEach(p => p.classList.remove('active'));
          btn.classList.add('active');
          const target = document.getElementById(btn.dataset.tab);
          if (target) target.classList.add('active');
        });
      });
    });
  }

  /* ══════════════════════════════════════════════════
     MODALS
  ══════════════════════════════════════════════════ */
  function openModal(id) {
    const backdrop = document.getElementById(id);
    if (!backdrop) return;
    backdrop.classList.add('open');
    document.body.style.overflow = 'hidden';
    backdrop.addEventListener('click', e => {
      if (e.target === backdrop) closeModal(id);
    });
    document.addEventListener('keydown', function escHandler(e) {
      if (e.key === 'Escape') { closeModal(id); document.removeEventListener('keydown', escHandler); }
    });
  }

  function closeModal(id) {
    const backdrop = document.getElementById(id);
    if (!backdrop) return;
    backdrop.classList.remove('open');
    document.body.style.overflow = '';
  }

  function initModals() {
    document.querySelectorAll('[data-modal-open]').forEach(btn => {
      btn.addEventListener('click', () => openModal(btn.dataset.modalOpen));
    });
    document.querySelectorAll('[data-modal-close]').forEach(btn => {
      btn.addEventListener('click', () => closeModal(btn.dataset.modalClose));
    });
  }

  /* ══════════════════════════════════════════════════
     TOASTS
  ══════════════════════════════════════════════════ */
  let toastContainer = null;

  function getToastContainer() {
    if (!toastContainer) {
      toastContainer = document.querySelector('.toast-container');
      if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container';
        document.body.appendChild(toastContainer);
      }
    }
    return toastContainer;
  }

  /**
   * Show a toast notification.
   * @param {Object} opts - { type: 'success'|'error'|'info'|'warn', title, message, duration }
   */
  function toast(opts = {}) {
    const { type = 'info', title = '', message = '', duration = 4000 } = opts;

    const icons = {
      success: '✓',
      error:   '✗',
      info:    'ℹ',
      warn:    '⚠'
    };

    const el = document.createElement('div');
    el.className = `toast toast-${type}`;
    el.innerHTML = `
      <span class="toast-icon">${icons[type] || 'ℹ'}</span>
      <div class="toast-body">
        ${title ? `<div class="toast-title">${title}</div>` : ''}
        ${message ? `<div class="toast-msg">${message}</div>` : ''}
      </div>
      <button class="toast-close" aria-label="Close">×</button>
      <div class="toast-progress" style="width:100%;transition:width ${duration}ms linear;"></div>
    `;

    const container = getToastContainer();
    container.appendChild(el);

    // animate progress bar
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        const bar = el.querySelector('.toast-progress');
        if (bar) bar.style.width = '0%';
      });
    });

    // close button
    el.querySelector('.toast-close').addEventListener('click', () => removeToast(el));

    // auto remove
    const timer = setTimeout(() => removeToast(el), duration);
    el._rdweTimer = timer;

    return el;
  }

  function removeToast(el) {
    clearTimeout(el._rdweTimer);
    el.classList.add('removing');
    setTimeout(() => { if (el.parentNode) el.parentNode.removeChild(el); }, 320);
  }

  // Shorthand methods
  toast.success = (title, message, duration) => toast({ type:'success', title, message, duration });
  toast.error   = (title, message, duration) => toast({ type:'error',   title, message, duration });
  toast.info    = (title, message, duration) => toast({ type:'info',    title, message, duration });
  toast.warn    = (title, message, duration) => toast({ type:'warn',    title, message, duration });

  /* ══════════════════════════════════════════════════
     DROPDOWNS
  ══════════════════════════════════════════════════ */
  function initDropdowns() {
    document.querySelectorAll('[data-dropdown-toggle]').forEach(btn => {
      btn.addEventListener('click', e => {
        e.stopPropagation();
        const menuId = btn.dataset.dropdownToggle;
        const menu   = document.getElementById(menuId);
        if (!menu) return;
        const isOpen = menu.classList.contains('open');
        // Close all
        document.querySelectorAll('.dropdown-menu.open').forEach(m => m.classList.remove('open'));
        if (!isOpen) menu.classList.add('open');
      });
    });

    document.addEventListener('click', () => {
      document.querySelectorAll('.dropdown-menu.open').forEach(m => m.classList.remove('open'));
    });
  }

  /* ══════════════════════════════════════════════════
     ALERTS (dismissible)
  ══════════════════════════════════════════════════ */
  function initAlerts() {
    document.querySelectorAll('.alert-close').forEach(btn => {
      btn.addEventListener('click', () => {
        const alert = btn.closest('.alert');
        if (alert) {
          alert.style.opacity = '0';
          alert.style.transition = 'opacity .2s';
          setTimeout(() => alert.remove(), 220);
        }
      });
    });
  }

  /* ══════════════════════════════════════════════════
     CHECKLISTS
  ══════════════════════════════════════════════════ */
  function toggleCheck(item) {
    item.classList.toggle('checked');
    const box = item.querySelector('.check-box');
    if (item.classList.contains('checked')) {
      box.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
    } else {
      box.innerHTML = '';
    }
    updateChecklistProgress(item.closest('.checklist'));
  }

  function updateChecklistProgress(list) {
    if (!list) return;
    const items   = list.querySelectorAll('.check-item');
    const checked = list.querySelectorAll('.check-item.checked').length;
    const pct     = items.length ? Math.round((checked / items.length) * 100) : 0;
    const fill    = list.querySelector('.check-bar-fill');
    const label   = list.querySelector('.check-bar-fill + span, #check-pct, .check-pct');
    if (fill) {
      fill.style.width = pct + '%';
      fill.style.background = pct === 100 ? 'var(--green)' : (pct > 60 ? 'var(--orange)' : 'var(--red)');
    }
    if (label) label.textContent = checked + ' / ' + items.length;
    // look for data-check-pct span
    const pctEl = list.querySelector('[data-check-pct]');
    if (pctEl) pctEl.textContent = checked + ' / ' + items.length;
  }

  function initChecklists() {
    document.querySelectorAll('.check-item').forEach(item => {
      item.addEventListener('click', () => toggleCheck(item));
    });
    document.querySelectorAll('.checklist').forEach(list => {
      updateChecklistProgress(list);
    });
  }

  /* ══════════════════════════════════════════════════
     SIDEBAR — scroll tracking & mobile toggle
  ══════════════════════════════════════════════════ */
  function initSidebar() {
    // Active link scroll tracking
    const sections = document.querySelectorAll('[id].section, section[id], [data-section]');
    const sbLinks  = document.querySelectorAll('.sb-item[href^="#"]');

    if (sections.length && sbLinks.length) {
      const observer = new IntersectionObserver(entries => {
        entries.forEach(e => {
          if (e.isIntersecting) {
            const id = e.target.id;
            sbLinks.forEach(l => {
              l.classList.toggle('active', l.getAttribute('href') === '#' + id);
            });
          }
        });
      }, { rootMargin: '-20% 0px -70% 0px', threshold: 0 });
      sections.forEach(s => observer.observe(s));
    }

    // Read progress bar
    const fill  = document.getElementById('prog-fill');
    const pctEl = document.getElementById('prog-pct');
    if (fill || pctEl) {
      window.addEventListener('scroll', () => {
        const pct = Math.round((window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100);
        if (fill)  fill.style.width  = pct + '%';
        if (pctEl) pctEl.textContent = pct + '%';
      }, { passive: true });
    }

    // Mobile sidebar toggle
    const toggle  = document.querySelector('.sidebar-toggle');
    const sidebar = document.querySelector('.rdwe-sidebar');
    if (toggle && sidebar) {
      let overlay = document.querySelector('.sidebar-overlay');
      if (!overlay) {
        overlay = document.createElement('div');
        overlay.className = 'sidebar-overlay';
        document.body.appendChild(overlay);
      }
      toggle.addEventListener('click', () => {
        sidebar.classList.toggle('mobile-open');
        overlay.classList.toggle('active');
      });
      overlay.addEventListener('click', () => {
        sidebar.classList.remove('mobile-open');
        overlay.classList.remove('active');
      });
    }
  }

  /* ══════════════════════════════════════════════════
     COPY CODE BUTTON
  ══════════════════════════════════════════════════ */
  function copyCode(btn) {
    const pre  = btn.closest('.code-wrap').querySelector('pre');
    const text = pre.innerText;
    navigator.clipboard.writeText(text).then(() => {
      btn.classList.add('copied');
      const prev = btn.innerHTML;
      btn.textContent = '✓ COPIED';
      setTimeout(() => {
        btn.classList.remove('copied');
        btn.innerHTML = prev;
        // Reinitialize lucide if available
        if (window.lucide) window.lucide.createIcons();
      }, 2000);
    });
  }

  /* ══════════════════════════════════════════════════
     PROGRESS BARS (animated on scroll)
  ══════════════════════════════════════════════════ */
  function initProgressBars() {
    const bars = document.querySelectorAll('[data-progress]');
    if (!bars.length) return;
    const observer = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          const fill = e.target.querySelector('.progress-fill');
          const val  = e.target.dataset.progress || '0';
          if (fill) {
            fill.style.width = '0%';
            requestAnimationFrame(() => {
              requestAnimationFrame(() => { fill.style.width = val + '%'; });
            });
          }
          observer.unobserve(e.target);
        }
      });
    }, { threshold:.2 });
    bars.forEach(b => observer.observe(b));
  }

  /* ══════════════════════════════════════════════════
     COUNTERS (animated number count-up)
  ══════════════════════════════════════════════════ */
  function animateCounter(el, target, duration = 1200) {
    const start = performance.now();
    const from  = 0;
    const easeOut = t => 1 - Math.pow(1 - t, 3);
    const isFloat = String(target).includes('.');
    const decimals= isFloat ? String(target).split('.')[1].length : 0;

    function tick(now) {
      const elapsed = now - start;
      const progress = Math.min(elapsed / duration, 1);
      const val = from + (target - from) * easeOut(progress);
      el.textContent = isFloat ? val.toFixed(decimals) : Math.floor(val).toLocaleString();
      if (progress < 1) requestAnimationFrame(tick);
      else el.textContent = isFloat ? target.toFixed(decimals) : Number(target).toLocaleString();
    }
    requestAnimationFrame(tick);
  }

  function initCounters() {
    const counters = document.querySelectorAll('[data-count]');
    if (!counters.length) return;
    const observer = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          animateCounter(e.target, parseFloat(e.target.dataset.count));
          observer.unobserve(e.target);
        }
      });
    }, { threshold:.5 });
    counters.forEach(c => observer.observe(c));
  }

  /* ══════════════════════════════════════════════════
     STEP BAR
  ══════════════════════════════════════════════════ */
  function setStep(containerId, step) {
    const bar = document.getElementById(containerId);
    if (!bar) return;
    const items = bar.querySelectorAll('.step-bar-item');
    items.forEach((item, i) => {
      item.classList.remove('active', 'done');
      if (i < step - 1)  item.classList.add('done');
      if (i === step - 1) item.classList.add('active');
    });
  }

  /* ══════════════════════════════════════════════════
     TOOLTIP (JS fallback for long tooltips)
  ══════════════════════════════════════════════════ */
  function initTooltips() {
    // CSS handles most tooltips via [data-tooltip]
    // This handles dynamic tooltips via JS API
  }

  /* ══════════════════════════════════════════════════
     TABS (switchTab global helper - backward compat)
  ══════════════════════════════════════════════════ */
  function switchTab(btn, id) {
    const sectionEl = btn.closest('[data-rdwe-tabs]') || btn.closest('.section') || btn.closest('.card') || btn.parentElement.parentElement;
    btn.closest('.tabs').querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    sectionEl.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    const target = document.getElementById('tab-' + id);
    if (target) target.classList.add('active');
  }

  /* ══════════════════════════════════════════════════
     INIT — called on DOMContentLoaded
  ══════════════════════════════════════════════════ */
  function init() {
    initTabs();
    initModals();
    initDropdowns();
    initAlerts();
    initChecklists();
    initSidebar();
    initProgressBars();
    initCounters();
    if (window.lucide) window.lucide.createIcons();
  }

  /* ══════════════════════════════════════════════════
     BOOT
  ══════════════════════════════════════════════════ */
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  /* ── Public API ── */
  return {
    init,
    toast,
    openModal,
    closeModal,
    copyCode,
    switchTab,
    toggleCheck,
    setStep,
    animateCounter,
  };

})();

/* Expose globally */
window.RDWE = RDWE;

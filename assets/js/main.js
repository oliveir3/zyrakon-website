/* ============================================================================
   ZYRAKON JAVASCRIPT CORE
   The Foundation of Intelligent Technology
   Version: 1.0.0
   ============================================================================ */

// ──────────────────────────────────────────────────────────────────────────
// Navigation Scroll Effect
// ──────────────────────────────────────────────────────────────────────────

function initNavScroll() {
  const nav = document.querySelector('.nav');
  if (!nav) return;
  
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      nav.classList.add('scrolled');
    } else {
      nav.classList.remove('scrolled');
    }
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Mobile Navigation
// ──────────────────────────────────────────────────────────────────────────

function initMobileNav() {
  const toggle = document.querySelector('.nav-toggle');
  const links = document.querySelector('.nav-links');
  
  if (!toggle || !links) return;

  // Create overlay element
  const overlay = document.createElement('div');
  overlay.className = 'nav-overlay';
  overlay.setAttribute('aria-hidden', 'true');
  document.body.appendChild(overlay);

  function openMenu() {
    links.classList.add('active');
    overlay.classList.add('active');
    toggle.classList.add('active');
    toggle.setAttribute('aria-expanded', 'true');
    overlay.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
    toggle.setAttribute('aria-label', 'Close navigation menu');
  }

  function closeMenu() {
    links.classList.remove('active');
    overlay.classList.remove('active');
    toggle.classList.remove('active');
    toggle.setAttribute('aria-expanded', 'false');
    overlay.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    toggle.setAttribute('aria-label', 'Open navigation menu');
  }

  toggle.addEventListener('click', () => {
    if (links.classList.contains('active')) {
      closeMenu();
    } else {
      openMenu();
    }
  });

  // Close on overlay click
  overlay.addEventListener('click', closeMenu);

  // Close when clicking a nav link (mobile only)
  links.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', () => {
      if (window.innerWidth <= 768) {
        closeMenu();
      }
    });
  });

  // Close on Escape key
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && links.classList.contains('active')) {
      closeMenu();
      toggle.focus();
    }
  });

  // Close menu if window resizes to desktop
  window.addEventListener('resize', () => {
    if (window.innerWidth > 768 && links.classList.contains('active')) {
      closeMenu();
    }
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Smooth Scroll for Anchor Links
// ──────────────────────────────────────────────────────────────────────────

function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      const targetId = this.getAttribute('href');
      if (targetId === '#') return;
      
      const target = document.querySelector(targetId);
      if (target) {
        e.preventDefault();
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Scroll Animations (Intersection Observer)
// ──────────────────────────────────────────────────────────────────────────

function initScrollAnimations() {
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate-fade-in-up');
        observer.unobserve(entry.target);
      }
    });
  }, observerOptions);
  
  document.querySelectorAll('[data-animate]').forEach(el => {
    observer.observe(el);
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Active Navigation Link
// ──────────────────────────────────────────────────────────────────────────

function initActiveNavLink() {
  const currentPath = window.location.pathname;
  const navLinks = document.querySelectorAll('.nav-link');
  
  navLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (!href) return;
    
    const cleanPath = currentPath.replace(/\/+$/, '') || '/';
    const cleanHref = href.replace(/\/+$/, '');
    
    if (cleanHref === cleanPath) {
      link.classList.add('active');
    } else if (cleanHref !== '/' && cleanPath.startsWith(cleanHref)) {
      link.classList.add('active');
    }
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Footer Year
// ──────────────────────────────────────────────────────────────────────────

function initFooterYear() {
  const yearEl = document.querySelector('[data-current-year]');
  if (yearEl) {
    yearEl.textContent = new Date().getFullYear();
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Touch Device Detection
// ──────────────────────────────────────────────────────────────────────────

function isTouchDevice() {
  return ('ontouchstart' in window) || 
         (navigator.maxTouchPoints > 0) || 
         (navigator.msMaxTouchPoints > 0);
}

function initTouchOptimizations() {
  if (isTouchDevice()) {
    document.body.classList.add('touch-device');
    
    document.querySelectorAll('.card, .btn, .nav-link').forEach(el => {
      el.addEventListener('touchstart', function() {
        this.classList.add('touch-active');
      }, { passive: true });
      el.addEventListener('touchend', function() {
        this.classList.remove('touch-active');
      }, { passive: true });
    });
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Responsive Image Fallback
// ──────────────────────────────────────────────────────────────────────────

function initResponsiveImages() {
  const logoImg = document.querySelector('.nav-logo img');
  if (logoImg) {
    logoImg.addEventListener('error', function() {
      const fallback = this.nextElementSibling;
      if (fallback && fallback.tagName === 'SPAN') {
        this.style.display = 'none';
        fallback.style.display = 'inline';
      }
    });
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Initialize Everything
// ──────────────────────────────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
  initNavScroll();
  initMobileNav();
  initSmoothScroll();
  initScrollAnimations();
  initActiveNavLink();
  initFooterYear();
  initTouchOptimizations();
  initResponsiveImages();
  
  console.log(
    '%c Zyrakon %c The Foundation of Intelligent Technology %c v1.0',
    'color: #FF6B2B; font-size: 20px; font-weight: bold;',
    'color: #94A3B8; font-size: 12px;',
    'color: #475569; font-size: 10px;'
  );
  
  if (isTouchDevice()) {
    console.log('%c Touch device detected - mobile optimizations active', 'color: #FF8C42;');
  }
  if (window.innerWidth <= 768) {
    console.log('%c Mobile viewport (' + window.innerWidth + 'px)', 'color: #FF8C42;');
  }
});

// ──────────────────────────────────────────────────────────────────────────
// Enhanced Scroll Animations
// ──────────────────────────────────────────────────────────────────────────

function initScrollAnimations() {
  const observerOptions = {
    threshold: 0.15,
    rootMargin: '0px 0px -60px 0px'
  };
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el = entry.target;
        
        // Add appropriate animation class
        const animationType = el.getAttribute('data-animate');
        
        if (animationType === 'fade-left') {
          el.classList.add('animate-fade-in-left');
        } else if (animationType === 'fade-right') {
          el.classList.add('animate-fade-in-right');
        } else if (animationType === 'scale') {
          el.classList.add('animate-scale-in');
        } else if (animationType === 'bounce') {
          el.classList.add('animate-bounce-in');
        } else {
          el.classList.add('animate-fade-in-up');
        }
        
        // Handle stagger children
        if (el.classList.contains('stagger-children')) {
          const children = el.children;
          let delay = 0;
          Array.from(children).forEach((child, index) => {
            setTimeout(() => {
              child.classList.add('visible');
            }, index * 100);
          });
        }
        
        observer.unobserve(el);
      }
    });
  }, observerOptions);
  
  document.querySelectorAll('[data-animate]').forEach(el => {
    observer.observe(el);
  });
  
  // Also observe stagger containers
  document.querySelectorAll('.stagger-children').forEach(el => {
    observer.observe(el);
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Counter Animation
// ──────────────────────────────────────────────────────────────────────────

function initCounters() {
  const counters = document.querySelectorAll('[data-counter]');
  
  const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const counter = entry.target;
        const target = parseInt(counter.getAttribute('data-counter'));
        const duration = parseInt(counter.getAttribute('data-duration') || '2000');
        const startValue = 0;
        const startTime = performance.now();
        
        function updateCounter(currentTime) {
          const elapsed = currentTime - startTime;
          const progress = Math.min(elapsed / duration, 1);
          
          // Ease out cubic
          const eased = 1 - Math.pow(1 - progress, 3);
          const current = Math.round(startValue + (target - startValue) * eased);
          
          counter.textContent = current.toLocaleString();
          
          if (progress < 1) {
            requestAnimationFrame(updateCounter);
          } else {
            counter.textContent = target.toLocaleString();
            counter.classList.add('animating');
          }
        }
        
        requestAnimationFrame(updateCounter);
        counterObserver.unobserve(counter);
      }
    });
  }, { threshold: 0.5 });
  
  counters.forEach(counter => {
    counterObserver.observe(counter);
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Smooth Page Load
// ──────────────────────────────────────────────────────────────────────────

function initPageLoad() {
  // Remove any flash of unstyled content
  document.body.classList.add('page-transition');
  
  // Fade in body
  document.body.style.opacity = '0';
  document.body.style.transition = 'opacity 0.4s ease';
  
  window.addEventListener('load', () => {
    document.body.style.opacity = '1';
  });
}

// ──────────────────────────────────────────────────────────────────────────
// Parallax Effect for Hero
// ──────────────────────────────────────────────────────────────────────────

function initParallax() {
  const hero = document.querySelector('.hero');
  if (!hero) return;
  
  window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    if (scrolled < window.innerHeight) {
      const rate = scrolled * 0.4;
      const heroContent = hero.querySelector('.hero-content');
      if (heroContent) {
        heroContent.style.transform = 'translateY(' + rate + 'px)';
        heroContent.style.opacity = 1 - (scrolled / (window.innerHeight * 0.8));
      }
    }
  }, { passive: true });
}

// ──────────────────────────────────────────────────────────────────────────
// Initialize Everything (Updated)
// ──────────────────────────────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
  initNavScroll();
  initMobileNav();
  initSmoothScroll();
  initScrollAnimations();
  initActiveNavLink();
  initFooterYear();
  initTouchOptimizations();
  initResponsiveImages();
  initCounters();
  initPageLoad();
  initParallax();
  
  console.log(
    '%c Zyrakon %c The Foundation of Intelligent Technology %c v1.0',
    'color: #FF6B2B; font-size: 20px; font-weight: bold;',
    'color: #94A3B8; font-size: 12px;',
    'color: #475569; font-size: 10px;'
  );
});

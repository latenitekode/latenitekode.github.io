'use strict';

// Generic toggle helper
const elementToggleFunc = (elem) => elem.classList.toggle('active');

// Sidebar variables
const sidebar = document.querySelector('[data-sidebar]');
const sidebarBtn = document.querySelector('[data-sidebar-btn]');

// Sidebar toggle functionality (with safety check)
if (sidebar && sidebarBtn) {
  sidebarBtn.addEventListener('click', () => {
    elementToggleFunc(sidebar);
  });
}

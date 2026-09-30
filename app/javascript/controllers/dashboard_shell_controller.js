// app/javascript/controllers/storefront_shell_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "mobileMenuButton",
    "sidebar",
    "userMenuButton",
    "userDropdown"
  ]

  connect() {
    // console.log("Storefront Shell Controller connected")
    // Optional: Add any initialization logic here if needed
  }

  // Toggle Mobile Menu
  toggleMobileMenu(event) {
    event.preventDefault()
    const isExpanded = this.mobileMenuButtonTarget.getAttribute('aria-expanded') === 'true'
    this.mobileMenuButtonTarget.setAttribute('aria-expanded', !isExpanded)
    
    // Toggle sidebar visibility using Tailwind classes
    if (isExpanded) {
      this.sidebarTarget.classList.add('-translate-x-full')
      this.sidebarTarget.classList.remove('translate-x-0')
    } else {
      this.sidebarTarget.classList.remove('-translate-x-full')
      this.sidebarTarget.classList.add('translate-x-0')
    }
  }

  // Toggle User Dropdown
  toggleUserDropdown(event) {
    event.preventDefault()
    const isExpanded = this.userMenuButtonTarget.getAttribute('aria-expanded') === 'true'
    this.userMenuButtonTarget.setAttribute('aria-expanded', !isExpanded)
    this.userDropdownTarget.classList.toggle('hidden')
    
    // Add/remove animation classes for smooth transitions
    if (isExpanded) {
      this.userDropdownTarget.classList.remove('opacity-100', 'scale-100')
      this.userDropdownTarget.classList.add('opacity-0', 'scale-95')
    } else {
      this.userDropdownTarget.classList.remove('opacity-0', 'scale-95')
      this.userDropdownTarget.classList.add('opacity-100', 'scale-100')
    }
  }

  // Close User Dropdown if clicked outside
  closeUserDropdown(event) {
    if (!this.userDropdownTarget.classList.contains('hidden') &&
        !this.userDropdownTarget.contains(event.target) &&
        !this.userMenuButtonTarget.contains(event.target)) {
      this.toggleUserDropdown(event) // Reuse toggle logic to close
    }
  }
}
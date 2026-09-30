// app/javascript/controllers/storefront_shell_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "mobileMenuButton",
    "mobileMenuPanel",
    "mobileMenuClose",
    "userMenuButton",
    "userDropdown",
    "cartBadge"
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
    this.mobileMenuPanelTarget.classList.toggle('hidden')
    // Prevent body scroll when menu is open
    document.body.classList.toggle('overflow-hidden', !isExpanded)
  }

  // Close Mobile Menu
  closeMobileMenu(event) {
    event.preventDefault()
    this.mobileMenuButtonTarget.setAttribute('aria-expanded', 'false')
    this.mobileMenuPanelTarget.classList.add('hidden')
    document.body.classList.remove('overflow-hidden')
  }

  // Toggle User Dropdown
  toggleUserDropdown(event) {
    event.preventDefault()
    const isExpanded = this.userMenuButtonTarget.getAttribute('aria-expanded') === 'true'
    this.userMenuButtonTarget.setAttribute('aria-expanded', !isExpanded)
    this.userDropdownTarget.classList.toggle('hidden')
  }

  // Close User Dropdown
  closeUserDropdown(event) {
    // Check if click is outside the user dropdown and user menu button
    if (!this.userDropdownTarget.classList.contains('hidden') &&
        !this.userDropdownTarget.contains(event.target) &&
        !this.userMenuButtonTarget.contains(event.target)) {
      this.userMenuButtonTarget.setAttribute('aria-expanded', 'false')
      this.userDropdownTarget.classList.add('hidden')
    }
  }

  // Optional: Animate cart badge on item add/remove
  animateCartBadge() {
    if (this.hasCartBadgeTarget) {
      this.cartBadgeTarget.classList.remove('animate-pulse')
      // Trigger reflow
      void this.cartBadgeTarget.offsetWidth
      this.cartBadgeTarget.classList.add('animate-pulse')
    }
  }
}
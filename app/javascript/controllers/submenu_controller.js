import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submenu"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation() // prevents bubbling to window click

    const button = event.currentTarget
    const submenu = button.nextElementSibling
    const expanded = button.getAttribute("aria-expanded") === "true"

    button.setAttribute("aria-expanded", !expanded)

    if (!expanded) {
      submenu.style.maxHeight = submenu.scrollHeight + "px"
    } else {
      submenu.style.maxHeight = null
    }

    const chevron = button.querySelector("svg")
    // if (chevron) chevron.classList.toggle("rotate-180")
  }

  closeIfOutside(event) {
    // Only close if click is outside this whole submenu wrapper
    if (!this.element.contains(event.target)) {
      const button = this.element.querySelector("button")
      const submenu = button.nextElementSibling
      submenu.style.maxHeight = null
      button.setAttribute("aria-expanded", "false")
      const chevron = button.querySelector("svg")
      if (chevron) chevron.classList.remove("rotate-180")
    }
  }

  ignoreClick(event) {
    // Call this on submenu content div
    event.stopPropagation()
  }
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay", "menuButton"]

  connect() {
    // Make sure sidebar state is consistent on load
    this.close()
  }

  toggle() {
    if (this.sidebarTarget.classList.contains("-translate-x-full")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.sidebarTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("hidden")
    this.menuButtonTarget.setAttribute("aria-expanded", "true")
  }

  close() {
    this.sidebarTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")
    this.menuButtonTarget.setAttribute("aria-expanded", "false")
  }
}

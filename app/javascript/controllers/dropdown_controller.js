import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu"]

  connect() {
    this.boundHide = this.hide.bind(this)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    this.buttonTarget.setAttribute("aria-expanded", 
      this.menuTarget.classList.contains("hidden") ? "false" : "true")
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      this.buttonTarget.setAttribute("aria-expanded", "false")
    }
  }
}
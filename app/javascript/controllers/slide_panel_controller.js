// app/javascript/controllers/submenu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu"]

  connect() {
    if (this.element.hasAttribute("data-open")) {
      this.open();
    }
  }

  toggle() {
    if (this.menuTarget.classList.contains("max-h-0")) {
      this.open();
    } else {
      this.close();
    }
  }

  open() {
    this.menuTarget.classList.remove("max-h-0");
    this.menuTarget.classList.add("max-h-[1000px]");
    this.buttonTarget.setAttribute("aria-expanded", "true");
  }

  close() {
    this.menuTarget.classList.remove("max-h-[1000px]");
    this.menuTarget.classList.add("max-h-0");
    this.buttonTarget.setAttribute("aria-expanded", "false");
  }

  closeIfOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }
}
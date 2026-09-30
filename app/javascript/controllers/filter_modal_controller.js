import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backdrop"]

  open() {
    this.modalTarget.classList.remove("hidden")
    this.backdropTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.backdropTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }

  closeOnBackdrop(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }
}
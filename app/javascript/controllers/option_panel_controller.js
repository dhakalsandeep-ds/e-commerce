// app/javascript/controllers/option_panel_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    document.addEventListener("turbo:stream", this.handleStream.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:stream", this.handleStream.bind(this))
  }

  handleStream() {
    if (document.getElementById("close-option-panel-signal")) {
      this.close()
    }
  }

  open() {
    this.panelTarget.classList.remove("translate-x-full")
  }

  close() {
    this.panelTarget.classList.add("translate-x-full")
    // Clean up signal
    const signal = document.getElementById("close-option-panel-signal")
    if (signal) signal.remove()
  }
}
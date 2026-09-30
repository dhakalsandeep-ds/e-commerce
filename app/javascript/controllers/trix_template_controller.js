import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  applyTemplate(event) {
    const templateHtml = event.target.value
    if (!templateHtml) return

    const trixEditor = document.querySelector("trix-editor")
    if (!trixEditor) return

    const hasContent = trixEditor.editor.getDocument().toString().trim()
    if (hasContent && !confirm("Replace current description with this template?")) {
      event.target.selectedIndex = 0
      return
    }

    trixEditor.editor.loadHTML(templateHtml)
  }
}
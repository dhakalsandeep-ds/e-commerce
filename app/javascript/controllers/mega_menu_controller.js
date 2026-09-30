import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const isExpanded = this.element.getAttribute('aria-expanded') === 'true'
    this.element.setAttribute('aria-expanded', !isExpanded)
    this.menuTarget.classList.toggle('hidden')
  }
  
  close(event) {
    if (!this.element.contains(event.target) && !this.menuTarget.contains(event.target)) {
      this.menuTarget.classList.add('hidden')
      this.element.setAttribute('aria-expanded', 'false')
    }
  }
}
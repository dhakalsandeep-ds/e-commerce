import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]
  
  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const isExpanded = this.element.getAttribute('aria-expanded') === 'true'
    this.element.setAttribute('aria-expanded', !isExpanded)
    this.dropdownTarget.classList.toggle('hidden')
  }
  
  close(event) {
    if (!this.dropdownTarget.contains(event.target) && !this.element.contains(event.target)) {
      this.dropdownTarget.classList.add('hidden')
      this.element.setAttribute('aria-expanded', 'false')
    }
  }
}
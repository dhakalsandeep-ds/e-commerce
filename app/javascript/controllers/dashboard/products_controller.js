import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["variant", "template"]

  addVariant(event) {
    event.preventDefault()
    
    const content = this.templateTarget.innerHTML
      .replace(/NEW_RECORD/g, new Date().getTime())
    
    this.variantTarget.insertAdjacentHTML("beforeend", content)
    
    // Add required attributes to newly added fields
    const newVariant = this.variantTarget.lastElementChild;
    const requiredFields = ['sku', 'price', 'stock'];
    
    requiredFields.forEach(field => {
      const input = newVariant.querySelector(`[name*='[${field}]']`);
      if (input) {
        input.required = true;
      }
    });
  }

  removeVariant(event) {
    event.preventDefault()
    const variant = event.target.closest(".variant-fields")
    const destroyInput = variant.querySelector("input[name*='_destroy']")
    
    if (destroyInput) {
      destroyInput.value = 1
      variant.style.display = "none"
    } else {
      variant.remove()
    }
  }

  previewMainImage(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        const preview = this.mainPreviewTarget
        if (preview) {
          preview.innerHTML = `<img src="${e.target.result}" class="h-full w-full object-cover rounded-lg">`
        }
      }
      reader.readAsDataURL(file)
    }
  }

  previewThumbnails(event) {
    const files = event.target.files
    const previewContainer = this.thumbnailsPreviewTarget
    if (previewContainer) {
      previewContainer.innerHTML = ''
      for (let i = 0; i < files.length; i++) {
        const reader = new FileReader()
        reader.onload = (e) => {
          const img = document.createElement('img')
          img.src = e.target.result
          img.className = 'h-16 w-16 object-cover rounded-md border'
          previewContainer.appendChild(img)
        }
        reader.readAsDataURL(files[i])
      }
    }
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainPreview", "thumbnailsPreview"]

  previewMainImage(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        if (this.hasMainPreviewTarget) {
          this.mainPreviewTarget.innerHTML = `<img src="${e.target.result}" class="h-full w-full object-cover">`
        }
        const sidebarMain = document.getElementById('main-preview')
        if (sidebarMain) {
          sidebarMain.innerHTML = `<img src="${e.target.result}" class="h-full w-full object-cover rounded-lg">`
        }
      }
      reader.readAsDataURL(file)
    }
  }

  previewThumbnails(event) {
    const files = event.target.files
    if (files.length === 0) return

    if (this.hasThumbnailsPreviewTarget) {
      this.thumbnailsPreviewTarget.innerHTML = ''
      this.createThumbnails(files, this.thumbnailsPreviewTarget)
    }
    
    const sidebarThumbnails = document.getElementById('thumbnails-preview')
    if (sidebarThumbnails) {
      sidebarThumbnails.innerHTML = ''
      this.createThumbnails(files, sidebarThumbnails)
    }
  }

  createThumbnails(files, container) {
    for (let i = 0; i < files.length; i++) {
      const reader = new FileReader()
      reader.onload = (e) => {
        const img = document.createElement('img')
        img.src = e.target.result
        img.className = 'h-16 w-16 object-cover rounded-md border border-gray-200'
        container.appendChild(img)
      }
      reader.readAsDataURL(files[i])
    }
  }
}
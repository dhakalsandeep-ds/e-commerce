import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["variantSelector", "quantityInput", "thumbnails"]

  connect() {
    this.variants = JSON.parse(document.getElementById("variants-data").textContent)

    this.addToCartBtn = document.getElementById("add-to-cart-button")
    this.buyNowBtn = document.getElementById("buy-now-button")
    this.priceEl = document.getElementById("product-price")
    this.inventoryEl = document.getElementById("inventory-status")
    this.selectedOptions = {}

    // Preselect first options
    this.variantSelectorTargets.forEach(btn => {
      if (btn.dataset.selected === "true") {
        this.selectOption(btn.dataset.optionType, btn.dataset.optionValue, btn)
      }
      btn.addEventListener("click", () =>
        this.selectOption(btn.dataset.optionType, btn.dataset.optionValue, btn)
      )
    })

    this.updateVariantDisplay()
  }

  selectOption(type, value, btn) {
    // Deselect siblings
    this.variantSelectorTargets.forEach(b => {
      if (b.dataset.optionType === type) {
        b.classList.remove("bg-blue-100", "border-blue-500")
      }
    })

    btn.classList.add("bg-blue-100", "border-blue-500")
    this.selectedOptions[type] = value
    this.updateVariantDisplay()
  }

  updateVariantDisplay() {
    const selectedIds = Object.values(this.selectedOptions).map(Number)

    const variant = this.variants.find(v => {
      const vIds = v.option_value_ids.map(Number)
      return vIds.length === selectedIds.length && selectedIds.every(id => vIds.includes(id))
    })

    const mainImage = document.getElementById("main-product-image")
    const defaultSrc = mainImage.dataset.defaultSrc

    if (variant) {
      // Price
      this.priceEl.textContent = `$ ${parseFloat(variant.price).toFixed(2)}`

      // Stock
      if (variant.stock > 0) {
        this.inventoryEl.textContent = `In stock (${variant.stock} available)`
        this.addToCartBtn.disabled = false
        this.buyNowBtn.disabled = false

        document.getElementById("selected-variant-id").value = variant.id
        document.getElementById("buy-now-variant-id").value = variant.id
      } else {
        this.inventoryEl.textContent = "Out of stock"
        this.addToCartBtn.disabled = true
        this.buyNowBtn.disabled = true
      }

      // Image
      this.fadeImage(mainImage, variant.image_url || defaultSrc)
    } else {
      this.inventoryEl.textContent = "No matching variant"
      this.addToCartBtn.disabled = true
      this.buyNowBtn.disabled = true
      this.fadeImage(mainImage, defaultSrc)
    }
  }

  fadeImage(img, src) {
    if (img.src === src) return
    img.style.opacity = "0"
    setTimeout(() => {
      img.src = src
      img.onload = () => (img.style.opacity = "1")
    }, 150)
  }

  adjustQuantity(event) {
    const delta = parseInt(event.currentTarget.dataset.delta)
    let qty = parseInt(this.quantityInputTarget.value)

    qty = Math.min(99, Math.max(1, qty + delta))
    this.quantityInputTarget.value = qty

    document.getElementById("form-quantity").value = qty
    document.getElementById("buy-now-quantity").value = qty
  }

  switchImage(event) {
    this.fadeImage(
      document.getElementById("main-product-image"),
      event.currentTarget.src
    )
  }

  switchVariant(event) {
    const variantId = parseInt(event.currentTarget.dataset.variant_id)
    const variant = this.variants.find(v => v.id === variantId)
    if (!variant) return

    // Update selections visually based on variant option IDs
    this.variantSelectorTargets.forEach(b => {
      const optVal = Number(b.dataset.optionValue)
      if (variant.option_value_ids.includes(optVal)) {
        b.classList.add("bg-blue-100", "border-blue-500")
        this.selectedOptions[b.dataset.optionType] = b.dataset.optionValue
      } else {
        b.classList.remove("bg-blue-100", "border-blue-500")
      }
    })

    this.updateVariantDisplay()
  }
}

// app/javascript/controllers/variants_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "fields"]

  connect() {
    this.selectedOptions = []
    this.variants = []
    this.variantCounter = 0

    // Load existing variants on edit
    if (this.hasExistingVariants()) {
      this.loadExistingVariants()
    }
  }

  addOption() {
    const select = document.getElementById('option-type-selector')
    const option = select.options[select.selectedIndex]
    if (!option.value) return

    const optionType = JSON.parse(option.dataset.optionType)
    
    // Avoid duplicates
    if (this.selectedOptions.some(ot => ot.id === optionType.id)) {
      alert('Option type already added')
      return
    }

    this.selectedOptions.push(optionType)
    this.renderSelectedOptions()
    select.selectedIndex = 0
  }

  removeOption(event) {
    const optionId = event.params.id
    this.selectedOptions = this.selectedOptions.filter(ot => ot.id != optionId)
    this.renderSelectedOptions()
  }

  generateAll() {
    if (this.selectedOptions.length === 0) {
      alert('Please add at least one option type')
      return
    }

    // Get all option values
    const optionValuesByType = this.selectedOptions.map(ot => ot.option_values)

    // Generate Cartesian product
    const combinations = optionValuesByType.reduce((acc, curr) => {
      if (acc.length === 0) return curr.map(v => [v])
      return acc.flatMap(d => curr.map(e => [...d, e]))
    }, [])

    // Create variants
    this.variants = combinations.map(combo => ({
      id: null,
      sku: '',
      price: '',
      stock: '',
      optionValues: combo,
      _destroy: '0'
    }))

    this.renderVariants()
  }

  addManualVariant() {
    this.variants.push({
      id: null,
      sku: '',
      price: '',
      stock: '',
      optionValues: [],
      _destroy: '0'
    })
    this.renderVariants()
  }

  removeVariant(event) {
    const index = event.params.index
    this.variants[index]._destroy = '1'
    this.renderVariants()
  }

  updateVariantField(event) {
    const { name, value } = event.target
    const index = event.target.dataset.index
    const field = name.split('[').pop().replace(']', '')
    this.variants[index][field] = value
  }

  renderSelectedOptions() {
    const container = document.getElementById('selected-options')
    container.innerHTML = this.selectedOptions.map(ot => `
      <span class="inline-flex items-center px-3 py-1 rounded-full text-sm bg-indigo-100 text-indigo-800">
        ${ot.name}
        <button type="button" class="ml-2 text-indigo-600 hover:text-indigo-800" 
                data-action="click->variants#removeOption" 
                data-variants-id-param="${ot.id}">
          ✕
        </button>
      </span>
    `).join('')
  }

  renderVariants() {
    let variantHtml = ''
    let fieldsHtml = ''

    this.variants.forEach((variant, index) => {
      if (variant._destroy === '1') return

      const optionNames = variant.optionValues.map(ov => ov.name).join(" / ") || 'Manual variant'
      
      variantHtml += `
        <div class="variant-row border p-4 rounded-lg relative" data-index="${index}">
          <button type="button" class="absolute top-2 right-2 text-red-500 hover:text-red-700" 
                  data-action="click->variants#removeVariant" 
                  data-variants-index-param="${index}">
            ✕
          </button>
          <div class="font-medium mb-2">${optionNames}</div>
          <div class="grid grid-cols-3 gap-4">
            <input type="text" 
                   name="product[variants_attributes][${index}][sku]" 
                   value="${variant.sku || ''}"
                   placeholder="SKU" 
                   class="px-2 py-1 border rounded text-sm"
                   data-index="${index}"
                   data-action="input->variants#updateVariantField">
            <input type="number" 
                   step="0.01" 
                   name="product[variants_attributes][${index}][price]" 
                   value="${variant.price || ''}"
                   placeholder="Price" 
                   class="px-2 py-1 border rounded text-sm"
                   data-index="${index}"
                   data-action="input->variants#updateVariantField">
            <input type="number" 
                   name="product[variants_attributes][${index}][stock]" 
                   value="${variant.stock || ''}"
                   placeholder="Stock" 
                   class="px-2 py-1 border rounded text-sm"
                   data-index="${index}"
                   data-action="input->variants#updateVariantField">
          </div>
          <input type="hidden" name="product[variants_attributes][${index}][id]" value="${variant.id || ''}">
          <input type="hidden" name="product[variants_attributes][${index}][_destroy]" value="${variant._destroy}">
          ${variant.optionValues.map(ov => 
            `<input type="hidden" name="product[variants_attributes][${index}][option_value_ids][]" value="${ov.id}">`
          ).join('')}
        </div>
      `
    })

    this.containerTarget.innerHTML = variantHtml || '<p class="text-gray-500">No variants. Click "Generate All Combinations" or "Add Variant Manually".</p>'
  }

  hasExistingVariants() {
    return document.querySelectorAll('[name^="product[variants_attributes]"]').length > 0
  }

  loadExistingVariants() {
    // Load from hidden fields on edit
    const variantInputs = document.querySelectorAll('#variants-fields input[name^="product[variants_attributes]"]')
    // This is simplified; in practice, you'd parse the existing variants
    // For now, we'll just keep the existing hidden fields and let the form submit them
  }
}
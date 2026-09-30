import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["optionsContainer", "variantsContainer", "variantTemplate"]
  static values = { optionTypes: Array }

  connect() {
    this.selectedOptions = this.optionTypesValue.map(ot => ({
      ...ot,
      selectedValues: ot.option_values.map(v => v.id)
    }))
    this.renderOptions()
    this.generateVariants()
  }

  toggleOptionValue(event) {
    const { optionId, valueId } = event.params
    const option = this.selectedOptions.find(opt => opt.id == optionId)
    const index = option.selectedValues.indexOf(parseInt(valueId))
    
    if (index > -1) {
      option.selectedValues.splice(index, 1)
    } else {
      option.selectedValues.push(parseInt(valueId))
    }
    
    this.generateVariants()
  }

  renderOptions() {
    this.optionsContainerTarget.innerHTML = this.selectedOptions.map(opt => `
      <div class="border rounded-lg p-4 bg-white">
        <div class="flex items-center justify-between mb-3">
          <h3 class="font-medium text-gray-900">${opt.name}</h3>
          <span class="text-sm text-gray-500">${opt.selectedValues.length} selected</span>
        </div>
        <div class="flex flex-wrap gap-2">
          ${opt.option_values.map(val => `
            <label class="inline-flex items-center bg-gray-50 px-3 py-1.5 rounded-lg border cursor-pointer ${opt.selectedValues.includes(val.id) ? 'border-blue-500 bg-blue-50' : 'border-gray-200'}">
              <input type="checkbox" 
                     class="sr-only"
                     ${opt.selectedValues.includes(val.id) ? 'checked' : ''}
                     data-action="click->product-form#toggleOptionValue"
                     data-product-form-option-id-param="${opt.id}"
                     data-product-form-value-id-param="${val.id}">
              <span class="text-sm font-medium">${val.name}</span>
            </label>
          `).join('')}
        </div>
      </div>
    `).join('')
  }

  generateVariants() {
    this.variantsContainerTarget.innerHTML = ''

    const validOptions = this.selectedOptions.filter(opt => opt.selectedValues.length > 0)
    if (validOptions.length === 0) return

    let combos
    if (validOptions.length === 1) {
      combos = validOptions[0].selectedValues.map(id => {
        const val = validOptions[0].option_values.find(v => v.id == id)
        return [{ option_type_id: validOptions[0].id, option_value: val }]
      })
    } else {
      const groups = validOptions.map(opt => 
        opt.selectedValues.map(id => {
          const val = opt.option_values.find(v => v.id == id)
          return { option_type_id: opt.id, option_value: val }
        })
      )
      combos = this.cartesianProduct(groups)
    }

    combos.forEach((combo, index) => {
      const label = combo.map(item => item.option_value.name).join(' / ')
      const valueIds = combo.map(item => item.option_value.id)

      const content = this.variantTemplateTarget.innerHTML
        .replace(/INDEX/g, index)
        .replace('{{LABEL}}', label)

      const wrapper = document.createElement('div')
      wrapper.innerHTML = content.trim()
      const variantDiv = wrapper.firstElementChild

      // Add hidden option_value_ids
      valueIds.forEach(id => {
        const input = document.createElement('input')
        input.type = 'hidden'
        input.name = `product[variants_attributes][${index}][option_value_ids][]`
        input.value = id
        variantDiv.appendChild(input)
      })

      this.variantsContainerTarget.appendChild(variantDiv)
    })
  }

  cartesianProduct(arr) {
    return arr.reduce((a, b) => a.flatMap(d => b.map(e => [d, e].flat())))
  }

  removeVariant(event) {
    const row = event.target.closest('[data-variant]')
    const destroy = row.querySelector('input[name$="[_destroy]"]')
    if (destroy) {
      destroy.value = '1'
      row.classList.add('hidden')
    } else {
      row.remove()
    }
  }
}
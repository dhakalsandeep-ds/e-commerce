module Dashboard::ProductsHelper
def product_description_templates
    YAML.load_file(Rails.root.join("config", "product_templates.yml")).transform_keys(&:titleize)
  end

end

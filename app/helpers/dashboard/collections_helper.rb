module Dashboard::CollectionsHelper
  def options_for_predicate(field, selected = nil)
    options = case field
              when "name"
                [["is", "is"], ["contains", "contains"]]
              when "price"
                [["is", "is"], ["less_than", "less than"], ["greater_than", "greater than"]]
              when "category_id"
                [["is", "is"]]
              else
                []
              end
    options_for_select(options, selected)
  end
end
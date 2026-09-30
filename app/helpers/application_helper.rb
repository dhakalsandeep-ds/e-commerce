module ApplicationHelper 
    def toggle_direction(current)
    current == "asc" ? "desc" : "asc"
  end 

 def sort_link(label, column, current_sort, current_direction)
  direction = (column == current_sort && current_direction == "asc") ? "desc" : "asc"

  icon = case direction
  when "asc"
    '<svg class="inline w-3 h-3 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"></path></svg>'.html_safe
  when "desc"
    '<svg class="inline w-3 h-3 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>'.html_safe
  end

  is_sorted = column == current_sort
  classes = "hover:underline font-medium #{is_sorted ? 'text-blue-600' : ''}"

  # Preserve existing params like `query` and `per_page`
  url_params = { sort: column, direction: direction }
  url_params[:query] = params[:query] if params[:query]
  url_params[:per_page] = params[:per_page] if params[:per_page]

  link_to(
    "#{label} #{icon}".html_safe,
    url_params,
    class: classes
  )
end

  # app/helpers/application_helper.rb
def format_price(amount)
  # For Nepal
  "Rs #{number_with_precision(amount, precision: 2)}"
  
  # For Eurozone
  # number_to_currency(amount, unit: "€", separator: ",", delimiter: ".")
  
  # For USD (default)
  # number_to_currency(amount)
end


# app/helpers/application_helper.rb
def sidebar_link_class(path)
  base = "flex items-center px-4 py-2 text-sm font-medium rounded-md transition"
  current_page?(path) ? "#{base} bg-indigo-50 text-indigo-600" : "#{base} text-gray-700 hover:bg-gray-100 hover:text-indigo-700"
end


def flash_bg_class(type)
  case type.to_sym
  when :notice then "bg-green-50"
  when :alert then "bg-red-50"
  else "bg-gray-50"
  end
end

def flash_text_class(type)
  case type.to_sym
  when :notice then "text-green-800"
  when :alert then "text-red-800"
  else "text-gray-800"
  end
end

def flash_icon(type)
  case type.to_sym
  when :notice then tag.svg(class: "h-5 w-5 text-green-400", xmlns: "http://www.w3.org/2000/svg", fill: "currentColor", viewBox: "0 0 20 20") { tag.path(fill_rule: "evenodd", d: "M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z", clip_rule: "evenodd") }
  when :alert  then tag.svg(class: "h-5 w-5 text-red-400", xmlns: "http://www.w3.org/2000/svg", fill: "currentColor", viewBox: "0 0 20 20") { tag.path(fill_rule: "evenodd", d: "M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z", clip_rule: "evenodd") }
  end
end


module DashboardHelper
  def color_class(segment)
    case segment
    when "VIP"
      "bg-yellow-100 text-yellow-800"
    when "Loyal"
      "bg-green-100 text-green-800"
    when "New"
      "bg-blue-100 text-blue-800"
    when "At-Risk"
      "bg-red-100 text-red-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end



end

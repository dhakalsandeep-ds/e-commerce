class PlaceholdersController < ApplicationController
  def show
    text = params[:text] || "Placeholder"
    w = params[:w] || 600
    h = params[:h] || 400
    bg = params[:bg] || "e5e7eb"
    fg = params[:fg] || "6b7280"

    image = MiniMagick::Image.create("png") do |file|
      file.write ""
    end

    image.combine_options do |c|
      c.size "#{w}x#{h}"
      c.gravity "center"
      c.xc "##{bg}"
      c.fill "##{fg}"
      c.pointsize "32"
      c.draw "text 0,0 '#{text}'"
    end

    send_data image.to_blob,
              type: "image/png",
              disposition: "inline"
  end
end
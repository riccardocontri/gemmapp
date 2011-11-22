module ApplicationHelper
    APP_NAME = "Gemmapp"

    def page_title
        APP_NAME + ((@page_name.blank?) ? "" : " | #{@page_name}")
    end

    def logo
        image_tag("logo.png", :size => "76x67", :alt => APP_NAME, :class => "round")
    end
end

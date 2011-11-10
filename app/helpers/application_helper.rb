module ApplicationHelper
    APP_NAME = "Gemmapp"

    def page_title
        APP_NAME + ((@page_name.blank?) ? "" : " | #{@page_name}")
    end
end

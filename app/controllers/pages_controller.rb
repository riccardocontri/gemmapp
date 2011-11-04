class PagesController < ApplicationController
    def home
        @page_name = __method__.capitalize
    end

    def about
        @page_name = __method__.capitalize
    end

    def contacts
        @page_name = __method__.capitalize
    end
end

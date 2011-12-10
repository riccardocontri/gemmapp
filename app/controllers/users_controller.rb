class UsersController < ApplicationController
    def new
        @page_name = 'Join'
    end

    def show
        @user = User.find(params[:id])
        @page_name = @user.short_name
    end
end

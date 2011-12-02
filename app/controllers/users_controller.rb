class UsersController < ApplicationController
    def new
        @page_name = 'Join'
    end

    def show
        #TODO @title = ...
        @user = User.find(params[:id])
    end
end

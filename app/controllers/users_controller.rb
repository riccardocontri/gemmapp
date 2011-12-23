class UsersController < ApplicationController
    NEW_USER_PAGE_NAME = 'Join'
    WELCOME_MESSAGE = "Benvenuto in Gemmapp!"

    def new
        @user = User.new
        @page_name = NEW_USER_PAGE_NAME
    end

    def show
        @user = User.find(params[:id])
        @page_name = @user.short_name
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            flash[:success] = WELCOME_MESSAGE
            redirect_to @user
        else
            @page_name = NEW_USER_PAGE_NAME
            render 'new'
        end
    end
end

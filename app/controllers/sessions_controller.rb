class SessionsController < ApplicationController
    SIGN_IN_PAGE_NAME = 'Sign In'

    def new
        @page_name = SIGN_IN_PAGE_NAME
    end

    def create
        email = params[:session][:email]
        pwd = params[:session][:password]
        user = User.authenticate(email, pwd)

        if user
            sign_in user
            redirect_to user
        else
            @page_name = SIGN_IN_PAGE_NAME
            flash.now[:error] = 'Email e/o password non validi'
            render 'new'
        end
    end

    def destroy
        sign_out
        redirect_to root_path
    end
end

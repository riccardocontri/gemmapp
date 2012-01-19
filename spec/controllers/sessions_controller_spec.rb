require 'spec_helper'

describe SessionsController do
    render_views

    describe "'Sign In' page" do
        before(:each) do
            get :new
        end

        it "should be successful" do
            response.should be_success
        end

        it "should have title containing 'Sign In'" do
            response.should have_selector("title", :content => "Sign In")
        end

        it "should obscure the password field" do
            response.should have_selector("input[name='session[password]'][type='password']")
        end
    end

    describe "Creating a new session" do
        context "with invalid attributes" do
            before(:each) do
                post :create, :session => { :email => "", :password => "" }
            end

            it "should render the 'Sign in' page again" do
                response.should render_template('new')
                response.should have_selector('title', :content => 'Sign In') #TODO ??? richiamare it "should have title containing 'Sign In'" sopra?
            end

            it "should show an error message" do
                flash[:error].should_not be_nil
                #response.should have_selector()
            end

            it "should not sign the user in" do
                controller.current_user.should be_nil
            end
        end

        context "with valid attributes" do
            before(:each) do
                @user = Factory(:user)
                attrs = { :email => @user.email, :password => @user.password }
                post :create, :session => attrs
            end

            it "should sign the user in" do
                controller.current_user.should == @user
            end

            it "should redirect to the user's profile page" do
                response.should redirect_to(user_path(@user))
            end
        end

        describe "2 times" do
            it "should not be allowed"
        end
    end

    describe "Terminating a session" do
        before(:each) do
            @user = Factory(:user)
            controller.sign_in(@user)
            controller.current_user.should == @user

            delete :destroy
        end

        it "should sign the user out" do
            controller.current_user.should be_nil
        end

        it "should redirect to the home page" do
            response.should redirect_to(root_path)
        end
    end
end

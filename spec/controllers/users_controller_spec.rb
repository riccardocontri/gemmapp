require 'spec_helper'

describe UsersController do
    render_views

    describe "New user page" do
        before(:each) do
            get :new
        end

        it "should return http success" do
            response.should be_success
        end

        it "should have title containing 'Join'" do
            response.should have_selector("title", :content => "Join")
        end
    end

    describe "Submit new user" do
        describe "with invalid attributes" do
            before(:each) do
                @invalid_attrs = { :name => "", :email => "invaliduser@domain.com", :password => "",
                    :password_confirmation => "" }
                post :create, :user => @invalid_attrs
            end

            it "should not create a new user" do
                User.find_by_email(@invalid_attrs[:email]).should be_nil
            end

            it "should render the 'new user' page again" do
                response.should render_template('new')
                response.should have_selector("title", :content => "Join") #TODO ??? Richiamare it "should have title containing 'Join'"
            end

            it "should highlight invalid attributes" do
                response.should have_selector("div", :id => "error_explanation")
            end

            it "should not show a welcome message" do
                flash[:success].should be_nil
                #response.should have_selector("div", :class => "flash success")
            end
        end

        describe "with valid attributes" do
            before(:all) do
                @valid_password = '123Password'
            end

            before(:each) do
                valid_user_attrs =
                {
                    :name => "User name",
                    :surname => "User surname",
                    :nickname => "User nickname",
                    :email => "username@domain.com",
                    :password => @valid_password,
                    :password_confirmation => @valid_password
                }
                @valid_attrs = valid_user_attrs
            end

            it "should create a new user" do
                User.find_by_email(@valid_attrs[:email]).should be_nil
                post :create, :user => @valid_attrs
                User.find_by_email(@valid_attrs[:email]).should_not be_nil
            end

            it "should redirect to the new user's profile page" do
                post :create, :user => @valid_attrs
                new_user = User.find_by_email(@valid_attrs[:email])
                response.should redirect_to(user_path(new_user))
            end

            it "should show a welcome message" do
                post :create, :user => @valid_attrs
                flash[:success].should_not be_nil
                #response.should have_selector("div", :class => "flash success")
            end

            it "should not highlight invalid attributes" do
                post :create, :user => @valid_attrs
                response.should_not have_selector("div", :id => "error_explanation")
            end
        end
    end

    describe "User profile page" do
        before(:each) do
            @test_user = Factory(:user)
            User.should_receive(:find).with(@test_user.id).and_return(@test_user)
            get :show, :id => @test_user.id
        end

        it "should return http success" do
            response.should be_success
        end

        it "should have title containing short user name" do
            response.should have_selector("title", :content => @test_user.short_name)
        end

        it "should have heading containing full user name" do
            response.should have_selector("h1", :content => @test_user.full_name)
        end

        it "should have heading containing user image" do
            response.should have_selector("h1>img", :class => "gravatar")
        end
    end
end

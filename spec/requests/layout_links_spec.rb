require 'spec_helper'

describe "LayoutLinks" do

    it "Should have valid links" do
        visit root_path

        click_link "about"
        response.should have_selector("title", :content => "About")

        click_link "contatti"
        response.should have_selector("title", :content => "Contacts")

        click_link "Home"
        response.should have_selector("title", :content => "Home")
    end

    describe "GET '/'" do
        it "Should open the Home page" do
            get "/"
            response.should have_selector("title", :content => "Home")
        end
    end

    describe "GET 'about'" do
        it "Should open the About page" do
            get "/about"
            response.should have_selector("title", :content => "About")
        end
    end

    describe "GET 'contacts'" do
        it "Should open the Contacts page" do
            get "/contacts"
            response.should have_selector("title", :content => "Contacts")
        end
    end

    describe "when not signed in" do
        before(:each) do
            visit root_path
            controller.sign_out
        end

        it "should have a 'signin' link" do
            response.should have_selector("header") do |h|
                h.should have_selector("a", :href => signin_path)
            end
        end

        it "should not have a 'signout' link" do
            response.should have_selector("header") do |h|
                h.should_not have_selector("a", :href => signout_path)
            end
        end
    end

    describe "when signed in" do
        before(:each) do
            @user = Factory(:user)
            visit signin_path
            fill_in :session_email, :with => @user.email
            fill_in :session_password, :with => @user.password
            click_button
        end

        it "should have a 'signout' link" do
            response.should have_selector("header") do |h|
                h.should have_selector("a", :href => signout_path)
            end
        end

        it "should not have a 'signin' link" do
            response.should have_selector("header") do |h|
                h.should_not have_selector("a", :href => signin_path)
            end
        end

        it "should have a 'profile' link" do
            response.should have_selector("header") do |h|
                h.should have_selector("a", :href => user_path(@user))
            end
        end
    end


#TODO Spostare altrove (non c'entrano con il layout)
  describe "GET 'join'" do
    it "Should open the New user page" do
      get "/join"
      response.should render_template("users/new")
      response.should have_selector("title", :content => "Join")
    end
  end
end

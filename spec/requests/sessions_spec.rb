require 'spec_helper'

describe "Sign in management" do
    def sign_in(user)
        visit signin_path
        fill_in :session_email, :with => user.email
        fill_in :session_password, :with => user.password
        click_button
    end

    describe "with invalid attributes" do
        it "should not open an user session" do
            invalid_user = User.new
            sign_in(invalid_user)

            response.should have_selector("div.flash.error")
            controller.current_user.should be_nil
        end
    end

    describe "with valid attributes" do
        it "should allow the user to sign in and out" do
            valid_user = Factory(:user)
            sign_in(valid_user)

            controller.current_user.should == valid_user
            click_link 'signout_link'
            controller.current_user.should be_nil
        end
    end
end

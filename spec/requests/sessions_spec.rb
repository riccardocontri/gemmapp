require 'spec_helper'

describe "Sign in management" do
    describe "with invalid attributes" do
        it "should not open an user session" do
            visit signin_path
            fill_in :session_email, :with => ""
            fill_in :session_password, :with => ""
            click_button
            response.should have_selector("div.flash.error")
            controller.current_user.should be_nil
        end
    end

    describe "with valid attributes" do
        it "should allow the user to sign in and out" do
            user = Factory(:user)
            visit signin_path
            fill_in :session_email, :with => user.email
            fill_in :session_password, :with => user.password
            click_button
            controller.current_user.should == user
            click_link 'signout_link'
            controller.current_user.should be_nil
        end
    end
end

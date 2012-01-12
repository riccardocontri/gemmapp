require 'spec_helper'

describe "Sign in" do
    describe "with invalid attributes" do
        pending "should fail" do
            visit signin_path
            fill_in :session_email, :with => "" #"n@domain.com"
            fill_in :session_password, :with => "" #"123Password"
            click_button
            response.should render_template("users/new")
            response.should have_selector("div#error_explanation")
        end
    end
end

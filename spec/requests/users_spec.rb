require 'spec_helper'

describe "Users" do
    describe "creation with wrong attributes" do
        it "should not create a new user" do
            lambda do
                visit join_path
                click_button
                response.should render_template("users/new")
                response.should have_selector("div#error_explanation")
            end.should_not change(User, :count)
        end
    end

    describe "creation with valid attributes" do
        it "should create a new user" do
            lambda do
                visit join_path
                fill_in :user_name, :with => "User Name"
                fill_in :user_surname, :with => "User Surname"
                fill_in :user_nickname, :with => "User Nickame"
                fill_in :user_email, :with => "n@domain.com"
                fill_in :user_password, :with => "123Password"
                fill_in :user_password_confirmation, :with => "123Password"
                click_button
                response.should render_template("users/show")
                response.should have_selector("div.flash.success")
            end.should change(User, :count).by(1)
        end
    end
end

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

    describe "User details page" do
        before(:each) do
            @test_user = Factory(:user)
            User.should_receive(:find).with(@test_user.id).and_return(@test_user)
            get :show, :id => @test_user.id
        end

        it "should return http success" do
            response.should be_success
        end

        it "should have title containing user name" do
            response.should have_selector("title", :content => @test_user.name)
        end

        it "should have heading containing user name" do
            response.should have_selector("h1", :content => @test_user.name)
        end

        it "should have heading containing user image" do
            response.should have_selector("h1>img", :class => "gravatar")
        end
    end
end

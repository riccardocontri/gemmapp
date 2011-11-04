require 'spec_helper'

describe PagesController do
    render_views
    
    describe "GET 'home'" do
        it "returns http success" do
            get 'home'
            response.should be_success
        end
        
        it "should have title containing 'Home'" do
            get 'home'
            response.should have_selector("title", :content => "Home")
        end
    end
    
    describe "GET 'about'" do
        it "returns http success" do
            get 'about'
            response.should be_success
        end
        
        it "should have title containing 'About'" do
            get 'about'
            response.should have_selector("title", :content => "About")
        end
    end
    
    describe "GET 'contacts'" do
        it "returns http success" do
            get 'contacts'
            response.should be_success
        end
        
        it "should have title containing 'Contacts'" do
            get 'contacts'
            response.should have_selector("title", :content => "Contacts")
        end
    end
end

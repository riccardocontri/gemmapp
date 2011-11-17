require 'spec_helper'

describe "LayoutLinks" do

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

end

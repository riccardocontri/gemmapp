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

  describe "GET 'join'" do
    it "Should open the New user page" do
      get "/join"
      response.should have_selector("title", :content => "Join")
    end
  end

end

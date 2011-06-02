require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end


  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a",  :href => signin_path,
                                          :content => "Sign in")
    end
  end


  describe "when signed in as a normal user" do
    before(:each) do
      @user = Factory(:user)
        integration_sign_in(@user)
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a",  :href => signout_path,
                                          :content => "Sign out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector("a",  :href => user_path(@user),
                                          :content => "Profile")
    end

    it "should not have delete links on the users index" do
      visit users_path
      response.should_not have_selector("a",  :content => "delete")
    end
  end

  describe "when signed in as an admin user" do
    before(:each) do
      @admin = Factory(:user, :email => "admin@example.com", :admin => true)
      integration_sign_in(@admin)
    end

    it "should have delete links on the users index" do
      visit users_path
      response.should have_selector("a",  :content => "delete")
    end
  end
  
end

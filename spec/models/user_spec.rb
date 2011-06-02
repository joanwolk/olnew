require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com", 
              :password => "foobar", 
              :password_confirmation => "foobar" 
            }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should not require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_bar.org first.last@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    duplicate_email_user = User.new(@attr)
    duplicate_email_user.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    duplicate_email_user = User.new(@attr)
    duplicate_email_user.should_not be_valid
  end

  it "should require a password" do
    User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
  end

  it "should require a matching password confirmation" do
    User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
  end

  it "should reject short passwords" do
    shortpw = "a" * 5
    User.new(@attr.merge(:password => shortpw, :password_confirmation => shortpw)).
      should_not be_valid
  end

  

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have a password digest attribute" do
      @user.should respond_to(:password_digest)
    end

    it "should set the password digest" do
      @user.password_digest.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        (@user.password=="foobar").should be_true
      end

      it "should be false if the passwords don't match" do
        (@user.password=="invalid").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        bad_pw_user = User.find_by_email(@attr[:email]).try(:authenticate, "wrongpass")
        bad_pw_user.should be_false
      end

      it "should return nil for an email address with no user" do
        nonuser = User.find_by_email("bar@foo.com").try(:authenticate, @attr[:password])
        nonuser.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.find_by_email(@attr[:email]).try(:authenticate, @attr[:password])
        matching_user.should == @user
      end
    end
  end


  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

end

require 'spec_helper'

describe Invitation do

  before(:each) do
    @invited = { 
                :recipient_email => "test@example.com",
                :sender_id => 1
    }
  end

  it "should require an email address" do
    Invitation.new(@invited.merge(:recipient_email => "")).should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_invite = Invitation.new(@invited.merge(:recipient_email => address))
      valid_email_invite.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_bar.org first.last@foo.]
    addresses.each do |address|
      invalid_email_invite = Invitation.new(@invited.merge(:recipient_email => address))
      invalid_email_invite.should_not be_valid
    end
  end

  it "should require the recipient not be a registered user" do
    user = Factory(:user)
    Invitation.new(:recipient_email => user.email).should_not be_valid 
  end

  it "should generate a token" do
    Invitation.create!(@invited).token.should_not be_nil
  end

  it "should have a sender id" do
    Invitation.create!(@invited).sender_id.should_not be_nil
  end

  it "should have a sent_at field" do
    Invitation.create!(@invited).sent_at.should_not be_nil
  end
end

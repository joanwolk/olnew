require 'spec_helper'

describe "Invitations" do
  before(:each) do
    @admin = Factory(:user, :email => "admin@example.com", :admin => true)
    integration_sign_in(@admin)
  end

  describe "failure" do
    it "should not generate an invitation" do
      lambda do
        visit new_invitation_path
        fill_in "Recipient email",  :with => "invalid"
        click_button
        response.should have_selector("div#error_explanation", :content => "There were problems")
        response.should render_template('invitations/new')
      end.should_not change(Invitation, :count)
    end
  end


  describe "success" do
    it "should generate an invitation with the proper sender id" do
      lambda do
        visit new_invitation_path
        fill_in "Recipient email",  :with => "somethingnew@example.com"
        click_button
        response.should have_selector("div.flash.success", :content => "Invitation sent")
        response.should render_template('invitations/new')
        Invitation.last.sender_id.should == @admin.id
      end.should change(Invitation, :count).by(1)
    end
  end
end

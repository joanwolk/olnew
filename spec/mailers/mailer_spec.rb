require "spec_helper"

describe Mailer do
  describe "invitation" do
    before(:each) do
      @invitation = Invitation.create!(recipient_email: "somegnome@example.com")
      @email = Mailer.invite(@invitation)
    end

    it "queues the email for delivery" do
      @email = Mailer.invite(@invitation).deliver
      ActionMailer::Base.deliveries.should_not be_empty      
    end

    context "headers" do
      it "renders the correct subject" do
        @email.subject.should eq("Invitation to OLN site")
      end

      it "sends to the correct recipient" do
        @email.to.should eq(["somegnome@example.com"])
      end

      it "shows the correct sender" do
        @email.from.should eq(["aldea@ominous-latin-noun.com"])
      end
    end

    it "renders the body" do
      @email.body.encoded.should match("Welcome")
    end
  end

end

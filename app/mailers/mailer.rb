class Mailer < ActionMailer::Base
  default from: "aldea@ominous-latin-noun.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.invitation.subject
  #
  def invite(invitation)
    @invitation = invitation
    @signup_url = signup_url(host: "ominous-latin-noun.com")
    @greeting = "Welcome to the guild!"
    mail(to: @invitation.recipient_email, subject: "Invitation to OLN site")
  end
end

class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_message.subject
  #
  def welcome_message(user)
    @user = user
    @greeting = "Hi"

    mail(to: @user.email, subject: "Welcome to Our Platform!")
  end
end

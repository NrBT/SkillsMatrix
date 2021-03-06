class Admin::AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin.admin_mailer.new_registration_email.subject
  #
  def new_registration_email( new_user )
    @new_user = new_user
    emails = User.administrators.collect(&:email).join(",")
    mail( bcc: emails, subject: "SkillsMatrix: new user #{new_user.name}" )
  end

  def teams_changed_email( user, administrator )
    @user, @administrator = user, administrator
    mail( to: user.email, subject: 'SkillsMatrix: your team assignment has changed')
  end
end

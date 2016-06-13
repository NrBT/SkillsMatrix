# Preview all emails at http://localhost:3000/rails/mailers/admin/admin_mailer
class Admin::AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin/admin_mailer/new_registration_email
  def new_registration_email
    Admin::AdminMailer.new_registration_email
  end

end
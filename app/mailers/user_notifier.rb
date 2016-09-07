class UserNotifier < ApplicationMailer
  default :from => '31429620@qq.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    render :text => @user.email_address
    mail( :to => @user.email_address,
    :subject => 'Thanks for signing up for our amazing app' )
  end
end

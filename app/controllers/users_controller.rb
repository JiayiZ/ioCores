class UsersController < ApplicationController
  def main
  end

  def detail
    if session[:current_user_email_address].nil?
      flash[:notice] = 'Please create your account first!'
      redirect_to users_main_path
    end
  end

  def login_main
  end

  def reset_password_main
  end

  def reset_check_email
    user = User.where(params.require(:user).permit(:email_address))
    if user.empty?
      flash[:notice] = "No account under this email address!"
      redirect_to users_reset_password_main_path
    else
      user = User.find_by(params.require(:user).permit(:email_address))
      time = Time.now.getutc
      timestamp = time.to_s
      forKey = user.email_address+timestamp
      key = Digest::MD5.hexdigest(forKey)
      user.key = key
      user.email_sent_date = time
      user.save
      user = User.find_by(params.require(:user).permit(:email_address))
      UserNotifier.send_signup_email(user).deliver_later!
      render :text => "Please check your mail box to set your password."
    end
  end

  def set_password_main
    vars = request.query_parameters
    user = User.where(:key=>vars['key'])
    if user.empty?
      flash[:notice] = 'Please create your account first!'
      redirect_to users_main_path
    else
      session[:current_user_key] = vars['key']
    end
  end

  def set_password
    user = User.find_by(params.require(:user).permit(:key))
    user.password = params.require(:user).permit(:password)[:password]
    time = Time.now.getutc
    timestamp = time.to_s
    forKey = user.email_address+timestamp
    key = Digest::MD5.hexdigest(forKey)
    user.key = key
    user.save
    flash[:notice] = 'Password set Successfully. Please sign in!'
    redirect_to users_login_main_path
  end


  def check_login
    user1 = User.where(params.require(:user).permit(:email_address,:password))
    if user1.empty?
      user = User.find_by(params.require(:user).permit(:email_address))
      if user.nil?
        reset_session
        flash[:notice] = "Email address or password not correct!"
        redirect_to users_login_main_path
      else
        if user.password.nil?
          reset_session
          flash[:notice] = "Please set your password first!"
          redirect_to users_login_main_path
        else
          reset_session
          flash[:notice] = "Email address or password not correct"
          redirect_to users_login_main_path
        end
      end
    else
      render :text => params.require(:user).permit(:email_address,:password)
    end
  end

  def check_email
    user = User.where(params.require(:user).permit(:email_address))
    if user.empty?
      session[:current_user_email_address] = params.require(:user).permit(:email_address)[:email_address]
      redirect_to users_detail_path
    else
      flash[:notice] = "Email address has been used!"
      redirect_to users_main_path
    end
  end

  def create
      time = Time.now.getutc
      timestamp = time.to_s
      forKey = user_params[:email_address]+timestamp
      key = Digest::MD5.hexdigest(forKey)
      @user = User.new(user_params.merge(key: key,email_sent_date:time))
      @user.save
      UserNotifier.send_signup_email(@user).deliver_later!
      reset_session

      render :text => "Please check your mail box to set your password."
  end


  private

    def user_params
      params.require(:user).permit(:email_address,:first_name,:last_name,:company_name)
    end

end

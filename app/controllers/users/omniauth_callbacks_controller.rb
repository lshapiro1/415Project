class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user && @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        email = request.env['omniauth.auth'].info.email
        flash[:warning] = "No user #{email} configured; contact the administrator"
        redirect_to new_user_session_path and return
      end
  end

  def after_sign_in_path_for(u)
    cassoc = u.admin ? Courses.all : u.courses
    cassoc.each do |c|
      # if course is going on now, then return show page path for redirect
      return course_path(c) if c.now?
    end
    courses_path
 end
end

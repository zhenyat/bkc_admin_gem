################################################################################
# Manages Admin user authentication
#
# 10.10.2014  ZT
################################################################################
module AdminAuthentication
  extend ActiveSupport::Concern

  private

  # Checks whether user logged in or redirects to login page
  def check_login
    redirect_to sessions_new_path if session[:user_id].nil? #|| session[:role_id].nil?
  end
end
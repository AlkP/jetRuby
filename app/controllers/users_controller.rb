class UsersController < ApplicationController
  def show_token
    @title = t('.title_show_token')
    @api_token = current_user.guest_token
  end

  def new_token
    @title = t('.title_new_token')
    @api_token = SecureRandom.urlsafe_base64(nil, false)
    user = current_user
    user.guest_token = @api_token
    user.save
  end
end

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url, alert: t('not_have_access')
  end

  private

  def update_sort(name)
    session[name] = {} if session[name].nil?
    if params['sort'] != session[name]['sort']
      session[name] = {}
      session[name]['sort']  = params['sort'].to_sym
      session[name]['index'] = 'asc'
      return
    end
    session[name]['index'] = session[name]['index'] == 'asc' ? 'desc' : 'asc'
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path, :notice => t('not_authenticate')
    end
  end

  def save_log(user, note = nil)
    log = Log.new(user_id: user.id, tcontroller: controller_name, taction: action_name, note: note)
    log.save
  end
end

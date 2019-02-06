class AppApiController < ApplicationController
  before_action :set_variable

  def index
    if @user.present?
      save_log(@user)
      appointments = Appointment.by_user(@user.id).where(state: :confirmed)
      appointments = appointments.by_date(params[:date]) if params[:date].present?
      @response = appointments.to_json
    end
  end

  def new
    if @user.present?
      title, body, app_time = params[:title], params[:body], params[:app_time]
      if title.present? && body.present? && app_time.present?
        appointment = Appointment.new(
                        title: title,
                        body: body,
                        app_time: app_time,
                        state: 0,
                        user_id: @user.id)
        @response = appointment.to_json if appointment.save
        save_log(@user, appointment.id)
      end
    end
  end

  private

  def set_variable
    @response = false
    @user = User.find_by(guest_token: params[:token])
  end
end

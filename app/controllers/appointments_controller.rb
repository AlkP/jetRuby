class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointments, except: [ :new, :create ]
  before_action :check_access, except: [ :index, :new, :create ]

  def index
    update_sort(controller_name) if params['sort'].present?
    appointments = @appointments.without_canceled.sort_by_session(session[controller_name])
    @page = params[:page]
    @appointments = appointments.page(@page)
    authorize @appointments
  end

  def new
    @appointment = Appointment.new
    @appointment.app_time = Time.now + 2.hour + Time.zone_offset(Time.now.zone)
  end

  def create
    @appointment = Appointment.new(appointments_params)
    @appointment.user_id = current_user.id
    @appointment.state = 0
    if @appointment.save
      redirect_to appointments_path
    else
      flash[:danger] = @appointment.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def request_remind
    authorize @appointment
  end

  def create_remind
    authorize @appointment
    _perform_at = appointment.app_time - params[:app_time][:hours].to_i.hours
    AppointmentWorker.perform_at(_perform_at, appointment.id, current_user.email)

    redirect_to appointments_path
  end

  def update
    authorize @appointment
    if @appointments.select_confirmed_near_hour(@appointment.app_time).count == 0
      @appointment.state = :confirmed
      @appointment.save
      flash[:notice] = t('.confirmed')
    else
      flash[:danger] = t('.time_is_busy')
    end
    redirect_to appointments_path
  end

  def destroy
    authorize @appointment
    @appointment.state = :canceled
    @appointment.save
    redirect_to appointments_path
  end

  private

  def appointments_params
    params.require(:appointment).permit( :title, :body, :app_time )
  end

  def set_appointments
    @appointments = policy_scope(Appointment)
  end

  def check_access
    @appointment = @appointments.find_by(id: params[:id])
    redirect_to appointments_path, danger: t('access_denied!') unless @appointment.present?
  end
end

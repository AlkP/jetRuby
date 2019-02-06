class AppointmentWorker
  include Sidekiq::Worker
  def perform(appointment, email)
    AppointmentModule::AppointmentClient.new(appointment, email).send_remind
  end
end
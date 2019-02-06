module AppointmentModule
  class AppointmentClient

    attr_reader :email, :appointment

    def initialize(appointment, email)
      @email = email
      @appointment = Appointment.find(appointment)
    end

    def send_remind
      p 'Напоминание о ' + appointment.title + ' послано на ' + email
    end

  end
end
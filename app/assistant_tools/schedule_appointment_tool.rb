class ScheduleAppointmentTool
  extend Langchain::ToolDefinition

  @tool_name = "schedule_appointment_tool"

  define_function :schedule_appointment, description: "Schedules a new appointment." do
    property :name, type: "string", description: "Name of the person scheduling the appointment", required: true
    property :email, type: "string", description: "Email of the person scheduling the appointment", required: true
    property :start_time, type: "string", description: "UTC formatted timestamp as a string", required: true
  end

  def schedule_appointment(name:, email:, start_time:)
    start_at = Time.parse(start_time)

    Rails.logger.info("#{self.class}: Creating appointment for #{name} at #{start_at}")

    Appointment.create!(
      start_at:,
      end_at: start_at + 15.minutes,
      name:,
      email:
    )

    "Appointment scheduled for #{start_at}."
  end
end

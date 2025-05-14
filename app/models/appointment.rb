class Appointment < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :start_time_must_be_in_future
  validate :end_time_must_be_after_start_time

  private

    def start_time_must_be_in_future
      if start_at.present? && start_at < Time.current
        errors.add(:start_at, "must be in the future")
      end
    end

    def end_time_must_be_after_start_time
      if end_at.present? && end_at <= start_at
        errors.add(:end_at, "must be after the start time")
      end
    end
end

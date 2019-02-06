class Appointment < ApplicationRecord
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :app_time

  paginates_per 10

  enum state: { pending: 0, confirmed: 3, canceled: 10 }

  scope :by_user, -> (user_id) {where(user_id: user_id)}
  scope :without_canceled, -> {where.not(state: :canceled)}
  scope :by_date, -> (date) {where("app_time >= ?", date.to_date.beginning_of_day)
                                 .where("app_time <= ?", date.to_date.end_of_day)}
  scope :select_confirmed_near_hour, -> (datetime) {
                              where("app_time >= ?", datetime - 1.hours)
                              .where("app_time <= ?", datetime + 1.hours)
                              .where(state: :confirmed) }

  def author_of?(obj)
    self&.id == obj&.user_id
  end
end

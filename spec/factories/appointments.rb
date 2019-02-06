FactoryGirl.define do
  factory :appointment do
    title
    body
    state 0
    app_time
    user

    factory :appointment_invalid do
      user nil
    end
  end

end

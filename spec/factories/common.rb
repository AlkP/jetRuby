FactoryGirl.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  sequence(:title) { |n| "Title #{n}" }
  sequence(:body) { |n| "Body #{n}" }
  sequence(:app_time) { Time.now + 2.hours }
end
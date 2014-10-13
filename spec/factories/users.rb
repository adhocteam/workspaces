FactoryGirl.define do
  factory :user do
    provider 'twitter'
    uid '123'
    screen_name 'joeworker'
  end
end
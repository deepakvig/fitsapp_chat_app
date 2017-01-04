FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{ n }@user.com"
    end
    password "password"
  end
end

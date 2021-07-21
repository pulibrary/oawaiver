FactoryGirl.define do
  factory :regular_user, class: Account do
    netid "normal"
  end

  factory :admin_user, class: Account do
    netid "super"
  end

end

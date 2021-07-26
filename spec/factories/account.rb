# frozen_string_literal: true

FactoryGirl.define do
  factory(:account, class: Account) do
    netid "test"
    provider 'cas'
  end

  factory(:regular_user, class: Account) do
    netid 'normal'
    provider 'cas'
  end

  factory(:admin_user, class: Account) do
    netid 'super'
    provider 'cas'
  end
end

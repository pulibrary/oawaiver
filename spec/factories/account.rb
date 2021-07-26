# frozen_string_literal: true

FactoryGirl.define do
  factory(:account, class: Account) do
    netid "test-user"
    provider 'cas'
  end

  factory(:regular_user, class: Account) do
    netid 'normal'
    provider 'cas'
  end

  # This should be removed
  factory(:admin_user, class: Account) do
    netid 'super'
    provider 'cas'
    role 'ADMIN'
  end

  factory(:admin_account, class: Account) do
    netid 'admin'
    provider 'cas'
    role 'ADMIN'
  end
end

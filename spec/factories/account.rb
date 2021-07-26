# frozen_string_literal: true

FactoryBot.define do
  factory(:account, class: Account) do
    netid { "test-user" }
    provider { "cas" }
    role { Account::AUTHENTICATED_ROLE }
  end

  factory(:regular_user, class: Account) do
    netid { "normal" }
    provider { "cas" }
    role { Account::AUTHENTICATED_ROLE }
  end

  # This should be removed
  factory(:admin_user, class: Account) do
    netid { "super" }
    provider { "cas" }
    role { Account::ADMIN_ROLE }
  end

  factory(:admin_account, class: Account) do
    netid { "admin" }
    provider { "cas" }
    role { Account::ADMIN_ROLE }
  end
end

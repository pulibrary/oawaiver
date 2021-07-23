# frozen_string_literal: true

# seed the user table with one admin user

Account.create(netid: admin_user, role: Account::ADMIN_ROLE)

# frozen_string_literal: true

# Seed the user table with one admin user
netid = "#{ENV['$USER']}@princeton.edu"
Account.create(netid: netid, role: Account::ADMIN_ROLE)

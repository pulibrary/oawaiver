# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory(:employee_faked, class: Employee) do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    preferred_name { Faker::Name.last_name }
    unique_id { Faker::Number.number(digits: 9) }
    email { Faker::Internet.email }
    netid { Faker::Internet.user_name }
    department { Faker::Commerce.department }
  end

  factory(:employee) do
    first_name { "Fritz" }
    last_name { "Walter" }
    preferred_name { "Walter Fritz" }
    unique_id { "123456789" }
    email { "walter.fritz@bier.de" }
    netid { "herr.walter" }
    department { "English Sociology" }
  end
end

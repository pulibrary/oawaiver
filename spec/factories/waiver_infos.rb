require 'faker'

FactoryGirl.define do
  factory :waiver_info do
    requester  "normal"
    requester_email  "requester@somewhere.do"
    author_first_name  Faker::Name.first_name
    author_last_name  Faker::Name.last_name

    author_status  "author_status"
    author_department  "department"
    author_email  "some@waivermail.com"
    title  "Some Title"
    journal  "Some Journal"
    notes 'something to say about waivers'
  end

  factory :waiver_info_faculty_author, class: WaiverInfo do
    requester  "super"
    requester_email  "requester_admin@somewhere.do"
    author_first_name  Faker::Name.first_name
    author_last_name  Faker::Name.last_name
    author_status  "author_status"
    author_department  "department"
    author_email  "some@waivermail.com"
    author_unique_id 'author_unique_id'
    title  "Some Title"
    journal  "Some Journal"
  end
end


# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

RSpec.describe WaiverInfo, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:waiver_info)).to be_valid
  end

  %i[author_first_name author_last_name author_email author_department author_status
     title journal requester requester_email].each do |field|
    it("can't create without " + field.to_s) do
      waiver = FactoryBot.build(:waiver_info, field => "")
      expect(waiver.valid?).to eq(false)
      expect(waiver.errors.messages[field]).not_to eq(nil)
    end
  end
  it("can't create for faculty without unique_id") do
    waiver = FactoryBot.build(:waiver_info, author_status: AuthorStatus.StatusFaculty, author_unique_id: nil)
    expect(waiver.valid?).to eq(false)
    expect(waiver.errors.messages[:author_unique_id]).not_to eq(nil)
  end

  %i[journal_issn author_unique_id notes].each do |field|
    it("can create without " + field.to_s) do
      waiver = FactoryBot.build(:waiver_info, field => nil)
      expect(waiver.valid?).to eq(true)
    end
  end

  it("can create for non faculty without unique_id") do
    waiver = FactoryBot.build(:waiver_info, author_status: AuthorStatus.StatusOther, author_unique_id: nil)
    expect(waiver.valid?).to eq(true)
  end

  bad_emails = ["monikam", "zoo@keeper", "farah@.com", "tiger@net.", "@other.edu"]
  bad_emails.each do |email|
    it("can't create with email  ''" + email + "'") do
      waiver = FactoryBot.build(:waiver_info, author_email: email)
      expect(waiver.valid?).to eq(false)
      expect(waiver.errors.messages[:author_email]).not_to eq(nil)
    end

    it("can't create with requester_email ''" + email + "'") do
      waiver = FactoryBot.build(:waiver_info, requester_email: email)
      expect(waiver.valid?).to eq(false)
      expect(waiver.errors.messages[:requester_email]).not_to eq(nil)
    end
  end

  good_id = "123456789"
  it("can create with author_unique_id '" + good_id + "'") do
    waiver = FactoryBot.build(:waiver_info, author_unique_id: good_id)
    expect(waiver.valid?).to eq(true)
  end

  bad_unique_ids = %w[1234-6789 1234567899 12345678 aberdeftg]
  bad_unique_ids.each do |bad_id|
    it("can't create with unique_id '" + bad_id + "'") do
      obj = FactoryBot.build(:waiver_info, author_unique_id: bad_id)
      expect(obj.valid?).to eq(false)
      expect(obj.errors.messages[:author_unique_id]).not_to eq(nil)
    end
  end
end

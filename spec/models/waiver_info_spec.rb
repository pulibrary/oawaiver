# frozen_string_literal: true

require "rails_helper"

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
    waiver = FactoryBot.build(:waiver_info, author_status: AuthorStatus.status_faculty, author_unique_id: nil)
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
    waiver = FactoryBot.build(:waiver_info, author_status: AuthorStatus.status_other, author_unique_id: nil)
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

  describe "#valid_author?" do
    let(:author_unique_id) { "123456789" }
    let(:waiver_info) { FactoryBot.build(:waiver_info, author_unique_id: author_unique_id) }

    it "returns true if the model is valid" do
      expect(waiver_info.valid_author?).to be true
    end

    context "when the author unique ID is invalid" do
      let(:author_unique_id) { "1234-6789" }

      it "returns false" do
        expect(waiver_info.valid_author?).to be false
      end
    end
  end

  describe ".find_by_email" do
    let(:waiver_info) { FactoryBot.create(:waiver_info) }

    it "finds the WaiverInfo using the e-mail address" do
      waiver_info
      waiver_infos = described_class.find_by_email(waiver_info.author_email)
      expect(waiver_infos).not_to be_empty
    end
  end

  describe ".all_with_words" do
    let(:waiver_info) { FactoryBot.create(:waiver_info) }

    it "searches for WaiverInfo models using the :all_word_fields" do
      waiver_info
      waiver_infos = described_class.all_with_words("Some Title")
      expect(waiver_infos).to be_a(Sunspot::Search::StandardSearch)
    end
  end
end

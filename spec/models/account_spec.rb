# frozen_string_literal: true

require "rails_helper"

RSpec.describe Account, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:regular_user)).to be_valid
  end

  field = :netid
  it("can't create without " + field.to_s) do
    user = FactoryBot.build(:regular_user, field => "")
    expect(user.valid?).to eq(false)
    expect(user.errors.messages[field]).not_to eq(nil)
  end

  it("can't create with duplicate netid") do
    user = FactoryBot.build(:regular_user)
    user.save
    expect(described_class.new(netid: user.netid).save).to eq(false)
  end
end

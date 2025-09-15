# frozen_string_literal: true

require "rails_helper"

describe Account, type: :model do
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

  describe ".from_omniauth" do
    let(:access_token) do
      double
    end

    before do
      allow(access_token).to receive(:uid).and_return("jrg5")
      allow(access_token).to receive(:provider).and_return("cas")
    end

    it "constructs and persists a new Account Model from a CAS access token" do
      account = described_class.from_omniauth(access_token)

      expect(account).to be_a(described_class)
      expect(account.role).to eq("LOGGEDIN")
      expect(account.provider).to eq("cas")
      expect(account.uid).to eq("jrg5")
    end

    context "when an invalid access token is used" do
      it "returns a nil value" do
        account = described_class.from_omniauth(nil)

        expect(account).to be_nil
      end
    end
  end

  describe "#roles" do
    let(:account) { FactoryBot.create(:regular_user) }

    it "generates the role for a given user" do
      expect(account.roles).to eq([described_class::AUTHENTICATED_ROLE])
    end

    context "when the user is an admin. user" do
      let(:account) { FactoryBot.create(:admin_user) }

      it "includes the admin role" do
        expect(account.roles).to include(described_class::ADMIN_ROLE)
      end
    end

    context "when no user is specified" do
      let(:account) { described_class.new(netid: nil) }

      it "only includes the anonymous role" do
        expect(account.roles).to include(described_class::ANONYMOUS_ROLE)
      end
    end
  end
end

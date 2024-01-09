# frozen_string_literal: true

require "rails_helper"

describe WaiverMailer, type: :mailer do
  subject(:waiver_mailer) { described_class.new(waiver_info) }

  let(:waiver_info) do
    FactoryBot.create(:waiver_info)
  end

  before(:all) do
    WaiverInfo.all.map(&:destroy)
  end

  after(:all) do
    WaiverInfo.all.map(&:destroy)
  end

  describe "#granted" do
    let(:waiver_mail) { waiver_mailer.granted }

    it "renders the headers" do
      expect(waiver_mail.subject).to eq("Copyright Waiver:  Some Title, Some Journal")

      expect(waiver_mail.to).to be_an(Array)
      expect(waiver_mail.to).to include("requester@somewhere.do")
      expect(waiver_mail.to).to include("author@princeton.edu")

      expect(waiver_mail.from).to be_an(Array)
      expect(waiver_mail.from).to include("noreply@princeton.edu")
    end

    it "renders the body" do
      expect(waiver_mail.body.encoded).to include("To whom it may concern:")
      expect(waiver_mail.body.encoded).to include("'Some Title' in Some Journal")
      expect(waiver_mail.body.encoded).to include("Jennifer Rexford")
    end
  end
end

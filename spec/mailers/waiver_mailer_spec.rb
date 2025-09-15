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

    context "if a CC e-mail address is present" do
      let(:cc_address) { "user1@princeton.edu" }
      let(:waiver_mail) { waiver_mailer.granted(cc_address) }

      it "validates the CC e-mail address and sets the #cc attribute" do
        expect(waiver_mail.cc).to eq([cc_address])
      end
    end
  end

  describe "#url" do
    let(:url) { "http://localhost.localdomain" }

    before do
      described_class.url = url
    end

    it "accesses the URL attribute set by the Class" do
      expect(waiver_mailer.url).to eq(url)
    end
  end

  describe "#waiver_info_url" do
    let(:url) { "http://localhost.localdomain/ID" }

    before do
      described_class.url = url
    end

    it "generates the URL for the WaiverInfo ID" do
      expect(waiver_mailer.waiver_info_url).to eq("http://localhost.localdomain/#{waiver_info.id}")
    end

    context "when the WaiverInfo is nil" do
      let(:waiver_info) { nil }

      it "generates the URL for the WaiverInfo ID" do
        expect(waiver_mailer.waiver_info_url).to be_nil
      end
    end

    context "when the WaiverInfo is nil" do
      let(:waiver_info) { FactoryBot.build(:waiver_info) }

      it "generates the URL for the WaiverInfo ID" do
        expect(waiver_mailer.waiver_info_url).to be_nil
      end
    end
  end
end

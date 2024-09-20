# frozen_string_literal: true
require "rails_helper"

describe WaiverInfoReport do
  subject(:waiver_info_report) { described_class.new(models: models, path: path) }
  let(:models) { WaiverInfo.all }
  let(:path) { "tmp/waiver_info_report.csv" } # supposedly dne

  describe "#generate" do
    let(:waiver_info1) { FactoryBot.create(:waiver_info) }
    let(:waiver_info2) { FactoryBot.create(:waiver_info) }

    before do
      waiver_info1
      waiver_info2
    end

    it "writes the CSV file", retry: 10 do
      waiver_info_report.generate

      expect(File.exist?(path)).to be true
      csv = CSV.open(path, "rb", encoding: "utf-8", headers: true)
      rows = csv.to_a
      expect(rows.length).to eq(2)

      row = rows.first
      expect(row.headers.length).to eq(12)
      expect(row.headers).to include(
        "created_at",
        "updated_at",
        "requester_email",
        "author_first_name",
        "author_last_name",
        "author_status",
        "author_department",
        "author_email",
        "title",
        "journal",
        "journal_issn",
        "notes"
      )

      model = models.first
      created_at = model.created_at
      expect(row["created_at"]).to eq(created_at.to_s)
      updated_at = model.updated_at
      expect(row["updated_at"]).to eq(updated_at.to_s)
      expect(row["requester_email"]).to eq(model.requester_email)
      expect(row["author_first_name"]).to eq(model.author_first_name)
      expect(row["author_last_name"]).to eq(model.author_last_name)
      expect(row["author_status"]).to eq(model.author_status)
      expect(row["author_department"]).to eq(model.author_department)
      expect(row["author_email"]).to eq(model.author_email)
      expect(row["title"]).to eq(model.title)
      expect(row["journal"]).to eq(model.journal)
      expect(row["journal_issn"]).to eq(model.journal_issn)
      expect(row["notes"]).to eq(model.notes)
    end
  end
end

# frozen_string_literal: true

class WaiverInfoReport
  def self.headers
    [
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
    ]
  end

  # rubocop:disable Metrics/MethodLength
  def rows
    @models.map do |model|
      [
        model.created_at,
        model.updated_at,
        model.requester_email,
        model.author_first_name,
        model.author_last_name,
        model.author_status,
        model.author_department,
        model.author_email,
        model.title,
        model.journal,
        model.journal_issn,
        model.notes
      ]
    end
  end
  # rubocop:enable Metrics/MethodLength

  def file_path
    @file_path ||= Pathname.new(@path)
  end

  def generate
    CSV.open(file_path, "wb", encoding: "utf-8") do |csv|
      csv << self.class.headers
      rows.each do |row|
        csv << row
      end
    end
  end

  def initialize(models:, path:)
    @models = models
    @path = path
  end
end

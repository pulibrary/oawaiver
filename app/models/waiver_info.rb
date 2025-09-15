# frozen_string_literal: true

class WaiverInfo < ApplicationRecord
  # USE THIS when searching for all waiver infos
  @@MAX_WAIVER_MATCH = 10_000

  self.per_page = 10

  has_many :mail_records

  # Set the default order to the :created_at attribute
  default_scope { order(created_at: :desc) }

  before_save :lower_case_fields

  validates :requester, :requester_email, presence: true
  validates :author_first_name, :author_last_name, :author_email, :author_status, :author_department, presence: true
  validates_presence_of :title, :journal, presence: true

  validates_format_of :author_email,
                      with: /\b[A-Z0-9._%a-z-]+@(?:[A-Z0-9a-z-]+\.)+[A-Za-z]{2,4}\z/
  validates_format_of :requester_email,
                      with: /\b[A-Z0-9._%a-z-]+@(?:[A-Z0-9a-z-]+\.)+[A-Za-z]{2,4}\z/

  validates_format_of :cc_email,
                      with: /\b[A-Z0-9._%a-z-]+@(?:[A-Z0-9a-z-]+\.)+[A-Za-z]{2,4}\z/,
                      allow_nil: true

  validates_format_of :author_unique_id,
                      with: /\b\d{9}\z/,
                      message: "id must be 9 digits",
                      allow_nil: true

  validates :author_unique_id, presence: true, if: :faculty?

  attr_accessor :author_preferred_name, :cc_email

  # not stored to db - used in waiver_infos/_edit_form; # not stored to db - used in waiver_infos/_edit_form

  # store requester, requester_email, and author_email in lower case
  def lower_case_fields
    self.author_email = author_email.downcase
    self.requester = requester.downcase
    self.requester_email = requester_email.downcase
  end

  def valid_author?
    return true if valid?

    error_messages = errors.messages
    author_keys = error_messages.keys.select { |key| key.to_s.include?("author_") }

    author_keys.empty?
  end

  def faculty?
    AuthorStatus.faculty_status?(author_status)
  end

  def legacy?
    mail_records.none?
  end

  def self.find_by_email(email)
    email = email.downcase
    where("requester_email = ? OR author_email = ?", email, email)
  end

  def self.find_by_missing_unique_id
    where(author_unique_id: nil)
  end

  def citation
    "#{title}, #{journal}, #{author_last_name}, #{author_first_name}"
  end

  def mail_records
    values = super
    return [] if values.nil?

    values
  end

  # ---------------------
  # Search/Solr
  # ---------------------
  def all_word_fields
    [citation, author_department, notes]
  end

  def unique_title
    "#{title} #{id}"
  end

  def unique_author
    "#{author_last_name} #{id}"
  end

  searchable do
    text :all_word_fields, stored: true
    string :author_last_name, stored: true
    string :unique_title, multiple: false, stored: true
    string :unique_author, multiple: false, stored: true
  end

  # search for employees with a matching first, last or preferred_name
  # return Sunspot::Search object
  def self.all_with_words(words)
    search_with_words(words, nil, @@MAX_WAIVER_MATCH)
  end

  # search for employees with a matching first, last or preferred_name
  # return Sunspot::Search object
  def self.search_with_words(words, page, per_page)
    per_page ||= self.per_page
    WaiverInfo.search do
      fulltext words, fields: [:all_word_fields]
      order_by :author_last_name
      paginate page: page, per_page: per_page
    end
  end
end

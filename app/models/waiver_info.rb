class WaiverInfo < ActiveRecord::Base
  # USE THIS when searching for all waiver infos
  @@MAX_WAIVER_MATCH = 10000
  self.per_page = 10

  has_many :mail_records

  default_scope { order('created_at DESC') }

  before_save :lower_case_fields

  validates :requester, :requester_email, presence: true
  validates :author_first_name, :author_last_name, :author_email, :author_status, :author_department, presence: true
  validates_presence_of :title, :journal, presence: true

  validates_format_of :author_email,
                      :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  validates_format_of :requester_email,
                      :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  validates_format_of :cc_email,
                      :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/,
                      :allow_nil => true

  validates_format_of :author_unique_id,
                      :with  => /\b\d{9}\z/,
                      :message  => "id must be 9 digits",
                      :allow_nil => true

  validates :author_unique_id, presence: true, if: :faculty?

  attr_accessor :author_preferred_name; # not stored to db - used in waiver_infos/_edit_form
  attr_accessor :cc_email; # not stored to db - used in waiver_infos/_edit_form

  # store requester, requester_email, and author_email in lower case
  def lower_case_fields
    self.author_email = self.author_email.downcase
    self.requester = self.requester.downcase
    self.requester_email = self.requester_email.downcase
  end

  def valid_author?
    return true if valid?

    # check that none of the author_fields are in the errors list
    ms = self.errors.messages
    return false if ms.has_key?(:author_last_name)
    return false if ms.has_key?(:author_first_name)
    return false if ms.has_key?(:author_department)
    return false if ms.has_key?(:author_status)
    return false if ms.has_key?(:author_email)
    return true;
  end

  def faculty?
    AuthorStatus.StatusFaculty == self.author_status
  end

  def legacy?
    not mail_records.any?
  end

  def self.find_by_email(email)
     email = email.downcase;
     where("requester_email = ? OR author_email = ?",  email, email)
  end

  def self.find_by_missing_unique_id
    where(author_unique_id: nil)
  end

  def citation
    return "#{title}, #{journal}, #{author_last_name}, #{author_first_name}"
  end

  def self.AuthorStatusList
    return self.select(:author_status).uniq.collect{|a| a.author_status }
  end

  # ---------------------
  # search/solr
  # ---------------------
  def all_word_fields
    return [self.citation, self.author_department, self.notes]
  end

  def unique_title
    return "#{title} #{id}"
  end

  def unique_author
    return "#{author_last_name} #{id}"
  end

  searchable do
    text :all_word_fields, :stored => true
    string :author_last_name, :stored => true
    string :unique_title, :multiple => false, :stored => true
    string :unique_author, :multiple => false, :stored => true
  end

  # search for employees with a matching first, last or preferred_name
  # return Sunspot::Search object
  def self.all_with_words(words)
   return search_with_words(words, nil, @@MAX_WAIVER_MATCH)
  end

  # search for employees with a matching first, last or preferred_name
  # return Sunspot::Search object
  def self.search_with_words(words, page, per_page)
    per_page ||= self.per_page
    s = WaiverInfo.search do
      fulltext words, :fields => [:all_word_fields]
      order_by :author_last_name
      paginate :page => page, :per_page => per_page
    end
    return s
  end

end

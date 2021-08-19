# frozen_string_literal: true

class WaiverMailer < ApplicationMailer
  # return boolean indicating whether to use an author's real email address when creating mail messages
  def self.mail_to_authors
    bootstrap
    @@GLOBALS[:send_to_author]
  end

  def self.contact
    bootstrap
    @@GLOBALS[:contact]
  end

  # test whether str conforms to the email format
  def self.validEmail(str)
    /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ =~ str
  end

  # initialize global variables based on Rails.application.config.waiver_mailer_parameters hash
  #
  # see  config/waiver_mail.rb
  def self.bootstrap
    return @@GLOBALS if defined? @@GLOBALS

    options = Rails.application.config.waiver_mailer_parameters

    @@GLOBALS = { mail_templates: {} }

    env_opts = options[Rails.env] || {}

    @@GLOBALS[:url] = env_opts["url"] || ""

    @@GLOBALS[:from] = env_opts["from"] || ""
    addresses = Mail::FromField.new(@@GLOBALS[:from])
    invalidEmails = addresses.addresses.reject { |e| validEmail(e) }
    raise "from contains invalid email #{invalidEmails}" unless invalidEmails.empty?

    @@GLOBALS[:reply_to] = env_opts["reply_to"] || ""
    addresses = Mail::ReplyToField.new(@@GLOBALS[:reply_to])
    invalidEmails = addresses.addresses.reject { |e| validEmail(e) }
    raise "reply_to contains invalid email #{invalidEmails}" unless invalidEmails.empty?

    @@GLOBALS[:bcc] = env_opts["bcc"] || ""
    addresses = Mail::BccField.new(@@GLOBALS[:bcc])
    invalidEmails = addresses.addresses.reject { |e| validEmail(e) }
    raise "bcc contains invalid emails: #{invalidEmails}" unless invalidEmails.empty?

    @@GLOBALS[:send_to_author] = env_opts["send_to_author"]

    mail_templates = options["mail_templates"] || {}
    ["granted"].each do |key|
      raise "must define a '#{key}' mail template" if mail_templates[key].nil?
    end
    mail_templates.keys.each do |key|
      @@GLOBALS[:mail_templates][key.to_sym] = {}
      %w[body subject].each do |part|
        fname = mail_templates[key][part]
        raise "must define #{part} for #{key} mail template" if fname.blank?

        template = File.read("#{::Rails.root}/config/#{fname}")
        raise "The file #{::Rails.root}/config/#{fname} is empty" if template.empty?

        @@GLOBALS[:mail_templates][key.to_sym][part.to_sym] = ERB.new(template.strip)
      end
    end

    ActiveRecord::Base.logger.info("WaiverMailer.Initialize")

    nil
  end

  # create WaiverMail from given waiver_info
  def initialize(waiver_info)
    @waiver_info = waiver_info
    super()
  end

  def self.default_author_email
    "author@princeton.edu"
  end

  def author_email
    return @waiver_info.author_email if @@GLOBALS[:send_to_author]

    self.class.default_author_email
  end

  # compute to field for mail
  # depending on mail_to_authors use "author@princeton.edu" or waiver_info's author_email
  def to
    [@waiver_info.requester_email, author_email]
  end

  def url
    @url ||= @@GLOBALS[:url]
  end

  def waiver_info_id
    @waiver_info.id
  end

  def waiver_info_url
    @waiver_info_url ||= url.sub(/ID/, waiver_info_id.to_s)
  end

  def mail_templates
    @mail_templates ||= @@GLOBALS[:mail_templates]
  end

  def granted_mail_template
    return unless mail_templates

    @granted_mail_template ||= mail_templates[:granted]
  end

  def body_template
    return unless granted_mail_template.key?(:body)

    @body_template ||= granted_mail_template[:body]
  end

  def body
    @body ||= body_template.result(binding)
  end

  def subject_template
    return unless granted_mail_template.key?(:subject)

    @subject_template ||= granted_mail_template[:subject]
  end

  def subject
    @subject ||= subject_template.result(binding)
  end

  def from
    @from ||= @@GLOBALS[:from]
  end

  def reply_to
    @reply_to ||= @@GLOBALS[:reply_to]
  end

  def bcc
    @bcc ||= @@GLOBALS[:bcc]
  end

  def cc
    return [] if @cc.blank?
    raise("Invalid email '#{@cc}'") unless self.class.validEmail(@cc)

    @cc
  end

  def granted(cc_address = nil)
    self.class.bootstrap
    @cc = cc_address

    mail(
      to: to,
      from: from,
      reply_to: reply_to,
      cc: cc,
      bcc: bcc,
      subject: subject,
      body: body
    )
  end

  # create and return Mail from the granted mail template by inserting the values
  # from waiver_mail
end

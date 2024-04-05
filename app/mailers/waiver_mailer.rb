# frozen_string_literal: true

class WaiverMailer < ApplicationMailer
  class_attribute :initialized, default: false
  class_attribute :parameters
  class_attribute :options
  class_attribute :url
  class_attribute :from
  class_attribute :reply_to
  class_attribute :cc
  class_attribute :bcc
  class_attribute :send_to_author
  class_attribute :mail_templates

  def self.validate_email(address)
    valid = URI::MailTo::EMAIL_REGEXP.match(address)

    raise("Invalid email address: '#{address}'") unless valid
    valid
  end

  # initialize global variables based on Rails.application.config.waiver_mailer_parameters hash
  def self.bootstrap
    return if initialized

    parameters = Rails.application.config.waiver_mailer_parameters
    self.parameters = ActiveSupport::HashWithIndifferentAccess.new(parameters)
    env = self.parameters.fetch(Rails.env)
    self.options = ActiveSupport::HashWithIndifferentAccess.new(env)

    self.url = options.fetch("url", "")
    self.from = options.fetch("from", "")

    from_entries = Mail::FromField.new(from)
    from_entries.addresses.each { |e| validate_email(e) }

    self.reply_to = options.fetch("reply_to", "")
    reply_to_entries = Mail::ReplyToField.new(reply_to)
    reply_to_entries.addresses.each { |e| validate_email(e) }

    self.cc = options.fetch("cc", "")
    cc_entries = Mail::CcField.new(cc)
    cc_entries.addresses.each { |e| validate_email(e) }

    self.bcc = options.fetch("bcc", "")
    bcc_entries = Mail::BccField.new(bcc)
    bcc_entries.addresses.each { |e| validate_email(e) }

    self.send_to_author = options.fetch("send_to_author", "")

    mail_templates = parameters.fetch("mail_templates")
    raise("Failed to resolve the e-mail templates for: #{parameters}") if mail_templates.blank?

    mail_templates = ActiveSupport::HashWithIndifferentAccess.new(mail_templates)
    self.mail_templates = mail_templates

    required_keys = ["granted"]
    required_keys.each do |key|
      raise("Must define a '#{key}' mail template") unless mail_templates.key?(key)
    end

    self.mail_templates.keys.each do |k|
      key = k.to_sym

      parts = %w[body subject]
      parts.each do |part|
        fname = self.mail_templates[k][part]
        raise("Must define #{part} for #{key} mail template") if fname.blank?

        template_path = Rails.application.root.join("config", fname)
        template = File.read(template_path)
        raise("The file #{template_path} is empty") if template.empty?

        part_key = part.to_sym
        partial = ERB.new(template.strip)
        self.mail_templates[k][part_key] = partial
      end
    end

    self.initialized = true
    ActiveRecord::Base.logger.info("WaiverMailer has been initialized.")

    self
  end

  def self.default_author_email
    "author@princeton.edu"
  end

  # create WaiverMail from given waiver_info
  def initialize(waiver_info)
    self.class.bootstrap
    @waiver_info = waiver_info

    super()
  end

  def author_email
    return @waiver_info.author_email if self.class.send_to_author

    self.class.default_author_email
  end

  # compute to field for mail
  # depending on mail_to_authors use "author@princeton.edu" or waiver_info's author_email
  def to
    [
      @waiver_info.requester_email,
      author_email
    ]
  end

  def url
    @url ||= self.class.url
  end

  def waiver_info_url
    return if @waiver_info.nil? || !@waiver_info.persisted?

    @waiver_info_url ||= begin
                           pattern = /ID/
                           model_id = waiver_info.id
                           value = url.sub(pattern, model_id.to_s)
                           value
                         end
  end

  def mail_templates
    @mail_templates ||= self.class.mail_templates
  end

  def granted_mail_template
    raise("No \"granted\" template is specified within the e-mail templates: #{mail_templates}") unless mail_templates.key?(:granted)

    @granted_mail_template ||= mail_templates[:granted]
  end

  def body_template
    return unless granted_mail_template.key?(:body)

    @body_template ||= granted_mail_template[:body]
  end

  def body
    return if body_template.nil?

    @body ||= body_template.result(binding)
  end

  def subject_template
    raise("No subject header specified within the e-mail template: #{granted_mail_template}") unless granted_mail_template.key?(:subject)

    @subject_template ||= granted_mail_template[:subject]
  end

  def subject
    return if subject_template.nil?

    @subject ||= subject_template.result(binding)
  end

  def from
    @from ||= self.class.from
  end

  def reply_to
    @reply_to ||= self.class.reply_to
  end

  def bcc
    @bcc ||= self.class.bcc
  end

  def cc
    @cc ||= self.class.cc
  end

  def granted(cc_address = nil)
    # self.class.bootstrap

    # @cc = cc_address if cc_address.present?
    if cc_address.present?
      self.class.validate_email(cc_address)
      @cc = cc_address
    end

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
end

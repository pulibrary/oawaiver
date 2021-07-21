# frozen_string_literal: true

class WaiverMailer
  # return boolean indicating whether to use an author's real email address when creating mail messages
  def self.mail_to_authors
    self.Bootstrap()
    @@GLOBALS[:send_to_author]
  end

  def self.contact
    self.Bootstrap()
    @@GLOBALS[:contact]
  end

  # test whether str conforms to the email format
  def self.validEmail(str)
    /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ =~ str
  end

  # initialize global variables based on Rails.application.config.waiver_mailer_parameters hash
  #
  # see  config/waiver_mail.rb
  def self.Bootstrap
    return @@GLOBALS if defined? @@GLOBALS

    options = Rails.application.config.waiver_mailer_parameters

    @@GLOBALS = { mail_templates: {} }

    env_opts = options[Rails.env] || {}

    @@GLOBALS[:url] = env_opts['url'] || ''

    @@GLOBALS[:from] = env_opts['from'] || ''
    addresses = Mail::FromField.new(@@GLOBALS[:from])
    invalidEmails = addresses.addresses.reject { |e| validEmail(e) }
    raise "from contains invalid email #{invalidEmails}" unless invalidEmails.empty?

    @@GLOBALS[:reply_to] = env_opts['reply_to'] || ''
    addresses = Mail::ReplyToField.new(@@GLOBALS[:reply_to])
    invalidEmails = addresses.addresses.reject { |e| validEmail(e) }
    raise "reply_to contains invalid email #{invalidEmails}" unless invalidEmails.empty?

    @@GLOBALS[:bcc] = env_opts['bcc'] || ''
    addresses = Mail::BccField.new(@@GLOBALS[:bcc])
    invalidEmails = addresses.addresses.reject { |e| validEmail(e) }
    raise "bcc contains invalid emails: #{invalidEmails}" unless invalidEmails.empty?

    @@GLOBALS[:send_to_author] = env_opts['send_to_author']

    mail_templates = options['mail_templates'] || {}
    ['granted'].each do |key|
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

    ActiveRecord::Base.logger.info('WaiverMailer.Initialize')

    nil
  end

  # create WaiverMail from given waiver_info
  def initialize(waiver_info)
    @waiver_info = waiver_info
  end

  # compute to field for mail
  # depending on mail_to_authors use "author@princeton.edu" or waiver_info's author_email
  def compute_to
    if @@GLOBALS[:send_to_author]
      [@waiver_info.requester_email, @waiver_info.author_email]
    else
      [@waiver_info.requester_email, 'author@princeton.edu']
    end
  end

  # create and return Mail from the granted mail template by inserting the values
  # from waiver_mail
  def granted(cc_or_nil)
    WaiverMailer.Bootstrap()
    @url = @@GLOBALS[:url]
    @waiver_info_url = @url.sub(/ID/, @waiver_info.id.to_s)
    body = @@GLOBALS[:mail_templates][:granted][:body]
    subject = @@GLOBALS[:mail_templates][:granted][:subject]
    sendmail = Mail.new(
      from: @@GLOBALS[:from],
      reply_to: @@GLOBALS[:reply_to],
      to: compute_to,
      subject: subject.result(binding),
      body: body.result(binding)
    )
    sendmail.bcc = @@GLOBALS[:bcc] if @@GLOBALS[:bcc]
    sendmail.cc  []
    if cc_or_nil.present?
      raise "Invalid email '#{cc_or_nil}'" unless WaiverMailer.validEmail(cc_or_nil)

      sendmail.cc = cc_or_nil
    end
    sendmail
  end
end

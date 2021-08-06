# frozen_string_literal: true

class MailRecord < ApplicationRecord
  belongs_to :waiver_info

  validates_presence_of :waiver_info
  validates_presence_of :blob
  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :mime_type
  validates_presence_of :date
  validates_presence_of :message_id

  def self.new_from_mail(mail)
    record = MailRecord.new(
      blob: mail.to_s,
      subject: mail.subject,
      body: mail.body.to_s,
      mime_type: mail.mime_type,
      date: mail.date,
      message_id: mail.message_id
    )
    record.to = mail.to.join(",") if mail.to
    record.cc = mail.cc.join(",") if mail.cc
    record.bcc = mail.bcc.join(",") if mail.bcc
    record
  end

  def recipients
    tos = to.split(",")
    tos = tos.append(cc) if cc.present?
    tos.uniq
  end
end

# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory(:mail_record) do
    message_id { "61200133513c_146e05b59069759@PU-C02FH0TAMD6V.mail" }
    date { "2021-08-20T15:23:31-04:00" }
    to { "recipient@princeton.edu" }
    cc { "user1@princeton.edu" }
    bcc { "user2@princeton.edu" }
    subject { "Test Subject" }
    body { "Test Body" }
    mime_type { "text/plain" }
    blob { "Test Blob" }
  end
end

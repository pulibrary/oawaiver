# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, :data
  policy.img_src     :self, :https, :data
  policy.object_src  :none
  policy.script_src  :self, :https, :http
  policy.style_src(
    :self,
    :https,
    :http,
    "'sha256-CwE3Bg0VYQOIdNAkbB/Btdkhul49qZuwgNCMPgNY5zw='",
    "'sha256-MZKTI0Eg1N13tshpFaVW65co/LeICXq4hyVx6GWVlK0='",
    "'sha256-LpfmXS+4ZtL2uPRZgkoR29Ghbxcfime/CsD/4w5VujE='",
    "'sha256-YJO/M9OgDKEBRKGqp4Zd07dzlagbB+qmKgThG52u/Mk='"
  )

  # If you are using webpack-dev-server then specify webpack-dev-server host
  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true

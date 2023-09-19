# frozen_string_literal: true

set :rails_env, "production"

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server "oawaiver-prod2.princeton.edu", user: "deploy", roles: %w[app db web]

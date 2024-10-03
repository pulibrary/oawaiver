# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Health Check", type: :request do
  describe "GET /health" do
    context "when the service is up" do
      before do
        url = Sunspot.config.solr.url
        uri = URI(url)

        response_body = {
          responseHeader: { status: 0 }
        }
        stub_request(:get, "#{uri.scheme}://#{uri.hostname}:#{uri.port}/solr/admin/cores?action=STATUS").to_return(status: 200, body: response_body.to_json)
      end

      it "has a health check" do
        get "/health.json"

        expect(response).to be_successful
      end
    end

    context "when the service is down" do
      before do
        url = Sunspot.config.solr.url
        uri = URI(url)

        response_body = {
          responseHeader: { status: 500 }
        }
        stub_request(:get, "#{uri.scheme}://#{uri.hostname}:#{uri.port}/solr/admin/cores?action=STATUS").to_return(status: 200, body: response_body.to_json)
      end

      it "errors when a service is down" do
        get "/health.json"

        expect(response).not_to be_successful
        expect(response.status).to eq 503
        json_response = JSON.parse(response.body)
        results = json_response["results"]
        solr_response = results.find { |x| x["name"] == "Solr" }
        expect(solr_response["message"]).to start_with "The solr has an invalid status"
      end
    end
  end
end

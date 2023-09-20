# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:regular_user) { FactoryBot.create(:regular_user) }

  describe "#start" do
    it "responds successfully with an HTTP 200 status code" do
      get(:start)

      expect(response).to have_http_status(200)
    end

    context "when authenticated as an administrative user" do
      before do
        sign_in(admin_user)
      end

      it "responds successfully with an HTTP 200 status code" do
        get(:start)

        expect(response).to have_http_status(200)
      end

      it "renders the start template" do
        get :start

        expect(response).to render_template("start")
      end
    end
  end

  describe "#author_search_status" do
    let(:redirect_location) { AuthorStatus.status_url(context: self) }

    context "when authenticated as an administrative user" do
      it "responds successfully with an HTTP 200 status code" do
        get :author_search_status

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(redirect_location)
      end
    end
  end

  describe "#manage" do
    it "fail without authentication" do
      get :manage
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated as an administrative user" do
      let(:accounts) do
        Account.where(netid: admin_user.netid)
      end

      before do
        sign_in(admin_user)
      end

      it "assigns all accounts as @accounts" do
        get :manage
        expect(assigns(:accounts)).to eq(accounts)
      end
    end
  end
end

require "rails_helper"
require 'json'

RSpec.describe ApplicationController, :type => :controller do
  before (:all) do
    FactoryGirl.build(:admin_user).save
    FactoryGirl.build(:regular_user).save
  end

  after (:all) do
    Account.delete_all
  end

  def authenticate_with(user)
    Waiver::Authentication.set_authorized_user(session, FactoryGirl.build(user).netid)
  end

  describe "GET #start" do
    it "responds successfully with an HTTP 200 status code" do
      get :start
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the start template" do
      get :start
      expect(response).to render_template("start")
    end
  end

  describe "GET #author_search_status" do
    it "responds successfully with an HTTP 200 status code" do
      get :author_search_status
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(AuthorStatus.StatusUrl)
    end
  end

  describe "GET account_index" do
    it "fail without authentication" do
      get :manage
      expect(response).to have_http_status(403)
    end
    it "assigns all accounts as @accounts" do
      authenticate_with(:admin_user);
      accounts = Account.where("netid != ?", FactoryGirl.build(:admin_user).netid)
      get :manage
      expect(assigns(:accounts)).to eq(accounts)
    end
  end

end

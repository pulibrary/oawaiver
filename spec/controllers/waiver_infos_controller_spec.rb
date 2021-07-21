# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe WaiverInfosController, type: :controller do
  before(:all) do
    FactoryGirl.build(:admin_user).save
    FactoryGirl.build(:waiver_info).save
    FactoryGirl.build(:waiver_info_faculty_author).save
  end

  after(:all) do
    WaiverInfo.delete_all
    Account.delete_all
  end

  def authenticate_with(user)
    Waiver::Authentication.set_authorized_user(session, FactoryGirl.build(user).netid)
  end

  describe 'quick fail authentication' do
    [
      ['index', {}],
      ['index_mine', {}],
      ['index_unique_id', { author_unique_id: 'does-not-matter' }],
      ['index_missing_unique_ids', {}],
      ['search', {}],
      ['new', {}],
      ['edit_by_admin', { id: 'doesnotmatter' }],
      ['show', { id: 'doesnotmatter' }],
      ['show_mail', { id: 'doesnotmatter' }]
    ].each do |action, params|
      it "GET #{action} params #{params} -> redirect" do
        get action, params
        expect(response).to have_http_status(:redirect)
        expect(response.location.start_with?('https://fed.princeton.edu/cas/login')).to be true
      end
    end

    %w[new create search].each do |action|
      it "POST #{action} -> redirect" do
        post action
        expect(response).to have_http_status(:redirect)
        expect(response.location.start_with?('https://fed.princeton.edu/cas/login')).to be true
      end
      it "POST #{action}.json -> unauthorized" do
        post action, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'check users authentication' do
    [['index', {}],
     ['index_unique_id', { author_unique_id: 'whatever' }],
     ['index_missing_unique_ids', {}],
     ['edit_by_admin', { id: 'doesnotmatter' }]].each do |action, params|
      it "GET #{action} params #{params} @user=#{FactoryGirl.build(:regular_user)} -> not success" do
        authenticate_with(:regular_user)
        get action, params
        expect(response).not_to have_http_status(:success)
      end
    end

    %w[show show_mail].each do |action|
      [[:admin_user, 'anybody', 'respond with waiver_info', :success],
       [:regular_user, "not#{FactoryGirl.build(:regular_user).netid}", 'forbidden', :forbidden],
       [:regular_user, FactoryGirl.build(:regular_user).netid, 'respond with waiver_info', :success]].each do |user, requester, it_description, result|
        it "GET #{action} waiver_info.requester=#{requester}\t@user=#{user} \t=> #{it_description}" do
          authenticate_with(user)
          waiver = FactoryGirl.build(:waiver_info, requester: requester)
          waiver.save
          get action, id: waiver.id
          expect(response).to have_http_status(result)
          expect(response).to render_template(action) if result == :success
        end
      end
    end

    action = 'edit_by_admin'
    [[:admin_user, 'anybody', 'respond with waiver_info', :success],
     [:regular_user, 'anybody', 'forbidden', :forbidden]].each do |user, requester, it_description, result|
      it "GET #{action} waiver_info.requester=#{requester}\t@user=#{user} \t=> #{it_description}" do
        authenticate_with(user)
        waiver = FactoryGirl.build(:waiver_info, requester: requester)
        waiver.save
        get action, id: waiver.id
        expect(response).to have_http_status(result)
        expect(response).to render_template(action) if result == :success
      end
    end
  end

  describe 'GET json' do
    # json requests from localhost/ALLOWEDIPS are automatically logged in

    it 'GET index -> success' do
      get 'index', format: :json
      expect(response).to have_http_status(:success)
    end
    it 'GET index -> forbidden' do
      default = Waiver::Authentication.set_allowed_ips('8.8.8.8')
      get 'index', format: :json
      expect(response).not_to have_http_status(:success)
      Waiver::Authentication.set_allowed_ips(default)
    end
    it 'GET index_unique_id  -> success' do
      get 'index_unique_id', author_unique_id: FactoryGirl.build(:waiver_info_faculty_author).author_unique_id, format: :json
      expect(response).to have_http_status(:success)
    end
    it 'GET index_unique_id  -> forbidden' do
      default = Waiver::Authentication.set_allowed_ips('8.8.8.8')
      get 'index_unique_id', author_unique_id: FactoryGirl.build(:waiver_info_faculty_author).author_unique_id, format: :json
      expect(response).not_to have_http_status(:success)
      Waiver::Authentication.set_allowed_ips(default)
    end
    it 'GET index_missing_unique_ids  -> success' do
      get 'index_missing_unique_ids', format: :json
      expect(response).to have_http_status(:success)
    end
    it 'GET index_missing_unique_ids  -> forbidden' do
      default = Waiver::Authentication.set_allowed_ips('8.8.8.8')
      get 'index_missing_unique_ids', format: :json
      expect(response).not_to have_http_status(:success)
      Waiver::Authentication.set_allowed_ips(default)
    end
  end
end

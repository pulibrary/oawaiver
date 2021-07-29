# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe WaiverInfosController, type: :controller do
  let(:waiver) { FactoryGirl.create(:waiver_info, requester: requester) }
  let(:author_waiver) { FactoryGirl.create(:waiver_info_faculty_author) }
  let(:user) { FactoryGirl.create(:regular_user) }
  let(:admin_user) { FactoryGirl.create(:admin_user) }
  let(:requester) { FactoryGirl.create(:regular_user, netid: 'requester') }

  before do
    WaiverInfo.delete_all
    Account.delete_all
  end

  after do
    WaiverInfo.delete_all
    Account.delete_all
  end

  # Merge this
  describe '#index' do
    let(:params) do
      {}
    end

    before do
      get(:index, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#index_mine' do
    let(:params) do
      {}
    end

    before do
      get(:index_mine, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#index_unique_id' do
    let(:params) do
      {
        author_unique_id: 'does-not-matter'
      }
    end

    before do
      get(:index_unique_id, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#index_missing_unique_ids' do
    let(:params) do
      {}
    end

    before do
      get(:index_missing_unique_ids, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#search' do
    let(:params) do
      {}
    end

    before do
      get(:search, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#new' do
    let(:params) do
      {}
    end

    before do
      get(:new, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#edit_by_admin' do
    let(:params) do
      {
        author_unique_id: 'does-not-matter',
        use_route: 'admins/waiver_infos'
      }
    end

    before do
      get(:edit_by_admin, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show' do
    let(:params) do
      {
        use_route: 'waiver_infos'

      }
    end

    before do
      get(:show, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show_mail' do
    let(:params) do
      {
        use_route: 'admins/waiver_infos'
      }
    end

    before do
      get(:show_mail, params: params)
    end

    it "redirects for failed authentication attempts" do
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "#index" do
    it "redirects for failed authentication attempts" do
      get :index

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'while authenticated as an admin. user' do
      before do
        sign_in(user)
      end

      let(:params) do
        {}
      end

      it 'retrieves all waivers' do
        get :index
        expect(response).to have_http_status(:success)
      end

      context 'when requesting a unique author ID' do
        let(:params) do
          {
            author_unique_id: 'whatever'
          }
        end

        it 'retrieves all waivers with the unique author ID' do
          get :index, params: params
          expect(response).to have_http_status(:success)
        end
      end

      context 'when requesting JSON responses' do
        describe '#index' do
          it 'retrieves all waivers' do
            get 'index', format: :json

            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end

  describe "#index_unique_id" do
    let(:params) do
      {
        author_unique_id: 'does-not-matter',
        use_route: 'admins/waiver_infos'
      }
    end

    it "redirects for failed authentication attempts" do
      get :index_unique_id, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated' do
      before do
        sign_in(user)
      end

      it 'retrieves all waivers' do
        get :index_unique_id, params: params
        expect(response).to have_http_status(:success)
      end

      context 'when requesting a unique author ID' do
        let(:params) do
          {
            author_unique_id: 'whatever',
            use_route: 'admins/waiver_infos'
          }
        end

        it 'retrieves all waivers for a given unique ID' do
          get :index_unique_id, params: params
          expect(response).to have_http_status(:success)
        end

        context 'when requesting JSON responses' do
          it 'retrieves all waivers for a unique ID' do
            get :index_unique_id, params: { author_unique_id: author_waiver.author_unique_id, format: :json }
            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end

  describe "#index_missing_unique_ids" do
    let(:params) do
      {
        use_route: 'admins/waiver_infos'
      }
    end

    it "redirects for failed authentication attempts" do
      get :index_missing_unique_ids, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when requesting a unique author ID' do
      let(:params) do
        {
          author_unique_id: 'whatever',
          use_route: 'admins/waiver_infos'
        }
      end

      context 'when authenticated' do
        before do
          sign_in(user)
        end

        it 'retrieves all waivers' do
          get :index_missing_unique_ids, params: params
          expect(response).to have_http_status(:success)
        end

        context 'when requesting JSON responses' do
          it 'retrieves all waivers without a unique ID' do
            get :index_missing_unique_ids, format: :json, params: params

            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end

  describe "#edit_by_admin" do
    let(:params) do
      {
        id: 'doesnotmatter',
        use_route: 'admins/waiver_infos'
      }
    end

    it "redirects for failed authentication attempts" do
      get :edit_by_admin, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when requesting a unique author ID' do
      let(:params) do
        {
          author_unique_id: 'whatever',
          use_route: 'admins/waiver_infos'
        }
      end

      it 'retrieves all waivers' do
        get :edit_by_admin, params: params
        expect(response).not_to have_http_status(:success)
      end
    end
  end

  describe "#show" do
    it "does not retrieve the waiver info" do
      get :show, params: { id: waiver.id }

      # expect(response).to have_http_status(:forbidden)
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated as an admin. user' do
      before do
        sign_in(admin_user)
      end

      it "retrieves the waiver info." do
        get :show, params: { id: waiver.id }

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
    end
  end

  describe "#show_mail" do
    it "does not retrieve the waiver info" do
      get :show_mail, params: { id: waiver.id }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated as an admin. user' do
      before do
        sign_in(admin_user)
      end

      it "retrieves the waiver info" do
        get :show_mail, params: { id: waiver.id }

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show_mail)
      end
    end
  end

  describe '#edit_by_admin' do
    let(:params) do
      {
        use_route: 'admins/waiver_infos'
      }
    end

    it "redirects for failed authentication attempts" do
      get :edit_by_admin, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated as an admin user' do
      let(:params) do
        {
          use_route: 'admins/waiver_infos',
          id: waiver.id
        }
      end

      before do
        sign_in(admin_user)
      end

      it 'renders the template' do
        get(:edit_by_admin, params: params)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit_by_admin)
      end
    end

    context 'when authenticated as a non-admin user' do
      before do
        sign_in(user)
      end

      it 'denies access to the route' do
        get :edit_by_admin, params: { id: waiver.id }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  #     action = 'edit_by_admin'
  #     [[:admin_user, 'anybody', 'respond with waiver_info', :success],
  #      [:regular_user, 'anybody', 'forbidden', :forbidden]].each do |user, requester, it_description, result|
  #       it "GET #{action} waiver_info.requester=#{requester}\t@user=#{user} \t=> #{it_description}" do
  #         get action, params: { id: waiver.id }
  #         expect(response).to have_http_status(result)
  #         expect(response).to render_template(action) if result == :success
  #       end
  #     end
  #   end

  context 'with the range of restricted IP addresses set to 8.8.8.8' do
    let(:initial_allowed_ips) { Waiver::Authentication.set_allowed_ips('8.8.8.8') }

    before do
      initial_allowed_ips
    end

    after do
      Waiver::Authentication.set_allowed_ips(initial_allowed_ips)
    end

    it 'denies access to the client' do
      get 'index', format: :json
      expect(response).not_to have_http_status(:success)
    end

    it 'denies access to the client' do
      get 'index_unique_id', params: { author_unique_id: author_waiver.author_unique_id, format: :json }
      expect(response).not_to have_http_status(:success)
    end

    it 'denies access to the client' do
      get 'index_missing_unique_ids', format: :json
      expect(response).not_to have_http_status(:success)
    end
  end
end

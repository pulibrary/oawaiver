# frozen_string_literal: true

require "rails_helper"
require "json"

RSpec.describe WaiverInfosController, type: :controller do
  let(:waiver) { FactoryBot.create(:waiver_info, requester: requester) }
  let(:author_waiver) { FactoryBot.create(:waiver_info_faculty_author) }
  let(:user) { FactoryBot.create(:regular_user) }
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:requester) { FactoryBot.create(:regular_user, netid: "requester") }

  before do
    WaiverInfo.delete_all
    Account.delete_all
  end

  after do
    WaiverInfo.delete_all
    Account.delete_all
  end

  describe "#index_mine" do
    it "redirects for failed authentication attempts" do
      get(:index_mine)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "while authenticated as an admin. user" do
      let(:waiver1) do
        FactoryBot.create(:waiver_info, requester: admin_user)
      end
      let(:waiver2) do
        FactoryBot.create(:waiver_info, requester: admin_user)
      end

      let(:waivers) do
        WaiverInfo.where(requester: admin_user)
      end

      before do
        waiver1
        waiver2
        sign_in(admin_user)
      end

      it "retrieves all waivers for a given account" do
        get(:index_mine)

        expect(response).to have_http_status(:success)
        expect(assigns(:waiver_infos)).to include(waiver1)
        expect(assigns(:waiver_infos)).to include(waiver2)
      end
    end
  end

  describe "#search" do
    it "redirects for failed authentication attempts" do
      get(:search)
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "while authenticated as an admin. user" do
      let(:waiver_info_params1) do
        {
          requester: waiver.requester.netid,
          requester_email: waiver.requester_email,
          author_unique_id: waiver.author_unique_id,
          author_first_name: waiver.author_first_name,
          author_last_name: waiver.author_last_name,
          author_status: waiver.author_status,
          author_department: waiver.author_department,
          author_email: waiver.author_email,
          title: waiver.title,
          journal: waiver.journal,
          journal_issn: waiver.journal_issn,
          notes: waiver.notes
        }
      end
      let(:waiver1) do
        FactoryBot.create(:waiver_info, requester: admin_user, requester_email: admin_user.email, title: "test-search-title")
      end
      let(:waiver2) do
        FactoryBot.create(:waiver_info, requester: admin_user, requester_email: admin_user.email, title: "test-search-title")
      end
      let(:waiver_info_params) do
        {
          title: waiver1.title
        }
      end

      let(:params) do
        {
          waiver_info: waiver_info_params
        }
      end

      before do
        waiver1
        waiver2
        sign_in(admin_user)
      end

      it "searches for all waivers by attributes" do
        get(:search, params: params)

        expect(response).to have_http_status(:success)

        found_waiver_infos = assigns(:waiver_infos)
        expect(found_waiver_infos).not_to be nil
        expect(found_waiver_infos).to include(waiver1)
        expect(found_waiver_infos).to include(waiver2)
      end

      context "when the request does not transmit parameters" do
        it "builds a new Waiver" do
          get(:search)

          expect(response).to have_http_status(:success)
          new_waiver_info = assigns(:waiver_info)

          expect(new_waiver_info).to be_a(WaiverInfo)
          expect(new_waiver_info.persisted?).to be false
        end
      end
    end
  end

  describe "#new" do
    it "redirects for failed authentication attempts" do
      get(:new)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "while authenticated as an admin. user" do
      before do
        sign_in(user)
      end

      it "builds a new Waiver with the default status" do
        get(:new)

        expect(response).to have_http_status(:success)

        new_waiver = assigns(:waiver_info)
        expect(new_waiver.persisted?).to be false
        expect(new_waiver.author_status).to eq("faculty")
      end
    end
  end

  describe "#index" do
    it "redirects for failed authentication attempts" do
      get :index

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "while authenticated as an admin. user" do
      before do
        sign_in(user)
      end

      it "retrieves all waivers" do
        get :index
        expect(response).to have_http_status(:success)
      end

      context "when requesting a unique author ID" do
        let(:params) do
          {
            author_unique_id: "whatever"
          }
        end

        it "retrieves all waivers with the unique author ID" do
          get :index, params: params
          expect(response).to have_http_status(:success)
        end
      end

      context "when requesting JSON responses" do
        describe "#index" do
          it "retrieves all waivers" do
            get "index", format: :json

            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end

  describe "#index_unique_id" do
    let(:params) do
      {
        author_unique_id: "does-not-matter",
        use_route: "admins/waiver_infos"
      }
    end

    it "redirects for failed authentication attempts" do
      get :index_unique_id, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated" do
      before do
        sign_in(user)
      end

      it "retrieves all waivers" do
        get :index_unique_id, params: params
        expect(response).to have_http_status(:success)
      end

      context "when requesting a unique author ID" do
        let(:params) do
          {
            author_unique_id: "whatever",
            use_route: "admins/waiver_infos"
          }
        end

        it "retrieves all waivers for a given unique ID" do
          get :index_unique_id, params: params

          expect(response).to have_http_status(:success)
        end

        context "when requesting JSON responses" do
          it "retrieves all waivers for a unique ID" do
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
        use_route: "admins/waiver_infos"
      }
    end

    it "redirects for failed authentication attempts" do
      get :index_missing_unique_ids, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when requesting a unique author ID" do
      let(:params) do
        {
          author_unique_id: "whatever",
          use_route: "admins/waiver_infos"
        }
      end

      context "when authenticated" do
        before do
          sign_in(user)
        end

        it "retrieves all waivers" do
          get :index_missing_unique_ids, params: params
          expect(response).to have_http_status(:success)
        end

        context "when requesting JSON responses" do
          it "retrieves all waivers without a unique ID" do
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
        id: "doesnotmatter",
        use_route: "admins/waiver_infos"
      }
    end

    it "redirects for failed authentication attempts" do
      get :edit_by_admin, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when requesting a unique author ID" do
      let(:params) do
        {
          id: waiver.id,
          use_route: "admins/waiver_infos"
        }
      end

      it "retrieves the waiver for a given ID" do
        get :edit_by_admin, params: params
        expect(response).not_to have_http_status(:success)
      end
    end
  end

  describe "#update_by_admin" do
    let(:waiver_info_params) do
      {
        author_unique_id: 123_456_789,
        author_first_name: "Ada",
        author_last_name: "Lovelace",
        author_status: "test-status",
        author_department: "Computer Science",
        author_email: "alovelace@princeton.edu",
        title: "test-title",
        journal: "test-journal",
        journal_issn: "test-issn",
        notes: "test-notes"
      }
    end

    let(:params) do
      {
        id: waiver.id,
        use_route: "admins/waiver_infos",
        commit: "Save",
        waiver_info: waiver_info_params
      }
    end

    it "redirects for failed authentication attempts" do
      get :update_by_admin, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated as an admin. user" do
      before do
        sign_in(admin_user)
      end

      it "updates the waiver specified by the ID" do
        post :update_by_admin, params: params

        updated_waiver_path = waiver_info_path(id: waiver.id)
        expect(response).to redirect_to(updated_waiver_path)

        updated = waiver.reload

        expect(updated.notes).to eq("test-notes")
        expect(updated.journal_issn).to eq("test-issn")
        expect(updated.journal).to eq("test-journal")
        expect(updated.title).to eq("test-title")
        expect(updated.author_email).to eq("alovelace@princeton.edu")
        expect(updated.author_department).to eq("Computer Science")
        expect(updated.author_status).to eq("test-status")
        expect(updated.author_last_name).to eq("Lovelace")
        expect(updated.author_first_name).to eq("Ada")
        expect(updated.author_unique_id).to eq("123456789")
      end

      context "when invalid parameters are transmitted in the POST request" do
        let(:waiver_info_params) do
          {
            author_unique_id: 123
          }
        end

        let(:rendered_flash) do
          instance_double(ActionDispatch::Flash::FlashNow)
        end

        let(:current_flash) do
          instance_double(ActionDispatch::Flash::FlashHash)
        end

        before do
          allow(rendered_flash).to receive(:[]=)
          allow(current_flash).to receive(:now).and_return(rendered_flash)
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(described_class).to receive(:flash).and_return(current_flash)
          # rubocop:enable RSpec/AnyInstance
        end

        it "redirects to the edit waiver form with error messages" do
          post :update_by_admin, params: params

          edit_waiver_path = edit_by_admin_path(id: waiver.id)
          expect(response).to redirect_to(edit_waiver_path)

          expect(rendered_flash).to have_received(:[]=).with(:alert, "Waiver information could not be successfully updated: Author unique id must be 9 digits.")
        end
      end
    end
  end

  describe "#show" do
    it "does not retrieve the waiver info" do
      get :show, params: { id: waiver.id }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated as an admin. user" do
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
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated as an admin. user" do
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

  describe "#edit_by_admin" do
    let(:params) do
      {
        use_route: "admins/waiver_infos"
      }
    end

    it "redirects for failed authentication attempts" do
      get :edit_by_admin, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated as an admin user" do
      let(:params) do
        {
          use_route: "admins/waiver_infos",
          id: waiver.id
        }
      end

      before do
        sign_in(admin_user)
      end

      it "renders the template" do
        get(:edit_by_admin, params: params)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit_by_admin)
      end
    end

    context "when authenticated as a non-admin user" do
      before do
        sign_in(user)
      end

      it "denies access to the route" do
        get :edit_by_admin, params: { id: waiver.id }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context "with the range of restricted IP addresses set to 8.8.8.8" do
    let(:initial_allowed_ips) { Waiver::Authentication.set_allowed_ips("8.8.8.8") }

    before do
      initial_allowed_ips
    end

    after do
      Waiver::Authentication.set_allowed_ips(initial_allowed_ips)
    end

    it "denies access to the client" do
      get "index", format: :json
      expect(response).not_to have_http_status(:success)
    end

    it "denies access to the client" do
      get "index_unique_id", params: { author_unique_id: author_waiver.author_unique_id, format: :json }
      expect(response).not_to have_http_status(:success)
    end

    it "denies access to the client" do
      get "index_missing_unique_ids", format: :json
      expect(response).not_to have_http_status(:success)
    end
  end
end

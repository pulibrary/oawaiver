# frozen_string_literal: true

require "rails_helper"

describe "Waivers", type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }

  describe "GET /waiver/requester/me" do
    let(:user) { FactoryBot.create(:regular_user) }
    let(:waiver_info) { FactoryBot.create(:waiver_info, requester: admin_user.netid, requester_email: admin_user.email) }
    let(:waiver_info2) { FactoryBot.create(:waiver_info, requester: admin_user.netid, requester_email: admin_user.email, title: "Some 2 Title") }
    let(:waiver_info3) { FactoryBot.create(:waiver_info, requester: user.netid, requester_email: user.email, title: "Some 3 Title") }

    before do
      waiver_info
      waiver_info2
      waiver_info3
    end

    context "when authenticated as an admin. user" do
      before do
        sign_in(admin_user)
      end

      it "retrieves all waivers" do
        get "/waiver/requester/me"

        expect(response.status).to eq(200)
        expect(response.body).to include(waiver_info.title)
        expect(response.body).to include(waiver_info2.title)
        expect(response.body).to include(waiver_info3.title)
      end
    end

    context "when authenticated as a valid user" do
      let(:waiver_info4) { FactoryBot.create(:waiver_info, requester: user.netid, requester_email: user.email, title: "Some 4 Title") }

      before do
        waiver_info4
        sign_in(user)
      end

      it "retrieves all waivers requested by a given user" do
        get "/waiver/requester/me"

        expect(response.status).to eq(200)
        expect(response.body).not_to include(waiver_info.title)
        expect(response.body).not_to include(waiver_info2.title)
        expect(response.body).to include(waiver_info3.title)
        expect(response.body).to include(waiver_info4.title)
      end
    end
  end

  # GET /waiver/:id/mail(.:format)
  describe "GET /waiver/:id/mail" do
    let(:waiver_info) { FactoryBot.create(:waiver_info) }

    context "when authenticated as an admin. user" do
      before do
        sign_in(admin_user)
      end

      context "when MailRecord models have been associated with a persisted Waiver model" do
        let(:mail_record) { FactoryBot.create(:mail_record, waiver_info_id: waiver_info.id) }

        it "renders the mail records" do
          mail_record
          get(show_mail_waiver_info_path(waiver_info))

          expect(response).to render_template(:show_mail)
          expect(response.body).to include("Test Blob")
        end
      end

      it "renders the message that there are no associated MailRecord models" do
        get(show_mail_waiver_info_path(waiver_info))

        expect(response).to render_template(:show_mail)
        expect(response.body).to include("No record of mail.")
      end
    end
  end

  #  create_waiver_info
  #  POST /waiver/create(.:format)
  #  waiver_infos#create
  describe "POST /waiver/create" do
    let(:params) do
      {
        waiver_info: {
          author_unique_id: "000000001",
          author_first_name: "Jane",
          author_last_name: "Smith",
          author_status: "faculty",
          author_department: "History",
          author_email: "js1@princeton.edu",
          title: "test title",
          journal: "test journal",
          notes: "test notes"
        },
        'CONFIRM-WAIVER': "Confirm"
      }
    end

    context "when authenticated as an admin. user" do
      let(:mail_record) { MailRecord.last }
      let(:waiver_info) { WaiverInfo.last }

      before do
        sign_in(admin_user)
      end

      it "constructs and persists a Waiver model" do
        post(create_waiver_info_path, params: params)

        expect(WaiverInfo.count).to eq(1)
        expect(waiver_info.author_unique_id).to eq("000000001")
        expect(waiver_info.author_first_name).to eq("Jane")
        expect(waiver_info.author_last_name).to eq("Smith")
        expect(waiver_info.author_status).to eq("faculty")
        expect(waiver_info.author_department).to eq("History")
        expect(waiver_info.author_email).to eq("js1@princeton.edu")
        expect(waiver_info.title).to eq("test title")
        expect(waiver_info.journal).to eq("test journal")
        expect(waiver_info.journal_issn).to be nil
        expect(waiver_info.notes).to eq("test notes")
      end

      it "constructs and persists a MailRecord model associated with the Waiver model" do
        post(create_waiver_info_path, params: params)

        expect(MailRecord.count).to eq(1)
        expect(WaiverInfo.count).to eq(1)
        expect(mail_record.waiver_info).to eq(waiver_info)
        expect(waiver_info.mail_records).to include(mail_record)
      end

      context "when an error has occurred while persisting the new WaiverInfo model" do
        before do
          allow(MailRecord).to receive(:new_from_mail).and_raise(StandardError, "test error message")
        end

        it "adds the error messages" do
          post(create_waiver_info_path, params: params)

          expect(response.body).to include("Could not send an email")
          # expect(response.body).to include("Author email is invalid")
          expect(response.body).to include("test error message")
          expect(response.body).to include("Did not create the Waiver - Please try again")
        end
      end

      context "when the new WaiverInfo attributes are invalid" do
        let(:params) do
          {
            waiver_info: {
              author_last_name: "Smith",
              author_department: "History",
              author_email: "invalid",
              notes: "test notes"
            },
            'CONFIRM-WAIVER': "Confirm"
          }
        end

        before do
        end

        it "adds the error messages" do
          post(create_waiver_info_path, params: params)

          expect(response.body).to include("Author email is invalid")
        end
      end
    end
  end

  describe "POST /admin/waivers/match" do
    let(:author_dept) { "Chemistry" }
    let(:author_dept2) { "Physics" }

    let(:waiver_info) do
      FactoryBot.create(:waiver_info, requester: admin_user.netid, requester_email: admin_user.email, author_department: author_dept)
    end
    let(:waiver_info2) do
      FactoryBot.create(:waiver_info, requester: admin_user.netid, requester_email: admin_user.email, author_department: author_dept2)
    end
    let(:search_term) { author_dept }
    let(:params) do
      {
        search_term: search_term,
        page: 1,
        per_page: 10
      }
    end

    before do
      waiver_info
      waiver_info2
      sign_in(admin_user)
    end

    it "redirects to the Solr search endpoint" do
      post(match_waiver_infos_words_path, params: params)

      expect(response.status).to eq(302)
      expect(response).to redirect_to(match_waiver_infos_get_words_path(search_term))

      follow_redirect!
      expect(response.body).to include(author_dept)
      expect(response.body).not_to include(author_dept2)
    end
  end

  describe "GET /admin/waivers/match/:search_term" do
    let(:author_dept) { "Chemistry" }
    let(:author_dept2) { "Physics" }
    let(:waiver_info) do
      FactoryBot.create(:waiver_info, requester: admin_user.netid, requester_email: admin_user.email, author_department: author_dept)
    end
    let(:waiver_info2) do
      FactoryBot.create(:waiver_info, requester: admin_user.netid, requester_email: admin_user.email, author_department: author_dept2)
    end
    let(:search_term) { author_dept }
    let(:params) do
      {
        search_term: search_term,
        page: 1,
        per_page: 10
      }
    end

    before do
      waiver_info
      waiver_info2
      sign_in(admin_user)
    end

    it "searches Solr" do
      get(admin_waivers_match_path, params: params)

      expect(response.status).to eq(200)
      expect(response.body).to include(author_dept)
      expect(response.body).not_to include(author_dept2)
    end

    context "when a blank search term is specified" do
      let(:search_term) { "" }

      it "retrieves all WaiverInfo models" do
        get(admin_waivers_match_path, params: params)

        expect(response.status).to eq(200)
        expect(response.body).to include(author_dept)
        expect(response.body).to include(author_dept2)
      end
    end
  end

  describe "POST /admin/waiver/:id" do
    let(:waiver_info) do
      FactoryBot.create(:waiver_info, requester: admin_user.netid, requester_email: admin_user.email)
    end
    let(:user) { FactoryBot.create(:regular_user) }

    before do
      waiver_info
      sign_in(user)
    end

    context "when authenticated with a non-admin user" do
      it "returns with a forbidden status and flashes a warning" do
        post("/admin/waiver/#{waiver_info.id}")

        expect(response.status).to eq(403)
      end
    end
  end

  describe "GET /admin/unique_id/:author_unique_id" do
    let(:employee) { FactoryBot.create(:employee) }
    let(:waiver_info) do
      FactoryBot.create(:waiver_info, requester: employee.unique_id, requester_email: employee.email)
    end
    let(:employee2) { FactoryBot.create(:employee, unique_id: "999999999", netid: "test.user", email: "testuser@localhost.localdomain") }
    let(:waiver_info2) do
      FactoryBot.create(:waiver_info, requester: employee2.unique_id, requester_email: employee.email)
    end

    before do
      waiver_info
      waiver_info2
      sign_in(admin_user)
    end

    it "indexes a waiver retrieved using the author ID" do
      get(index_unique_id_waiver_infos_path(employee.unique_id))

      expect(response.body).to include(waiver_info.requester)
      expect(response.body).not_to include(waiver_info2.requester)
    end
  end
end

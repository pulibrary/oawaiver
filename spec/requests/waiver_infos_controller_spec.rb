# frozen_string_literal: true

require "rails_helper"

describe "Waivers", type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }

  before(:all) do
    MailRecord.delete_all
    WaiverInfo.delete_all
  end

  after(:all) do
    MailRecord.delete_all
    WaiverInfo.delete_all
  end

  describe "/waiver/requester/me" do
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
    end
  end
end

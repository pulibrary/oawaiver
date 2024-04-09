# frozen_string_literal: true

require "rails_helper"

RSpec.describe WaiverInfosController, type: :system do
  # GET waivers/search/:search_term
  # params :page, :per_page
  describe "#solr_search_words" do
    let(:title1) { "test title" }
    let(:title2) { "different title" }
    let(:search_term) { title2 }
    let(:admin_user) { FactoryBot.create(:admin_user) }
    let(:waiver_info1) { FactoryBot.create(:waiver_info, requester: admin_user, requester_email: admin_user.email, title: title1) }
    let(:waiver_info2) { FactoryBot.create(:waiver_info, requester: admin_user, requester_email: admin_user.email, title: title2) }

    before do
      waiver_info2
      waiver_info1
      sign_in(admin_user)
    end

    it "finds WaiverInfo models for Solr search terms" do
      visit match_waiver_infos_get_words_path(search_term)

      expect(page).not_to be nil
      expect(page.body).to include(title2)
      expect(page.body).not_to include(title1)
    end

    context "when the search terms are not specified" do
      it "finds all WaiverInfo models" do
        visit admin_waivers_match_path

        expect(page).not_to be nil
        expect(page.body).to include(title2)
        expect(page.body).to include(title1)
      end
    end
  end
end

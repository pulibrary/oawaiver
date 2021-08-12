# frozen_string_literal: true

require "rails_helper"

RSpec.describe EmployeesController, type: :controller do
  let(:employee_faked) { FactoryBot.create(:employee_faked) }
  let(:employee) { FactoryBot.create(:employee) }
  let(:admin_user) { FactoryBot.create(:admin_user) }

  before do
    Employee.all.map(&:destroy)
    Account.all.map(&:destroy)
  end

  after do
    Employee.all.map(&:destroy)
    Account.all.map(&:destroy)
  end

  describe "#index" do
    it "fail without authentication" do
      get :index

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated as an admin. user" do
      before do
        sign_in(admin_user)
      end

      it "retrieves all employees" do
        get :index

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#index_departments" do
    it "fails without authentication" do
      get :index_departments

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_account_session_path)
    end

    context "when authenticated as an admin. user" do
      before do
        sign_in(admin_user)
      end

      it "retrieves all departments from employees" do
        get :index_departments

        expect(response).to have_http_status(:success)
      end
    end
  end
end

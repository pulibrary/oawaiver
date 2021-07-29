# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let(:employee_faked) { FactoryGirl.create(:employee_faked) }
  let(:employee) { FactoryGirl.create(:employee) }
  let(:admin_user) { FactoryGirl.create(:admin_user) }

  before do
    Employee.delete_all
    Account.delete_all
  end

  after do
    Employee.delete_all
    Account.delete_all
  end

  describe '#index' do
    it 'fail without authentication' do
      get :index

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated as an admin. user' do
      before do
        sign_in(admin_user)
      end

      it "retrieves all employees" do
        get :index

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#index_departments' do
    it 'fails without authentication' do
      get :index_departments

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    context 'when authenticated as an admin. user' do
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

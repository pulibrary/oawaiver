# frozen_string_literal: true

require 'rails_helper'

describe EmployeesController do
  let(:employee1) { FactoryGirl.create(:employee_faked) }
  let(:employee2) { FactoryGirl.create(:employee_faked) }
  let(:employee3) { FactoryGirl.create(:employee_faked) }

  before do
    employee1
    employee2
    employee3

    Array.new(18) do
      FactoryGirl.create(:employee_faked)
    end
  end

  describe "GET /employees" do
    it "redirects to the CAS authentication endpoint" do
      get(employees_path)

      expect(response).to redirect_to(new_account_session_path)
    end

    context 'when authenticated as an admin. user' do
      let(:admin_account) { FactoryGirl.create(:admin_account) }

      before do
        sign_in(admin_account)
      end

      it "renders all persisted Employees" do
        get(employees_path)

        employee1_first_name = ERB::Util.html_escape(employee1.first_name)
        employee2_first_name = ERB::Util.html_escape(employee2.first_name)

        expect(response).to render_template(:index)
        expect(response.body).to include(employee1_first_name)
        expect(response.body).to include(employee2_first_name)
      end

      context 'when requesting specific pages' do
        let(:params) do
          {
            page: 1
          }
        end

        it "renders only a given page of Employees" do
          employee1 = Employee.order(:id).first
          employee2 = Employee.order(:id).all[1]

          get(employees_path, params: params)

          expect(response).to render_template(:index)

          employee1_first_name = ERB::Util.html_escape(employee1.first_name)
          employee2_first_name = ERB::Util.html_escape(employee2.first_name)
          last_employee_first_name = ERB::Util.html_escape(Employee.last.first_name)

          expect(response.body).to include(employee1_first_name)
          expect(response.body).to include(employee2_first_name)
          expect(response.body).not_to include(last_employee_first_name)
        end
      end

      context 'when requesting results per page' do
        let(:params) do
          {
            page: 1,
            per_page: 2
          }
        end

        it "renders the requested number of Employees for the given page" do
          employee1 = Employee.order(:id).first
          employee2 = Employee.order(:id).all[1]
          employee3 = Employee.order(:id).all[2]

          get(employees_path, params: params)

          expect(response).to render_template(:index)

          employee1_first_name = ERB::Util.html_escape(employee1.first_name)
          employee2_first_name = ERB::Util.html_escape(employee2.first_name)
          employee3_first_name = ERB::Util.html_escape(employee3.first_name)

          expect(response.body).to include(employee1_first_name)
          expect(response.body).to include(employee2_first_name)
          expect(response.body).not_to include(employee3_first_name)
        end
      end
    end
  end

  describe "GET /employees/list/departments" do
    let(:employee1) { FactoryGirl.create(:employee_faked) }
    let(:employee2) { FactoryGirl.create(:employee_faked) }

    before do
      employee1
      employee2
    end

    it "redirects to the CAS authentication endpoint" do
      get(index_departments_path)

      expect(response).to redirect_to(new_account_session_path)
    end

    context 'when authenticated as an admin. user' do
      let(:admin_account) { FactoryGirl.create(:admin_account) }

      before do
        sign_in(admin_account)
      end

      it "renders all persisted Employees" do
        get(index_departments_path)

        expect(response).to render_template("employees/index_departments")
        expect(response.body).to include(CGI.escapeHTML(employee1.department))
        expect(response.body).to include(CGI.escapeHTML(employee2.department))
      end
    end
  end

  describe "GET /employees/:id" do
    let(:employee1) { FactoryGirl.create(:employee_faked) }
    let(:employee1_path) { employee_path(id: employee1.id) }

    before do
      employee1
    end

    it "redirects to the CAS authentication endpoint" do
      get(employee1_path)

      expect(response).to redirect_to(new_account_session_path)
    end

    context 'when authenticated as a valid user' do
      let(:admin_account) { FactoryGirl.create(:admin_account) }

      before do
        sign_in(admin_account)
      end

      it "renders the Employee" do
        get(employee1_path)

        expect(response).to render_template(:show)
        expect(response.body).to include(employee1.first_name)
      end
    end
  end
end

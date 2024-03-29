# frozen_string_literal: true

class EmployeesApiController < ApplicationController

  def unique_id
    unique_id = params[:unique_id]

    model = Employee.find_by(unique_id:)
    present(model, with: AjaxQuery::Entities::Employees, type: :full)
  end

  def net_id
    net_id = params[:net_id]

    model = Employee.find_by(net_id:)
    present(model, with: AjaxQuery::Entities::Employees, type: :full)
  end

  def all
    query = Employee.all
    results = query.results
    present(results, with: AjaxQuery::Entities::Employees, type: :full)
  end

  def all_by_name
    search_term_param = params[:search_term]

    query = Employee.all_by_name(search_term_param)
    results = query.results

    respond_to do |format|
      format.json do
        present(results, with: AjaxQuery::Entities::Employees, type: :full)
      end
    end
  end

  def all_by_department
    search_term_param = params[:search_term]

    query = Employee.all_by_department(search_term_param)
    results = query.results
    present(results, with: AjaxQuery::Entities::Employees, type: :full)
  end

  private

  def id_param
    params[:id]
  end

  def unique_id_param
    params[:unique_id]
  end

  def page_param
    params[:page] || 1
  end

  def per_page_param
    params[:per_page] || Employee.per_page
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = if params[:id]
                  Employee.find(params[:id])
                else
                  Employee.find_by(unique_id: params[:unique_id])
                end
  end

  # Only allow a trusted parameter "white list" through.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :preferred_name, :unique_id, :email, :netid)
  end
end

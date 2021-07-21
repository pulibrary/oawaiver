# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :authenticate
  before_action :set_roles
  before_action :ensure_admin_role

  before_action :set_employee, only: %i[show edit update destroy get_uniqueId]

  # GET /employees
  # params :page, :per_page
  def index
    @search_term = ''
    @employees = Employee.all.paginate(page: params[:page], per_page: params[:per_page])
  end

  # GET /employees/departments
  # params :page, :per_page
  def index_departments
    @departments = Employee.select(:department).distinct.collect(&:department).sort
  end

  # GET /employees/ajax_search     - demo ajax forn
  def ajax_search
    @style = params[:style]
    @post = params[:post] || {}
  end

  # POST /employees/search
  # params :page, :per_page
  def search
    if params[:search_term].length > 1
      redirect_to action: :search_get, search_term: params[:search_term]
    else
      redirect_to action: :index
    end
  end

  # GET /employees/search/:search_term
  # params :page, :per_page
  def search_get
    @search_term = params[:search_term]
    @employees = if @search_term.length > 1
                   Employee.search_by_name(@search_term, params[:page], params[:per_page] || Employee.per_page).results
                 else
                   Employee.all.paginate(page: params[:page], per_page: params[:per_page] || Employee.per_page)
                 end
    render :index
  end

  # GET /employees/1
  def show; end

  def get_uniqueId
    render :show
  end

  private

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

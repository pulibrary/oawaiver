# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :authenticate_account!

  # GET /employees
  # params :page, :per_page
  def index
    @search_term = ""

    models = Employee.order(:id)
    @employees = models.paginate(page: page_param, per_page: per_page_param)
  end

  # GET /employees/departments
  # params :page, :per_page
  def index_departments
    models = Employee.select(:department).distinct
    attrs = models.collect(&:department)

    @departments = attrs.sort
  end

  # GET /employees/ajax_search/:style
  def ajax_search
    @style = params[:style]
    @post = params[:post] || {}
  end

  # POST /employees/search
  # params :page, :per_page
  def search
    search_term = params[:search_term]
    return redirect_to action: :index if search_term.empty?

    redirect_to action: :search_get, search_term: params[:search_term]
  end

  # GET /employees/search/:search_term
  # params :page, :per_page
  def search_get
    @search_term = params[:search_term]

    @employees = if @search_term.length > 1
                   search = Employee.search_by_name(@search_term, page_param, per_page_param)
                   search.results
                 else
                   employees = Employee.all
                   employees.paginate(page: page_param, per_page: per_page_param)
                 end

    render :index
  end

  # GET /employees/:id
  def show
    @employee = Employee.find(id_param)
  end

  # GET /employees/list/:unique_id
  def get_uniqueId
    @employee = Employee.find_by(unique_id: unique_id_param)

    render :show
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
end

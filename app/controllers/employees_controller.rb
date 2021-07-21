class EmployeesController < ApplicationController

  before_action :authenticate
  before_action :set_roles
  before_action :ensure_admin_role

  before_action :set_employee, only: [:show, :edit, :update, :destroy, :get_uniqueId]

  # GET /employees
  # params :page, :per_page
  def index
    @search_term = "";
    @employees = Employee.all.paginate(:page => params[:page], :per_page => params[:per_page]);
  end


  # GET /employees/departments
  # params :page, :per_page
  def index_departments
    @departments=  Employee.select(:department).distinct.collect{ |e| e.department }.sort
  end


  # GET /employees/ajax_search     - demo ajax forn
  def ajax_search
    @style = params[:style];
    @post = params[:post] || {};
  end

  # POST /employees/search
  # params :page, :per_page
  def search
    if (params[:search_term].length > 1) then
      redirect_to :action => :search_get, :search_term => params[:search_term]
    else
      redirect_to :action => :index
    end
  end

  # GET /employees/search/:search_term
  # params :page, :per_page
  def search_get
    @search_term = params[:search_term];
    if (@search_term.length > 1) then
      @employees = Employee.search_by_name(@search_term, params[:page], params[:per_page] || Employee.per_page).results;
    else
      @employees = Employee.all.paginate(:page => params[:page], :per_page => params[:per_page] || Employee.per_page);
    end
    render :index
  end

  # GET /employees/1
  def show
  end

  def get_uniqueId
    render :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      if (params[:id]) then
        @employee = Employee.find(params[:id])
      else
        @employee =  Employee.find_by(:unique_id => params[:unique_id]);
      end
    end

    # Only allow a trusted parameter "white list" through.
    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :preferred_name, :unique_id, :email, :netid)
    end
end

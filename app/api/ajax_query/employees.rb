# frozen_string_literal: true

require "rack/contrib"

module AjaxQuery
  class Employees < API
    use Rack::JSONP

    def current_user
      @current_user ||= User.authorize!(env)
    end

    rescue_from :all do |error|
      error_response({ errors: [error.message] })
    end

    # GET /get/:id
    def show
      model = Employee.find(params[:id])
      render json: model
    end

    # def get_employee "get/unique_id" do
    def get_employee_by_unique_id
      unique_id = params[:id]
      model = Employee.find_by(unique_id: unique_id)

      render json: model
    end

    # GET /get/:net_id
    # desc "return the employee with matching NetID"
    # params do
    #  requires :netid, type: String, desc: "exact netid"
    # end

    def get_employee_by_netid
      netid = params[:netid]
      model = Employee.find_by(netid: netid)

      render json: model
    end

    # GET /get_all/name/:search_term
    def get_employees_by_name
      search_term_param = params[:search_term]
      query = Employee.all_by_name(search_term_param)
      models = query.results

      render json: models
    end

    # GET /get_all/department/:search_term
    def get_employees_by_department
      search_term_param = params[:search_term]
      query = Employee.all_by_department(search_term_param)
      models = query.results

      render json: models
    end
  end
end

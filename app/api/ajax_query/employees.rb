# frozen_string_literal: true

require "rack/contrib"

module AjaxQuery
  class Employees < Grape::API
    use Rack::JSONP

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end
    end

    rescue_from :all do |error|
      error_response({ errors: [error.message] })
    end

    # GET /get/:id
    desc "return the employee with the record ID"
    params do
      requires :id, type: String, desc: "record ID"
    end
    get "get/unique_id" do
      unique_id = params[:id]
      model = Employee.find_by(unique_id:)

      present(model, with: Entities::Employees, type: :full)
    end

    # GET /get/:net_id
    desc "return the employee with matching NetID"
    params do
      requires :netid, type: String, desc: "exact netid"
    end
    get "get/netid" do
      netid = params[:netid]
      model = Employee.find_by(netid:)

      present(model, with: Entities::Employees, type: :full)
    end

    # GET /get_all/name/:search_term
    desc "find all Employees with a matching name"
    params do
      requires(:search_term, type: String, desc: "partial name")
    end
    get "get_all/name" do
      search_term_param = params[:search_term]
      query = Employee.all_by_name(search_term_param)
      results = query.results

      present(results, with: Entities::Employees, type: :full)
    end

    # GET /get_all/department/:search_term
    desc "return all employees from given department"
    params do
      requires :search_term, type: String, desc: "partial department name"
    end
    get "get_all/department" do
      search_term_param = params[:search_term]
      query = Employee.all_by_department(search_term_param)
      results = query.results

      present(results, with: Entities::Employees)
    end
  end
end

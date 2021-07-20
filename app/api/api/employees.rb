module API
  class Employees < Grape::API
    use Rack::JSONP

    rescue_from :all do |e|
      error_response({errors: e})
    end

    desc "return the employee with the unique id"
    params do
      requires :id, type: String, desc: "Unique Id"
    end
    get "get/unique_id" do
      present Employee.find_by(unique_id: params[:id]), with: API::Entities::Employees, type: :full
    end

    desc "return the employee with matching netid"
    params do
      requires :netid, type: String, desc: "exact netid"
    end
    get "get/netid" do
      present Employee.find_by(netid: params[:netid]), with: API::Entities::Employees, type: :full
    end

    desc "return all employees with matching name"
    params do
      requires :search_term, type: String, desc: "partial name"
    end
    get "get_all/name" do
      present Employee.all_by_name(params[:search_term]).results,
              with: API::Entities::Employees, type: :full
    end

    desc "return all employees from given department"
    params do
      requires :search_term, type: String, desc: "partial department name"
    end
    get "get_all/department" do
      present Employee.all_by_department(params[:search_term]).results,
              with: API::Entities::Employees
    end

  end
end

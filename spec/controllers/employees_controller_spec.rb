require 'rails_helper'

RSpec.describe EmployeesController, :type => :controller do

  before (:all) do
    FactoryGirl.build(:employee_faked).save
    FactoryGirl.build(:employee).save
    FactoryGirl.build(:admin_user).save
  end

  after (:all) do
    Employee.delete_all
    Account.delete_all
  end

  def authenticate_with(user)
    Waiver::Authentication.set_authorized_user(session, FactoryGirl.build(user).netid)
  end

  [:index, :index_departments].each do |actn|
  describe "GET #{actn}" do
    it "fail without authentication" do
      get actn
      expect(response).to have_http_status(:redirect)
      expect(response.location.start_with?("https://fed.princeton.edu/cas/login")).to be true
    end
    it "lists all for #{actn}" do
      authenticate_with(:admin_user)
      get actn, {}
      expect(response).to have_http_status(:success)
    end
  end
  end


end

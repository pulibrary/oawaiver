# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_account!, only: [:manage]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logout
    redirect_to(destroy_account_session_path)
  end

  def manage
    @notes = params["notes"] || ""
    @accounts = Account.where(netid: current_account.netid)
    @account = Account.new

    render controller: "application", action: "manage"
  end

  def author_search_status
    current_author_status_url = AuthorStatus.status_url(context: self)
    redirect_to(current_author_status_url)
  end

  private

  rescue_from "Exception" do |exception|
    if exception.is_a?(ActiveRecord::RecordNotFound)
      render controller: :application, action: :start
    else
      flash[:alert] = "An exception occurred: #{exception.message}"
      render controller: :application, action: :error
    end
  end

  # This override is necessary for OmniauthCallbacksController
  def after_sign_in_path_for(_resource)
    request.env["omniauth.origin"] || new_account_session_path
  end
end

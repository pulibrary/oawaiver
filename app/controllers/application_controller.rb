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
    # redirect_to(AuthorStatus.StatusUrl)
    redirect_to(AuthorStatus.status_url)
  end

  unless Rails.env.development?
    rescue_from "Exception" do |exception|
      if exception.is_a?(ActiveRecord::RecordNotFound)
        render controller: :application, action: :start
      else
        flash[:alert] = "An exception occurred: #{exception.message}"
        render controller: :application, action: :error
      end
    end
  end

  private

  def verify_roles
    logger.debug("#{self.class}: @user=#{current_account} @roles=#{roles.inspect}")

    @is_admin = admin_user?
  end
  alias set_roles verify_roles

  # Is this needed?
  def current_account_email
    return unless current_account

    "#{current_account}@princeton.edu"
  end

  unless Rails.env.development?
    rescue_from 'Exception' do |exception|
      if exception.is_a?(ActiveRecord::RecordNotFound)
        render controller: :application, action: :start
      else
        flash[:alert] = "An exception occurred: #{exception.message}"
        render controller: :application, action: :error
      end
    end
  end

  def admin_user?
    @is_admin ||= roles.include?('ADMIN')
  end

  def user
    super || current_account
  end

  def ensure_admin_role
    logger.debug("ensure_admin_role for #{current_account} with #{roles}")

    return if current_user&.admin?

    render nothing: true, status: :forbidden
  end

  def roles
    return [] unless current_account

    @roles ||= current_account.roles
  end

  def user
    super || current_account
  end

  def current_cas_user
    session[:cas_user]
  end

  def after_sign_in_path_for(_resource)
    request.env["omniauth.origin"] || new_account_session_path
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_account!, only: [:start, :logout, :manage]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logout
    logout_redirect(root_url)
  end

  def manage
    return unless current_account.admin?

    @notes = params['notes'] || ''
    @accounts = Account.where(netid: current_account.netid)
    @account = Account.new
    render controller: 'application', action: 'manage'
  end

  def author_search_status
    redirect_to(AuthorStatus.StatusUrl)
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

  private

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
end

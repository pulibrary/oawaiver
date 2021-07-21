
class ApplicationController < ActionController::Base
  include Waiver::Authentication

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def start
    get_user_data
    set_roles
  end

  def login
    authenticate
    return false unless (@user)
    # now we are back from authentication with a valid user
    get_user_data
    set_roles
    render :start
  end

  def logout
    logout_redirect(root_url)
  end

  def manage
    get_user_data
    set_roles
    return false unless ensure_admin_role
    @notes = params['notes'] || '';
    @accounts =  Account.all.where("netid != ?", @user)
    @account = Account.new
    render :controller => 'application', :action => 'manage'
  end


  def author_search_status
    redirect_to AuthorStatus.StatusUrl
  end

  def unknown
    get_user_data
    set_roles
    render :start
  end

  def set_roles
    @roles = Account.roles(@user);
    @is_admin = @roles.include?("ADMIN")
    logger.debug "#{self.class}: @user=#{@user} @roles=#{@roles.inspect}";
  end

  def ensure_admin_role
    logger.debug "ensure_admin_role for #{@user} with #{@roles}"
    if not @is_admin then
      render nothing: true, status: :forbidden
      return false
    end
    return true
  end

  if Rails.env() != "development" then
    rescue_from 'Exception' do |exception|
      if exception.class == ActiveRecord::RecordNotFound then
          render :controller => :application, :action => :start
      else
          flash[:alert] = "An exception occurred: #{exception.message}";
          render :controller => :application, :action => :error
      end
    end
  end
end


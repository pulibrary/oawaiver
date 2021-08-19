# frozen_string_literal: true

class WaiverInfosController < ApplicationController
  before_action :authenticate_account!
  before_action :set_waiver_info, only: %i[show show_mail]
  before_action :ensure_user_owns_waiver_info, only: %i[show show_mail]
  respond_to :html

  # GET waivers/search/:search_term
  # params :page, :per_page
  def solr_search_words
    args = stripped_args(params, :dont_keep_empties)
    search_term = args["search_term"] || ""

    waiver_infos = if search_term.length > 1
                     WaiverInfo.search_with_words(search_term, params[:page], params[:per_page] || WaiverInfo.per_page).results
                   else
                     WaiverInfo.all.paginate(page: params[:page], per_page: params[:per_page] || WaiverInfo.per_page)
                   end

    do_solr_index(search_term, waiver_infos)
    render(:index)
  end

  # GET waivers/search/:search_term
  # params :page, :per_page
  def solr_search_words_post
    redirect_to action: :solr_search_words, search_term: (params["search_term"] || "").gsub(%r{[.&/]}, " ")
  end

  # GET waivers
  def index
    models = WaiverInfo.all

    do_index({}, models)
    render(:index)
  end

  # GET waiver/requester/me
  def index_mine
    models = WaiverInfo.where(requester: current_account.netid)

    do_index(current_account_properties, models)
    render(:index)
  end

  def index_unique_id
    models = search_with_props(unique_id_properties)

    do_index(unique_id_properties, models)
    render(:index)
  end

  def index_missing_unique_ids
    logger.debug("index_missing_unique_ids: authenticated as user='#{current_account}'")
    models = WaiverInfo.find_by_missing_unique_id

    do_index(missing_unique_ids_properties, models)
    render(:index)
  end

  def search
    render status: :forbidden unless current_account.admin?

    if params["waiver_info"]
      models = search_with_props(waiver_info_params)
      do_index(waiver_info_params, models)
    else
      @waiver_info = WaiverInfo.new
    end

    render(:index)
  end

  def new
    @waiver_info = WaiverInfo.new(author_status: AuthorStatus.status_faculty)

    render(:new_waiver_info)
  end

  def create
    redirect_to(root_path) if params["CANCEL"]

    @waiver_info = WaiverInfo.new(waiver_info_params)
    @waiver_info.errors.clear
    render(:new_waiver_info) unless @waiver_info.valid?

    redirect_to(root_path) unless params["CONFIRM-WAIVER"]

    @waiver_info.save # save first so ID will be set when generating mail
    mail = WaiverMailer.new(@waiver_info).granted(@waiver_info.cc_email)
    mail.deliver!

    mail_record = MailRecord.new_from_mail(mail)
    mail_record.waiver_info = @waiver_info
    mail_record.save

    @request_granted = true
    flash.now[:notice] = "We have sent emails with the waiver to #{mail_record.recipients.join(', ')}"

    render :show
  rescue StandardError => error
    @waiver_info.destroy
    @waiver_info.errors.add(:base, "Could not send an email")
    @waiver_info.errors.add(:base, error.message)
    @waiver_info.errors.add(:base, "Did not create the Waiver - Please try again")

    render :new_waiver_info
  end

  # POST /admin/waiver/:id
  def update_by_admin
    # This should be refactored into an exception (or, CanCanCan should be used)
    unless current_account.admin?
      head(:forbidden)
      return flash[:alert] = "User account #{current_account} is not an administrator. Please contact an administrator for assistance."
    end

    @waiver_info = WaiverInfo.find(waiver_id)

    # This handles legacy support for the POST requests
    redirect_to(:edit_by_admin) unless params[:commit] && params[:commit] == "Save"

    if @waiver_info.update(update_waiver_info_params)
      flash[:notice] = "Waiver information successfully updated"
      redirect_to(@waiver_info)
    else
      error_messages = @waiver_info.errors.full_messages.join(". ")
      flash.now[:alert] = "Waiver information could not be successfully updated: #{error_messages}."
      redirect_to(:edit_by_admin, id: @waiver_info.id)
    end
  end

  # GET /admin/waiver/:id
  def edit_by_admin
    # This should be refactored into an exception (or, CanCanCan should be used)
    unless current_account.admin?
      head(:forbidden)
      return flash[:alert] = "User account #{current_account} is not an administrator. Please contact an administrator for assistance."
    end

    @waiver_info = WaiverInfo.find(waiver_id)

    # This handles the POST request, and should be refactored into a new action, #create_by_admin
    redirect_to(:update_by_admin) if params[:commit] && params[:commit] == "Save"

    render(:edit_by_admin)
  end

  private

  def waiver_id
    params[:id]
  end

  def current_account_properties
    {
      "Requester or Author" => current_account.email
    }
  end

  def unique_id_properties
    {
      author_unique_id: author_unique_id_param
    }
  end

  def missing_unique_ids_properties
    {
      missing: "unique_id"
    }
  end

  def author_unique_id_param
    params[:author_unique_id]
  end

  def do_index(props, relation)
    @properties = props
    @search_term = ""
    @waiver_infos = relation.paginate(page: params[:page], per_page: params[:per_page])
  end

  def do_solr_index(words, waivers)
    @properties = []
    @search_term = words
    @waiver_infos = waivers
  end

  def search_with_props(search_props)
    props = {}

    search_props.each do |k, v|
      props[k] = v.strip
    end

    title = props.delete("title")
    journal = props.delete("journal")
    notes = props.delete("notes")

    @waiver_infos = WaiverInfo.where(props)
    @author = Employee.find_by_unique_id(props["author_unique_id"]) if props["author_unique_id"]
    @waiver_infos = @waiver_infos.where("title LIKE ?", "%#{title}%") if title
    @waiver_infos = @waiver_infos.where("journal LIKE ?", "%#{journal}%") if journal
    @waiver_infos = @waiver_infos.where("notes LIKE ?", "%#{notes}%") if notes
    @waiver_infos
  end

  def account_owns_waiver?
    current_account.authenticated? && @waiver_info.requester == current_account
  end

  def ensure_user_owns_waiver_info
    # TODO: what about author ?
    return if current_account.admin?

    logger.debug "ensure_user_owns_waiver_info #{@waiver_info.id} #{current_account}"
    render nothing: true, status: :forbidden unless account_owns_waiver?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_waiver_info
    @waiver_info = WaiverInfo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def update_waiver_info_params
    permitted_waiver_info_params = params.require(:waiver_info)
    permitted = permitted_waiver_info_params.permit(
      :author_unique_id,
      :author_first_name,
      :author_last_name,
      :author_status,
      :author_department,
      :author_email,
      :title,
      :journal,
      :journal_issn,
      :notes
    )

    stripped_args(permitted, :keep_empties)
  end

  def default_params
    {
      "requester" => current_account.netid,
      "requester_email" => current_account.email
    }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def waiver_info_params
    return default_params unless params["waiver_info"]

    permitted_waiver_info_params = params.require(:waiver_info)
    permitted = permitted_waiver_info_params.permit(
      :requester,
      :requester_email,
      :author_unique_id,
      :author_first_name,
      :author_last_name,
      :author_preferred_name,
      :author_status,
      :author_department,
      :author_email,
      :title,
      :journal,
      :journal_issn,
      :cc_email,
      :notes,
      :search_term
    )

    values = stripped_args(permitted, :dont_keep_empties)
    default_params.merge(values)
  end

  # I am not certain that this is needed
  def stripped_args(args, mode)
    hsh = {}
    keep = mode == :keep_empties
    args.each do |k, v|
      v = v.strip
      hsh[k] = v if keep || v.present?
    end
    hsh
  end
end

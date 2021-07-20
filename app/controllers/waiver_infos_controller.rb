class WaiverInfosController < ApplicationController
  respond_to :html

  before_action :authenticate
  before_action :set_roles
  before_action :ensure_admin_role, only: [:index, :index_unique_id,
                                           :index_missing_unique_ids,
                                           :edit_by_admin,
                                           :solr_search_words, :solr_search_words_post];
  before_action :set_waiver_info, only: [:show, :show_mail]
  before_action :ensure_user_owns_waiver_info, only: [:show, :show_mail]

  def do_index(props, relation)
    @properties = props
    @search_term = ""
    @waiver_infos = relation.paginate(:page => params[:page], :per_page => params[:per_page]);
    render :index
  end

  def do_solr_index(words, waivers)
    @properties = []
    @search_term = words
    @waiver_infos = waivers
    render :index
  end

  def search_with_props(search_props)
    props = {};
    search_props.each do |k, v|
      props[k] = v.strip();
    end
    title = props.delete('title');
    journal = props.delete('journal');
    notes = props.delete('notes');
    @waiver_infos = WaiverInfo.where(props)
    @author = Employee.find_by_unique_id(props['author_unique_id'])  if props['author_unique_id']
    if (title) then
      @waiver_infos = @waiver_infos.where("title LIKE ?", "%#{title}%");
    end
    if (journal) then
      @waiver_infos = @waiver_infos.where("journal LIKE ?", "%#{journal}%");
    end
    if (notes) then
      @waiver_infos = @waiver_infos.where("notes LIKE ?", "%#{notes}%");
    end
    return @waiver_infos;
  end

  # GET waivers/search/:search_term
  # params :page, :per_page
  def solr_search_words
    args = stripped_args(params, :dont_keep_empties)
    search_term = args['search_term'] || ""

    if (search_term.length > 1) then
      waiver_infos = WaiverInfo.search_with_words(search_term, params[:page], params[:per_page] || WaiverInfo.per_page).results;
    else
      waiver_infos = WaiverInfo.all.paginate(:page => params[:page], :per_page => params[:per_page] || WaiverInfo.per_page);
    end
    do_solr_index(search_term, waiver_infos)
  end

  # GET waivers/search/:search_term
  # params :page, :per_page
  def solr_search_words_post
    redirect_to :action => :solr_search_words, :search_term =>  (params['search_term'] || "").gsub(/[.&\/]/,' ')
  end


  def index
    do_index({}, WaiverInfo)
  end

  def index_mine
    do_index({'Requester or Author' => @user_email},
             WaiverInfo.find_by_email(@user_email));
  end

  def index_unique_id
    do_index({:author_unique_id => params[:author_unique_id]},
             search_with_props({:author_unique_id => params[:author_unique_id]}));
  end

  def index_missing_unique_ids
    logger.debug("index_missing_unique_ids: authenticated as user='#{@user}'")
    do_index({:missing => 'unique_id'},  WaiverInfo.find_by_missing_unique_id)
  end

  def search
    render status: :forbidden if not @roles.include?("ADMIN");
    if (params['waiver_info']) then
      args = waiver_info_params({});
      props = args.select { |k, v| not v.empty? };
      do_index(props, search_with_props(props));
    else
      @waiver_info = WaiverInfo.new()
    end
  end

  def show
  end

  def show_mail
    @mail_records = @waiver_info.mail_records;
    render :show_mail
  end

  def new
    @waiver_info = WaiverInfo.new(:author_status => AuthorStatus.StatusFaculty)
    render :new_waiver_info
  end

  def create
    if (params["CANCEL"]) then
      redirect_to root_path
      return;
    end
    @waiver_info = WaiverInfo.new(waiver_info_params)
    @waiver_info.errors.clear();
    if (not @waiver_info.valid?) then
      render :new_waiver_info
      return;
    end
    if (params["CONFIRM-WAIVER"]) then
      begin
        @waiver_info.save # save first so ID will be set when generating mail
        mail = WaiverMailer.new(@waiver_info).granted(@waiver_info.cc_email);
        mail.deliver!
        record = MailRecord.new_from_mail(mail);
        record.waiver_info = @waiver_info;
        record.save();
        @request_granted = true
        flash.now[:notice] = "We have sent emails with the waiver to #{record.recipients.join(", ")}"
        render :show
      rescue Exception => e
        @waiver_info.destroy
        @waiver_info.errors.add(:base, "Could not send an email");
        @waiver_info.errors.add(:base, e.message);
        @waiver_info.errors.add(:base, "Did not create the Waiver - Please try again");
        render :new_waiver_info
      end
    else
      redirect_to root_path
    end
  end

  def edit_by_admin
    @waiver_info = WaiverInfo.find(params[:id]);
    if (params[:commit] == "Save") then
      args = admin_edit_waiver_info_params();
      args.each do |k,v|
        @waiver_info[k] = v;
      end
      if (@waiver_info.author_unique_id == "") then
        @waiver_info.author_unique_id = nil;
      end
      if (@waiver_info.save) then
        flash.now[:notice] = "Waiver information successfully updated";
        render "show"
        return;
      end
    end
    render "edit_by_admin";
  end

  private

  def ensure_user_owns_waiver_info
    # TODO what about author ?
    logger.debug "ensure_user_owns_waiver_info #{@waiver_info.id} #{@user}"
    yes = @roles.include?("ADMIN");
    yes = yes || (@roles.include?("LOGGEDIN") and @waiver_info.requester == @user)
    if not yes then
      render nothing: true, status: :forbidden
      return false
    end
    return true
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_waiver_info
    @waiver_info = WaiverInfo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_edit_waiver_info_params()
    args = params.require(:waiver_info).permit(:author_unique_id, :author_first_name, :author_last_name,
                                               :author_status, :author_department,
                                               :author_email, :title, :journal, :journal_issn,
                                               :notes)
    hsh = stripped_args(args, :keep_empties);
    args[:author_unique_id] = nil if  (args[:author_unique_id] == "")
    return hsh;
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def waiver_info_params(defaults = {'requester' => @user,
                                     'requester_email' => @user_email})
    if (not params['waiver_info']) then
      hsh = {}
    else
      args = params.require(:waiver_info).permit(:requester, :requester_email,
                                               :author_unique_id, :author_first_name, :author_last_name,
                                               :author_preferred_name, :author_status, :author_department,
                                               :author_email, :title, :journal, :journal_issn,
                                               :cc_email, :notes, :search_term)
      hsh = stripped_args(args, :dont_keep_empties);
    end
    results = defaults.merge(hsh);
    return results
  end


  def stripped_args(args, mode)
    hsh = {};
    keep = mode == :keep_empties
    args.each do |k, v|
      v = v.strip();
      if keep or not v.empty? then
        hsh[k] = v;
      end
    end
    return hsh;
  end
end

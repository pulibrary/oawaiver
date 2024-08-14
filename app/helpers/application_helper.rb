# frozen_string_literal: true

module ApplicationHelper
  def top_layout_css_class(params)
    "#{params['controller']} #{params['controller']}_#{params['action']} rails_#{Rails.env}"
  end

  def google_scholar_link(string)
    # articles
    link_to("http://scholar.google.com/scholar?as_sdt=0,31&q=" + string.split.join("+"),
            class: "admin_actions") do
      image_tag("googlescholar.ico", width: "16px")
    end
  end

  def waiver_infos_property_or_link(prop, val, link_label = nil)
    link_label ||= val
    return waiver_infos_select_by({ prop => val }, link_label) if current_account_admin?

    link_label
  end

  def waiver_infos_select_by(hsh, link_text = "W")
    link_args = search_waiver_infos_path(
      params: {
        waiver_info: hsh
      }
    )

    link_to(link_args, class: "admin_actions") do
      link_text
    end
  end

  def sherpa_romeo_journal(string, label = "SR")
    link_to("http://www.sherpa.ac.uk/romeo/search.php?versions=all&prule=ALL&jrule=CONTAINS&search=" + string.split.join("+"),
            class: "admin_actions") do
      label
    end
  end

  def directory_link(email, label = "?-DIR")
    link_to("http://search.princeton.edu/search?e=" + Rack::Utils.escape(email),
            class: "admin_actions") do
      label
    end
  end

  def institution_site_search(words, label = "?-PU")
    link_to("http://www.princeton.edu/main/tools/search/?q=" + Rack::Utils.escape(words.split.join("+")),
            class: "admin_actions") do
      label
    end
  end

  def sign_out_form(html_opts = {})
    html_opts[:class] = html_opts.fetch(:class, []) + ["form"]

    form_with url: destroy_account_session_path, method: :delete, **html_opts do |form|
      form.submit("Logout", class: ["btn"])
    end
  end

  def sign_out_link(html_opts = {})
    child_element = tag.span("", class: "glyphicon glyphicon-user")

    children = child_element + sign_out_form(html_opts)
    tag.div(children, class: ["navigation-auth"])
  end

  def sign_in_link(html_opts = {})
    child_element = tag.span("", class: "glyphicon glyphicon-user")
    link_to(child_element + " Login", account_cas_omniauth_authorize_path, html_opts)
  end

  def devise_session_link(html_opts = {})
    return sign_out_link(html_opts) if current_account

    sign_in_link(html_opts)
  end

  def paginate_length(models)
    models.total_entries
  end

  def current_roles
    return [] unless current_account

    @roles ||= Account.roles(current_account)
  end

  def body_class_names
    output = current_roles.join(" ")
    output.downcase
  end

  def current_account_admin?
    return false if current_account.nil?

    current_account.admin?
  end
end

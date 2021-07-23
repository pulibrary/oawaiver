# frozen_string_literal: true

module ApplicationHelper
  def top_layout_css_class(params)
    "#{params['controller']} #{params['controller']}_#{params['action']} rails_#{Rails.env}"
  end

  def google_scholar_link(string)
    # articles
    link_to('http://scholar.google.com/scholar?as_sdt=0,31&q=' + string.split.join('+'),
            class: 'admin_actions') do
      image_tag('googlescholar.ico', width: '16px')
    end
  end

  def waiver_infos_property_or_link(prop, val, label = nil)
    label ||= val
    @is_admin ? waiver_infos_select_by({ prop => val }, label) : label
  end

  def waiver_infos_select_by(hsh, label = 'W')
    link_to(search_waiver_infos_path(params: { waiver_info: hsh }),
            class: 'admin_actions') do
      label
    end
  end

  def sherpa_romeo_journal(string, label = 'SR')
    link_to('http://www.sherpa.ac.uk/romeo/search.php?versions=all&prule=ALL&jrule=CONTAINS&search=' + string.split.join('+'),
            class: 'admin_actions') do
      label
    end
  end

  def directory_link(email, label = '?-DIR')
    link_to('http://search.princeton.edu/search?e=' + Rack::Utils.escape(email),
            class: 'admin_actions') do
      label
    end
  end

  def institution_site_search(words, label = '?-PU')
    link_to('http://www.princeton.edu/main/tools/search/?q=' + Rack::Utils.escape(words.split.join('+')),
            class: 'admin_actions') do
      label
    end
  end

  def employee_list(name, label = 'A')
    link_to(search_get_employees_path(search_term: name), class: 'admin_actions') do
      label
    end
  end

  def login_out_link(html_opts = {})
    link = @user ? logout_path : login_path
    label = @user ? "Logout #{@user}" : 'Login'
    link_to(content_tag(:span, '', class: 'glyphicon glyphicon-user') + ' ' + label, link, html_opts)
  end

  def paginate_length(objects)
    return objects.total_entries if objects.respond_to? :total_entries
    return objects.total_count if objects.respond_to? :total_count
    return objects.length if objects.respond_to? :length

    'unknown'
  end
end

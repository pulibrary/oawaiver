module WaiverInfosHelper

  def hidden_author_form_fields
    # generate input fields with class names that match the field names returned for employee docs
    # in the author engine
    tag = hidden_field(:waiver_info, :author_first_name, :class => "first_name",  :id => nil);
    [:author_last_name,  :author_preferred_name, :author_email, :author_unique_id, :author_department].each do |prop|
      tag = tag.safe_concat(hidden_field(:waiver_info, prop, :class => prop.to_s.sub(/^author_/, ''), :id => nil))
    end
    return tag
  end

  def properties_list(props)
    list = "";
    if (@author)
      auid = props.delete('author_unique_id');
      list = content_tag(:div, "Author: #{empl_short @author}", :class => 'properties')
    end
    props.each do |k, v|
      elem = content_tag(:div, "#{k.to_s.titleize}: #{v}", :class => 'properties')
      list = list + elem;
    end
    return list.html_safe;
  end

end
require 'csv'

class Employee < ActiveRecord::Base
  # USE THIS when searching for all employees / all employees in a department
  # this number should be big greater than both
  # * the number of employees with a given common name
  # * the number of employees in a given department
  @@MAX_EMPLOYEE_MATCH = 200

  default_scope { order('preferred_name ASC') }
  self.per_page = 20;

  before_validation :clean_strings
  before_validation :derive_attr_values
  before_validation :format_unique_id

  validates_presence_of :first_name, :last_name, :unique_id, :netid, :department
  validates_presence_of :preferred_name, allow_blank: false
  validates_uniqueness_of :netid, :case_sensitive => false

  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email,
                      :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  validates_uniqueness_of :unique_id, :message => "id has already been taken"
  validates_format_of :unique_id,
                      :with => /\b\d{9}\z/,
                      :message => "id must be 9 digits"

  # derive preferred_name from first and last_name if it is nil
  def derive_attr_values
    if (self.preferred_name.nil?) then
        self.preferred_name = "#{self.last_name}, #{self.first_name}";
    end
  end

  # pad unique+id with 0 if it has less than 9 characters
  def format_unique_id
    uid = self[:unique_id];
    begin
      if (uid.class == Fixnum) then
        uid = "%09d" % uid
      elsif (uid.class == String) then
        len = uid.length;
        if (len < 9) then
          uid = ("000000000".slice(0, 9 - uid.length)) + uid;
        end
      end
      self.unique_id = uid;
    rescue Exception => e
      logger.debug("format_unique_id #{uid} failed with #{e.message}");
    end
    return self
  end


  # ---------------------
  # search/solr
  # ---------------------
  def all_names
    return [self.first_name, self.last_name, self.preferred_name];
  end

  def order_by_name
    return "#{last_name}, #{first_name} #{id}"
  end

  searchable do
    text :department, :stored => true
    string :order_by_name, :multiple => false, :stored => true
    text :all_names, :stored => true
  end

  public
  # get all employees with a matching first, last or preferred_name
  # return Sunspot::Search object
  def Employee.all_by_name(word)
    return search_by_field(:all_names, word, nil, @@MAX_EMPLOYEE_MATCH)
  end

  # get all employees with a matching first, last or preferred_name
  # paginate results according to given page and per_page parameters
  # return Sunspot::Search object
  def Employee.search_by_name(word, page = nil, per_page =  nil)
    return search_by_field(:all_names, word, page, per_page)
  end

  # search for employees from the given department
  # paginate results according to given page and per_page parameters
  # return Sunspot::Search object
  def Employee.all_by_department(word)
    return search_by_field(:department, word, nil, @@MAX_EMPLOYEE_MATCH)
  end

  # search for employees from the given department
  # paginate results according to given page and per_page parameters
  # return Sunspot::Search object
  def Employee.search_by_department(word, page = nil, per_page = nil)
    return search_by_field(:department, word, page, per_page)
  end


  private
  def Employee.search_by_field(field, word, page, per_page)
    per_page ||= self.per_page
    s = Employee.search do
      fulltext word, :fields => [field]
      order_by :order_by_name
      paginate :page => page, :per_page => per_page
    end
    return s
  end

  def to_s
    return "#<Employee::#{self.preferred_name} #{self.netid} #{self.unique_id}>"
  end

  # ---------------------
  # utils
  # ---------------------
  def clean_strings
    if changed? or id.nil? then
      self.attributes.each do |n, v|
        self[n] = nil if self[n] == "";
        if (not self[n].nil? and self[n].class == String)
          self[n] = self[n].gsub(/\s+/, ' ').strip();
        end
      end
    end
    return self
  end

  public
  def self.convert_str(str)
    str.chars.select { |c| c.chr != "\u0000" }.join
  end

  # deletes all existing employees and loads new employees from the given file (.csv format)
  # returns { :loaded => number of employees :failed => hash of line numbers to errors
  def self.loadCsv(filename, logger)
    cognosCrossWalk = {
        '[Firstname]' => :first_name,
        '[Lastname]' => :last_name,
        '[KnownAs]' => :preferred_name,
        '[Department]' => :department,
        '[Proprietary_ID]' => :unique_id,
        '[Email]' => :email,
        '[Username]' => :netid
    }

    logger.debug "Start loading '#{filename}'";
    loaded = 0;
    skipped = 0;
    failed = {};

    ActiveRecord::Base.transaction(requires_new: true) do
      Employee.destroy_all

      headers = nil
      i = 0;
      CSV.foreach(filename, col_sep: "\t", encoding: "IBM437") do |row|
        i = i +1
        logger.debug "#{i} #{row}"

        if headers.nil? then
          headers = []
          row.each do |h|
            headers << convert_str(h)
          end
          logger.info "#{headers.length} Column headers: #{headers.join(',')}"
          next
        end

        attrs = {};
        for c in 0..row.length-1 do
          val = convert_str(row[c])
          # puts "#{i} #{c}: #{val} #{headers[c]}"
          if cognosCrossWalk[headers[c]] and val and not val.strip.empty? then
            attrs[cognosCrossWalk[headers[c]]] = val
          end
        end
        logger.debug attrs.inspect
        if (attrs.empty?)
          skipped += 1
          next;
        end
        employee = Employee.create(attrs)
        if employee.save then
          loaded += 1
          logger.info "Employee.loadCsv #{filename} line #{i}: loaded #{employee}";
        else
          failed[i] = [employee.errors.messages];
          logger.error "Employee.loadCsv #{filename} line: #{i}: #{failed[i]}";
        end
      end

      logger.info " Loaded #{loaded} employee records; Failed to read #{failed.length} lines, Skipped #{skipped} lines"

      if (not failed.empty?) then
        logger.error "Rolling back all changes"
        raise ActiveRecord::Rollback
      end
    end
    logger.debug "Stop loading '#{filename}'";
    if (not failed.empty?) then
      Employee.reindex
    end
    return {:loaded => loaded, :failed => failed, :skipped => skipped}
  end

end

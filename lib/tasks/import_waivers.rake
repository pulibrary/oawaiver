# frozen_string_literal: true

require "csv"

namespace :import do
  namespace :waivers do
    Get_search_name_path = { "json" => "/api/employees/get_all/name.json?search_term=MATCH" }.freeze
    Get_search_netid_path = { "json" => "/api/employees/get/netid.json?netid=MATCH" }.freeze

    def GetNameSearchUrl(name)
      AuthorStatus.base_url +
        Get_search_name_path["json"].gsub(/MATCH/, Rack::Utils.escape(name))
    end

    def GetNetIdSearchUrl(netid)
      AuthorStatus.base_url +
        Get_search_netid_path["json"].gsub(/MATCH/, netid)
    end

    namespace :provost do
      desc "import from csv file provided by provost/qualtrics export; run: header,debug,info,quiet"
      task :csv, %i[filename requester run base_url note] => :environment do |t, args|
        args.with_defaults({ run: "header", base_url: "http://localhost:3000", requester: "sco" })
        filename = args.filename
        run = args.run
        requester = args.requester
        # faculty_status = AuthorStatus.StatusFaculty
        faculty_status = AuthorStatus.status_faculty
        # AuthorStatus.SetBaseUrl = args.base_url
        AuthorStatus.base_url = args.base_url

        if !filename || (run == "help")
          puts "usage: #{t.name}[filename,run,note]"
          puts "\tfilename - csv file with waiver info from provost QUALTRICS"
          puts "\trun      - one of header, help, debug, quiet  - default: header"
          puts "\tnote     - note to indicate the import run - default: 'import from file: filename' "
          puts ""
          puts "Imported waivers are associated with the requester #{requester}"
          puts ""
          puts "The waiver receives the author_status '#{faculty_status}'"
          puts "if the requester in the qualtrics data is matched to a faculty member."
          puts "Otherwise it receives the author status 'unknown'"

          if run == "help"
            exit(0)
          else
            exit(1)
          end
        end

        note = args.note || "imported from file: #{filename}"
        puts "#{t.name}: ### Setup"
        puts "#{t.name}: importing from #{filename}"
        puts "#{t.name}: imported waivers receive the author_status: '#{faculty_status}'"
        puts "#{t.name}: setting requester to: #{requester}"
        puts ""
        crosswalk = {}
        crosswalk[:author_unique_id] = 10; # actually id of person applying - may or may not be author
        crosswalk[:created_at] = 7
        crosswalk[:author_first_name] = 13
        crosswalk[:author_last_name] = 14
        crosswalk[:author_department] = 15
        crosswalk[:title] = 16
        crosswalk[:journal] = 17
        crosswalk[:requester_email] = 18
        i = 1
        CSV.foreach(filename, encoding: "IBM437") do |row|
          puts "line #{i}: ROW-DEBUG #{row}" if run == "debug"

          if i == 2
            puts "#{t.name}: ### Header Crosswalk"
            crosswalk.each do |k, v|
              puts "#{t.name}: #{k}\t<= #{row[v]}"
            end
            puts "#{t.name}: notes: #{note}"
            puts ""
            if run == "header"
              break; # skip reading rest of file
            end
          elsif i > 2
            # read line into hsh
            hsh = row_into_hsh(crosswalk, row)
            hsh[:requester] = requester
            hsh[:notes] = note

            a = process_row(hsh, run, crosswalk, faculty_status)
            if a.nil?
              puts "#{t.name}: line #{i}: ROW-EMPTY #{row}"
            elsif !a.valid?
              puts "#{t.name}: line #{i}: ROW-INVALID #{row}"
              a.errors.full_messages.each do |m|
                puts "#{t.name}: line #{i}: ERROR #{m}"
              end
            else
              status = a.notes.index("ERROR").nil? ? "ROW-IMPORTED           " : "ROW-IMPORTED-WITH-ERROR"
              puts "#{t.name}: line #{i}: #{status} #{a.author_status} #{a.author_last_name},#{a.author_first_name} #{a.title}"
              if run != "quiet"
                a.notes.split("\n").each do |n|
                  puts "#{t.name}: line #{i}: ROW-NOTE                #{n}" unless note == n
                end
              end
            end
          end
          i += 1
        end
      end

      # inputs:
      # * hsh -representing a row in the input file
      # * run, crosswalk - parameters are ignored
      # * faculty_status - string to use for author_status -- if author is faculty
      #
      # returns nil if the hsh contains no title
      #
      # if no department is found   --> hsh[department] = 'unknown'   and add to hsh[notes]
      # if no journal is found   --> hsh[journal] = 'unknown journal' and add to hsh[notes]
      # if author info can be matched against known authors
      #   * set status to faculty_status
      #   * note if author is different from requester
      #   * note any changes  in email , department, first/last name, ...
      # if there is no match
      #   * set status to unknown
      #   * mark  as ERROR - in notes field
      #   * note requester's emplid
      def process_row(hsh, _run, _crosswalk, faculty_status)
        #  ignore line if title.nil?
        return nil if hsh[:title].nil?

        # find matching info in author engine
        author, msg = match_author(hsh)
        hsh[:author_status] = author.empty? ? "unknown" : faculty_status
        hsh[:notes] += "\n" + "IMPORT-INFO: Legacy waiver for author with #{hsh[:author_status]} status"
        hsh[:notes] += "\n" + "IMPORT-INFO: #{msg}"

        if !author.empty?
          # fix up discrepancies
          if hsh[:author_unique_id] != author["unique_id"]
            hsh[:notes] += "\n" + "IMPORT-INFO: requested by user with emplId #{hsh[:author_unique_id]} "
            hsh[:author_unique_id] = author["unique_id"]
          end
          %w[department first_name last_name].each do |prop|
            hshpropindx = ("author_" + prop).to_sym
            value = hsh[hshpropindx]
            property_value = author[prop.to_s]

            if value.casecmp(property_value).zero?
              hsh[:notes] += "\n" + "IMPORT-INFO: changed #{prop} from original value '#{hsh[hshpropindx]}' to '#{author[prop.to_s]}' "
              hsh[hshpropindx] = author[prop.to_s]
            end
          end
        else
          # we don't know what to do with this author - import as NOMATCH/status='unknown' record
          hsh[:notes] += "\n" + "IMPORT-INFO: requested by user with emplId '#{hsh[:author_unique_id]}' "
          hsh[:author_unique_id] = nil
        end
        hsh["author_email"] = author["email"] || "unknown@princeton.edu"

        if hsh[:author_department].nil?
          hsh[:author_department] = "unknown"
          hsh[:notes] = hsh[:notes] + "\n" + "IMPORT-ERROR: missing department info in legacy data"
        end
        if hsh[:journal].nil?
          hsh[:journal] = "unknown journal"
          hsh[:notes] += "\n" + "IMPORT-ERROR: missing journal info in legacy data"
        end

        # create and return
        WaiverInfo.create(hsh)
      end

      def row_into_hsh(crosswalk, row)
        hsh = {}
        crosswalk.each do |k, v|
          hsh[k] = row[v].nil? ? nil : row[v].strip
        end
        hsh[:author_unique_id] = hsh[:author_unique_id].rjust(9, "0")
        hsh[:author_status] = "imported"
        hsh[:created_at] = DateTime.strptime(hsh[:created_at], "%Y-%m-%d %H:%M:%S")
        hsh
      end

      # try to find a matching author
      # return [author, nil]   where author may be nil and msg contains an explanation for the match decision
      #
      # note that hsh[author_unique_id]  really represents the employee id of the requester
      #
      # authors match a faculty author if
      #   * requester_unique_id can be associated with an employee/author record and the last_names match
      #   * or if the solr match  on last_name   or last_name, first_name matches exactly one record  and the match is acceptable
      #   * or if the author with the give the princeton netid given in the hsh is considered acceptable
      #
      # aceptability is determined by the accept_author? method
      #
      def match_author(hsh)
        # if author_unique_id leads to record with same last name use that author_info
        uri = URI(AuthorStatus.generate_uid_url(hsh[:author_unique_id], "json"))
        puts "URI: " + uri.to_s
        res = Net::HTTP.get_response(uri)
        raise("No response from author engine") if res.response.code != "200"

        author = get_author_hash(res)
        # match if last_name and unique_id ad department are the same
        puts hsh
        puts author
        accept = !author.empty?
        accept &&= author["last_name"] and author["department"]
        accept &&= normalize(author["last_name"]) == normalize(hsh[:author_last_name])
        accept &&= normalize_department_name(author["department"] == normalize_department_name(hsh[:author_department]))
        return [author, "matched based on '#{hsh[:author_unique_id]}' '#{author['last_name']}'"] if accept

        # lets see whether we can
        # - find unique author match when querying with lastname, firstname
        # - and then see whether results is acceptable
        uri = URI(GetNameSearchUrl(normalized_full_name(hsh[:author_last_name], hsh[:author_first_name])))
        puts "URI: " + uri.to_s
        res = Net::HTTP.get_response(uri)
        if res.response.code == "200"
          list = JSON.parse(res.response.body)
          raise "Bad response - result is a #{author.class} - should be Array" if list.class != Array

          list.each do |l|
            author = l
            puts "CHECK AUTHOR #{[author['preferred_name'], author['last_name'], author['first_name']]}"
            accepted, reason = accept_author?(author, hsh)
            if accepted
              puts "ACCEPTING AUTHOR #{author.inspect}"
              return [author, reason]
            end
          end
        end

        [{}, "no matching author record"] # we have no good idea how to match the author data
      end

      def normalized_full_name(last_name, first_name)
        last_name + ", " + first_name.split.collect { |s| s.sub(/[^a-z]$/, "") }.select { |s| s.length > 1 }.join(" ")
      end

      def get_author_hash(res)
        author = if res.response.body == "null"
                   {}
                 else
                   JSON.parse(res.response.body)
                 end
        raise "Bad response - result is a #{author.class} - should be Hash" if author.class != Hash

        author
      end

      # acceptable if
      #   normalized last names
      #   and  normalized first_names are the same
      #        or normalized first_name is prefix of normalized first_name from the other data set
      #   and  normalized department names are same as well
      #
      # author is hash based on API request to authors data
      # hsh based on csv row
      #
      # return [accepted?, reason]
      def accept_author?(author, hsh)
        return [false, "empty"] if author.empty? || author["last_name"].empty?
        return [false, "rejected on account of last_name mismatch, '#{author['last_name']}'"] if normalize(author["last_name"]) != normalize(hsh[:author_last_name])

        # check whether first names are the same or one is prefic of the other
        accept = normalize(author["first_name"]) == normalize(hsh[:author_first_name])
        accept ||= hsh[:author_first_name].length > 3 and normalize(author["first_name"]).starts_with?(normalize(hsh[:author_first_name]))
        accept ||= author["first_name"].length > 3 and normalize(hsh[:author_first_name]).starts_with?(normalize(author["first_name"]))
        return [false, "rejected on account of first_name mismatch, '#{author['first_name']}'"] unless accept

        # last_name the same, department matches ?
        a_dept = normalize_department_name(author["department"])
        h_dept = normalize_department_name(hsh[:author_department])
        if a_dept == h_dept
          [true, "accepted on account of first_name #{hsh[:author_first_name]}, last_name #{hsh[:author_last_name]}, and department #{hsh[:author_department]}"]
        else
          [false, "rejected on account of department mismatch, '#{author['department']}'"]
        end
      end

      def normalize(name)
        name.gsub(/[^0-9a-z]/i, "").upcase
      end

      def normalize_department_name(dept)
        parts = dept.upcase.split
        ndept = ""
        parts.each do |p|
          next if p.starts_with?("DEP")
          next if ["OF", "AND", "&"].include?(p)

          ndept = ndept + " " + p
        end
        ndept.strip
      end
    end
  end
end

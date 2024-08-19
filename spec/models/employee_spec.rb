# frozen_string_literal: true

require "rails_helper"

RSpec.describe Employee, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:employee)).to be_valid
  end

  %i[first_name last_name unique_id email department netid].each do |field|
    it("can't create without " + field.to_s) do
      obj = FactoryBot.build(:employee, field => nil)
      expect(obj.valid?).to eq(false)
      expect(obj.errors.messages[field]).not_to eq(nil)
    end
  end

  it("can't create with empty preferred_name ") do
    field = :preferred_name
    obj = FactoryBot.build(:employee, field => "  ")
    expect(obj.valid?).to eq(false)
    expect(obj.errors.messages[field]).not_to eq(nil)
  end

  it("derives preferred_name if nil") do
    field = :preferred_name
    obj = FactoryBot.build(:employee, field => nil)
    expect(obj.valid?).to eq(true)
    expect(obj.preferred_name).not_to eq(nil)
  end

  %i[unique_id netid email].each do |field|
    it("#{field} is unique") do
      obj = FactoryBot.build(:employee,
                              unique_id: "123123123",
                              netid: "netid",
                              email: "netid@princeon.edu")
      expect(obj.save).to eq(true)
      obj = obj.dup
      obj.unique_id = "321321321" unless field == :unique_id
      obj.netid = "other" unless field == :netid
      obj.email = "other@princeton.edu" unless field == :email
      expect(obj.valid?).to eq(false)
      expect(obj.errors.messages[field]).not_to eq(nil)
      described_class.destroy_all
    end
  end

  %i[netid email].each do |field|
    %i[upcase downcase].each do |fct|
      it("unique #{field}: #{fct} or not is the same") do
        obj = FactoryBot.build(:employee,
                                unique_id: "123123123",
                                netid: "netId",
                                email: "walter.FRITX@bier.de")
        expect(obj.save).to eq(true)
        dup = FactoryBot.build(:employee,
                                unique_id: "312312312",
                                netid: "xId",
                                email: "xyz@bier.de")
        other = (obj.send field).send fct
        dup.netid = other if field == :netid
        dup.email = other if field == :email
        expect(dup.valid?).to eq(false)
        expect(dup.errors.messages[field]).not_to eq(nil)
        described_class.destroy_all
      end
    end
  end

  bad_unique_ids = ["1234-6789", "1234567899", "12345 678", "aberdeftg", 12.90]
  bad_unique_ids.each do |bad_id|
    it("can't create with unique_id '" + bad_id.to_s + "'") do
      obj = FactoryBot.build(:employee, unique_id: bad_id)
      expect(obj.valid?).to eq(false)
      expect(obj.errors.messages[:unique_id]).not_to eq(nil)
    end
  end

  it('unique_id = 1 --> "000000001"') do
    obj = FactoryBot.build(:employee, unique_id: 1)
    expect(obj.valid?).to eq(true)
    expect(obj.unique_id).to eq("000000001")
  end

  # Solr search test are unreliable
  xit "search_all_by_name (unreliable solr test)" do
    i = 0
    ["Chemistry", "Future Past"].each do |dn|
      %w[David Maria Jane].each do |fn|
        %w[Smith Jones Jones].each do |ln|
          netid = "#{fn.downcase}#{i}"
          obj = described_class.create(
            first_name: fn,
            last_name: ln,
            unique_id: "0" + i.to_s,
            department: dn,
            netid: netid,
            email: "#{netid}@princeton.edu"
          )
          obj.save!
          i += 1
        end
      end
    end
    obj = described_class.create(
      first_name: "Hannah",
      last_name: "David",
      unique_id: "1" + i.to_s,
      department: "Physics",
      netid: "xxx",
      email: "xxx@princeton.edu"
    )
    obj.save!
    e = described_class.first
    e.preferred_name = "nowhere-else"
    e.save!
    described_class.all.each { |klass| puts klass.inspect }
    sleep(1)
    cases = { "Chemistry" => 0, "Jane" => 6, "David" => 7, "nowhere-else" => 1, "Jones" => 12 }
    cases.each do |word, cnt|
      puts [word, cnt].inspect
      matches = described_class.all_by_name(word)
      matches.results.each { |match| puts "#{word}: #{match.inspect}" }
      expect(matches.results.count).to eq(cnt)
    end
  end

  # Solr search test are unreliable
  xit "all_by_department (unreliable solr test)" do
    i = 0
    %w[Comedy Comedy Science].each do |dn|
      obj = FactoryBot.build(:employee, department: dn,
                                        netid: "netid#{i}", unique_id: i.to_s, email: "netid#{i}@princeton.edu")
      obj.save!
      i += 1
    end
    cases = { "Comedy" => 2, "Science" => 1, "Noonono" => 0 }
    # puts cases
    cases.each do |word, cnt|
      puts [word, cnt].inspect
      matches = described_class.all_by_department(word)
      matches.results.each { |e| puts "#{word}: #{e.inspect}" }
      expect(matches.results.count).to eq(cnt)
    end
  end

  it("load excel file: spec/data/employee_2.csv") do
    result = described_class.loadCsv("spec/data/employee_2.csv", Rails.logger)
    expect(result[:loaded]).to eq(2)
    expect(result[:skipped]).to eq(1)
    expect(result[:failed].empty?).to eq(true)
  end

  it("load excel file: spec/data/employee_3_9_errors.csv") do
    result = described_class.loadCsv("spec/data/employee_3_9_errors.csv", Rails.logger)
    expect(result[:loaded]).to eq(3)
    expect(result[:skipped]).to eq(1)
    expect(result[:failed].keys.count).to eq(9)
  end

  describe "#format_unique_id" do
    subject(:employee) { FactoryBot.build(:employee) }
    let(:unique_id) { "123456789" }

    it "formats the value and sets the attribute value" do
      employee.unique_id = unique_id
      employee.format_unique_id
      expect(employee.unique_id).to eq("123456789")
    end

    context "when the unique ID is an integer" do
      let(:unique_id) { 123_456_789 }

      it "formats the value and sets the attribute value" do
        employee.unique_id = unique_id.to_i
        employee.format_unique_id
        expect(employee.unique_id).to eq("123456789")
      end
    end

    context "when the unique ID is an invalid argument" do
      let(:unique_id) { nil }

      before do
        allow(Rails.logger).to receive(:warn)
      end

      it "logs an error" do
        employee.unique_id = unique_id
        employee.format_unique_id

        expect(Rails.logger).to have_received(:warn).with("Invalid unique ID:  (NilClass)")
      end
    end
  end

  describe "#solr_index" do
    let(:opts) do
      {
        batch_size: 1,
        first_id: 1
      }
    end

    before do
      allow(Sunspot).to receive(:index)
    end

    xit "indexes the models into Solr" do
      described_class.solr_index(opts)

      expect(Sunspot).to have_received(:index)
    end
  end

  describe "#all_by_name" do
    let(:employee) { FactoryBot.create(:employee_faked) }

    before do
      employee
    end

    it "searches for all models by :all_names" do
      search = described_class.all_by_name(employee.first_name)
      expect(search).to be_a(Sunspot::Search::StandardSearch)
    end
  end

  describe "#all_by_department" do
    let(:employee) { FactoryBot.create(:employee_faked) }

    before do
      employee
    end

    it "searches for all models by :department" do
      search = described_class.all_by_department(employee.department)
      expect(search).to be_a(Sunspot::Search::StandardSearch)
    end
  end
end

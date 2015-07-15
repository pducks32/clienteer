require 'open-uri'
require 'json'

require 'dotenv/tasks'

module IdealProtein
  class Clean
    EDIT_URL_REGEX = /\/clinic\/(\d+)\/dieter\/(\d+)\/edit/.freeze
    class << self
      def open_file
        File.read("data/ideal_protein.json")
      end

      def data
        @data ||= JSON.parse(open_file)
      end

      def cleaned_data
        @cleaned_data ||= data["aaData"].map do |r|
          row = {}
          row[:first_name], row[:last_name] = r[0].split(" ")
          row[:birthday] = r[1]
          row[:empty] = r[2]
          row[:email] = r[3]
          row[:phase] = r[4][-1].to_i
          row[:verified] = r[5].to_i.eql?(1)
          row[:ideal_subscription_id] = r[6]["edit"]["attr"]["href"].match(EDIT_URL_REGEX)[1].to_i
          row
        end
      end
    end
  end

  class Update

    LOGIN_COOKIES = ENV["CLIENTEER_LOGIN_COOKIES"]
    class << self

      def ideal_protein_path(number: total_clients_number, page: 2)
        "http://my.idealprotein.com/clinic/12195/dieter/browse.json?sEcho=#{page}&iColumns=7&sColumns=&iDisplayStart=0&iDisplayLength=#{number}&mDataProp_0=0&mDataProp_1=1&mDataProp_2=2&mDataProp_3=3&mDataProp_4=4&mDataProp_5=5&mDataProp_6=6&sSearch=&bRegex=false&sSearch_0=&bRegex_0=false&bSearchable_0=true&sSearch_1=&bRegex_1=false&bSearchable_1=true&sSearch_2=&bRegex_2=false&bSearchable_2=true&sSearch_3=&bRegex_3=false&bSearchable_3=true&sSearch_4=&bRegex_4=false&bSearchable_4=true&sSearch_5=&bRegex_5=false&bSearchable_5=true&sSearch_6=&bRegex_6=false&bSearchable_6=true&iSortCol_0=0&sSortDir_0=asc&iSortingCols=1&bSortable_0=true&bSortable_1=true&bSortable_2=true&bSortable_3=true&bSortable_4=true&bSortable_5=true&bSortable_6=false&sDateFrom=&sDateTo=&sPhase=&sStatus="
      end

      def total_clients_number
        @@total_clients_number ||= begin
          response = make_request url: ideal_protein_path(number: 1)
          response["iTotalRecords"].to_i
        end
      end

      def make_request(url: )
        buffer = open(url, "Cookie" => LOGIN_COOKIES).read
        JSON.parse(buffer)
      end

      def get_clients
        make_request url: ideal_protein_path
      end
    end
  end
end


namespace "ideal_protein" do

  task :default => :clean

  desc "Cleans Ideal Protein client information"
  task :clean => :dotenv do
    json = IdealProtein::Clean.cleaned_data
    Dir.mkdir "data" unless Dir.exists? "data"
    File.open("data/ideal_protein.clean.json", "w+") do |f|
      f.write(JSON.pretty_generate(json))
    end
  end

  desc "Updates Ideal Protein client information"
  task :update => :dotenv do
    json = IdealProtein::Update.get_clients
    Dir.mkdir "data" unless Dir.exists? "data"
    File.open("data/ideal_protein.json", "w+") do |f|
      f.write(JSON.pretty_generate(json))
    end
  end
end

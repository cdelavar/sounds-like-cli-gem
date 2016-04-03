require 'HTTParty'
require 'JSON'
require 'csv'
require 'mechanize'
require 'open-uri'
require 'pry'
require 'io/console'



class Scraper

  def initialize(agent = nil)
    @agent = Mechanize.new
  end

  def sign_in
    page = @agent.get('https://secure.meetup.com/login/')
    sign_in = page.forms[1]
    puts "Email: "
    sign_in.email = gets.chomp
    puts "Password: "
    sign_in.password = STDIN.noecho(&:gets).chomp
    page = @agent.submit(sign_in)
    self
  end

  def get_api_key
    api_key = @agent.get('https://secure.meetup.com/meetup_api/key/').css("#api-key-reveal").first.attribute("value").text
  end

  def parse_meetups
    sign_in
    url = "https://api.meetup.com/2/events?key=#{get_api_key}&sign=true&photo-host=public&rsvp=yes&status=past"
    results = @agent.get(url)
    save = results.content
    parsed_results = JSON.parse(save)
    parsed_results["results"]
  end
    

  def make_meetups
    parse_meetups.each do |attributes|
      Meetup.new(attributes)
    end
  end
end
  
class Meetup

  @@all = []

  def initialize(attributes)
    attributes.each do |attribute_name, attribute_value|
      self.class.send(:define_method, "#{attribute_name}=".to_sym) do |value|
        instance_variable_set("@" + attribute_name.to_s, value)
      end

      self.class.send(:define_method, attribute_name.to_sym) do
        instance_variable_get("@" + attribute_name.to_s)
      end

      self.send("#{attribute_name}=".to_sym, attribute_value)
      
    end 
    @@all << self
  end

  def self.all
    @@all
  end
end

binding.pry















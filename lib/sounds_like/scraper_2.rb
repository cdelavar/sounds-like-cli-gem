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
    binding.pry
  end
    

  def make_meetups
    parse_meetups.each do |meetup|
      Meetup.new_meetup(meetup)
    end
  end
end
  
class Meetup
  attr_accessor :name, :group_name, :date, :venue, :url, :description

  @@all = []

  def self.new_meetup(meetup)
    self.new(meetup["name"], meetup["group"]["name"],
      (meetup["time"], meetup["event_url"])
      )

  end
end

binding.pry















require 'HTTParty'
require 'JSON'
require 'csv'
require 'mechanize'
require 'open-uri'
require 'pry'
require 'io/console'



class Scraper

  def mechanize
    agent = Mechanize.new
    page = agent.get('https://secure.meetup.com/login/')
    sign_in = page.forms[1]
    puts "Email: "
    sign_in.email = gets.chomp
    puts "Password: "
    sign_in.password = STDIN.noecho(&:gets).chomp
    page = agent.submit(sign_in)
    groups_page = agent.page.link_with(:text => "Groups").click
  end
  

  def get_api_key
    api_key = gets.chomp
  end

  def get_event_ids
    groups = mechanize.link_with(:text => "Groups").click
    
  end

  def get_page
    url = "https://api.meetup.com/2/rsvps?key=#{get_api_key}&event_id=229834226&order=name"
    doc = Nokogiri::HTML(open(url))
  end
end

binding.pry







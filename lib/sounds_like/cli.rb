class SoundsLike::CLI
  def call
    SoundsLike::Scraper.new.make_artists
    puts "Welcome"
    
  end

  
end
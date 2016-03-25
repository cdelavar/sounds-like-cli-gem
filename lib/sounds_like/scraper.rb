class SoundsLike::Scraper

  @@bands_array = [].reject{ |e| e.empty? }
  @@band_names = []

  def get_band_name
    puts "Sounds like which artist?"
    artist = gets.strip
    searchable_artist = artist.gsub(" ", "+")
    searchable_artist
  end

  def get_page
    url = "http://www.last.fm/music/#{get_band_name}/+similar?page=1"
    page = HTTParty.get(url)
    parse_page = Nokogiri::HTML(page)
    parse_page
    binding.pry
  end

  def get_similar_artists
    band_block = parse_page.css(".grid-items-section").css("a")
    band_block.each do |item|
      @@bands_array << item.text
    end
    @@bands_array
  end

  def artist_choice
    puts "Select band for more info: "
    artist = gets.strip
    if artist != "Next"
      url = "http://www.last.fm/music/#{artist}"
    else
      url = "http://www.last.fm/music/#{get_band_name}/+similar?page=2"
    end
    page = HTTParty.get(url)
    parse_page = Nokogiri::HTML(page)
  end
end




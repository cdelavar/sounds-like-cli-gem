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
    artists = parse_page.css(".grid-items-section").css("a")
    artists
    binding.pry
  end

  def get_similar_artists
    get_page.each do |item|
      @@bands_array << item.text
    end
    @@bands_array
  end

  def make_artists
    get_page.each do |r|
      SoundsLike::Artist.new_from_artist_list(r)
    end
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




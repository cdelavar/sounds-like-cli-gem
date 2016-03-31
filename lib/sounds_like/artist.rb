class SoundsLike::Artist
  attr_accessor :name, :info, :top_tracks, :top_albums, :genres, :url

  @@all = []

  def self.new_from_artist_list(r)
    self.new(r.text, "www.last.fm#{r.attribute("href").value}",
      "www.last.fm#{r.attribute("href").value}/+wiki#{.css(".wiki-content p")}")
  end

  def initialize(name, url)
    @name = name
    @url = url
    @info = info
    @@all << self
  end

  def self.all?
    @@all
  end
end
class Album
  attr_reader :title, :artist, :played
  alias_method :played?, :played
  
  def initialize(title:, artist:)
    @title, @artist = title, artist
    @played = false
  end

  def to_s
    "\"#{title}\" by #{artist} (#{played_string})"
  end

  def play
    @played = true
  end

  private
  def played_string
    played? ? 'played' : 'unplayed'
  end
end

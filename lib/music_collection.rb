require_relative 'album.rb'

class MusicCollection
  def initialize
    @albums = []
  end
  
  def response(line)
    add(line) || play(line) || show_all(line) || show_unplayed(line) || show_all_by_artist(line) || show_unplayed_by_artist(line) || "Invalid command\n"
  end

  private

  def add(line)
    return false unless match_data = line.match(/add \"(.+?)\" \"(.+?)\"/)
    
    title, artist = match_data.captures

    if @albums.any? { |album| album.title == title }
      return "\"#{title}\" is already in the collection\n"
    end

    @albums << Album.new(title: title, artist: artist)

    "Added \"#{title}\" by #{artist}\n"
  end

  def play(line)
    return false unless match_data = line.match(/play \"(.+?)\"/)
    
    title = match_data.captures.first

    album = @albums.detect { |album| album.title == title }

    return "\"#{title}\" is not in the collection\n" unless album

    album.play

    "You're listening to \"#{title}\"\n"
  end

  def show_all(line)
    return false unless line == 'show all'

    @albums.map(&:to_s) * "\n" + "\n"
  end
    
  def show_unplayed(line)
    return false unless line == 'show unplayed'

    @albums.reject(&:played?).map(&:to_s) * "\n" + "\n"
  end

  def show_all_by_artist(line)
    return false unless match_data = line.match(/show all by \"(.+?)\"/)

    artist = match_data.captures.first

    @albums.select { |album| album.artist == artist }.map(&:to_s) * "\n" + "\n"
  end

  def show_unplayed_by_artist(line)
    return false unless match_data = line.match(/show unplayed by \"(.+?)\"/)

    artist = match_data.captures.first

    @albums.select { |album| album.artist == artist && !album.played?}
      .map(&:to_s) * "\n" + "\n"
  end
end

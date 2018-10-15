require_relative '../lib/album.rb'

describe Album do
  let(:title) { 'Ride the Lightning' }
  let(:artist) { 'Metallica' }
  subject(:album) { Album.new(title: title, artist: artist) }
    
  describe '#initialize/attr_reader' do
    it 'sets the title and artist' do
      expect(album.title).to eq(title)
      expect(album.artist).to eq(artist)
      expect(album).not_to be_played
    end
  end

  describe '#to_s' do
    it 'returns the display string' do
      expect(album.to_s).to eq("\"Ride the Lightning\" by Metallica (unplayed)")
    end
  end

  describe '#play' do
    it 'marks the album as played' do
      album.play
      expect(album).to be_played
      expect(album.to_s).to eq("\"Ride the Lightning\" by Metallica (played)")
    end
  end
end

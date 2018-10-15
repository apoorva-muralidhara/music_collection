require_relative '../lib/music_collection.rb'

describe MusicCollection do
  describe '#response' do
    context 'when the command is invalid' do
      let(:command) { "wombat \"Metallica\"" }
      let(:response) { "Invalid command\n" }
      it 'returns invalid command response' do
        expect(described_class.new.response(command)).to eq(response)
      end
    end

    describe 'add' do
      context 'when adding distinct albums' do
        it 'returns "Added" response' do
          music_collection = described_class.new
          expect(music_collection
                  .response("add \"Ride the Lightning\" \"Metallica\""))
            .to eq("Added \"Ride the Lightning\" by Metallica\n")
          expect(music_collection
                  .response("add \"Licensed to Ill\" \"Beastie Boys\""))
            .to eq("Added \"Licensed to Ill\" by Beastie Boys\n")
        end
      end

      context 'when adding an album with the same title' do
        it 'returns an error message' do
          music_collection = described_class.new
          expect(music_collection
                  .response("add \"Ride the Lightning\" \"Metallica\""))
            .to eq("Added \"Ride the Lightning\" by Metallica\n")
          expect(music_collection
                  .response("add \"Ride the Lightning\" \"Texas Polka Band\""))
            .to eq("\"Ride the Lightning\" is already in the collection\n")
        end
      end
    end

    describe 'play' do
      let(:command) { 'play "The Dark Side of the Moon"' }
      let(:response) { "You're listening to \"The Dark Side of the Moon\"\n" }

      context 'when the album is not in the collection' do
        it 'returns an error message' do
          expect(described_class.new.response(command))
            .to eq("\"The Dark Side of the Moon\" is not in the collection\n")
        end
      end

      context 'when the album is in the collection' do
        it "returns \"You're listening\" message" do
          music_collection = described_class.new
          music_collection
            .response("add \"The Dark Side of the Moon\" \"Pink Floyd\"")
          expect(music_collection.response(command)).to eq(response)
        end
        
        it 'marks the album as played' do
          music_collection = described_class.new
          music_collection
            .response("add \"The Dark Side of the Moon\" \"Pink Floyd\"")
          music_collection.response(command)
          expect(music_collection.response('show all'))
            .to eq("\"The Dark Side of the Moon\" by Pink Floyd (played)\n")
        end
      end
    end

    describe 'show all' do
      let(:command) { 'show all' }
      let(:response) do
        <<~HEREDOC
          "Ride the Lightning" by Metallica (unplayed)
          "Licensed to Ill" by Beastie Boys (played)
          "Pauls Boutique" by Beastie Boys (unplayed)
          "The Dark Side of the Moon" by Pink Floyd (played)
        HEREDOC
      end

      it 'returns a list of all the albums in the collection' do
        expect(partially_played_music_collection.response(command)).to eq(response)
      end
    end

    describe 'show unplayed' do
      let(:command) { 'show unplayed' }

      let(:response) do
        <<~HEREDOC
          "Ride the Lightning" by Metallica (unplayed)
          "Pauls Boutique" by Beastie Boys (unplayed)
        HEREDOC
      end

      it 'returns a list of all the unplayed albums in the collection' do
        expect(partially_played_music_collection.response(command)).to eq(response)
      end
    end

    describe 'show all by artist' do
      let(:command) { 'show all by "Beastie Boys"' }

      let(:response) do
        <<~HEREDOC
          "Licensed to Ill" by Beastie Boys (played)
          "Pauls Boutique" by Beastie Boys (unplayed)
        HEREDOC
      end

      it 'returns a list of all the unplayed albums in the collection' do
        expect(partially_played_music_collection.response(command)).to eq(response)
      end
    end

    describe 'show unplayed by artist' do
      let(:command) { 'show unplayed by "Beastie Boys"' }

      let(:response) do
        <<~HEREDOC
          "Pauls Boutique" by Beastie Boys (unplayed)
        HEREDOC
      end

      it 'returns a list of all the unplayed albums in the collection' do
        expect(partially_played_music_collection.response(command)).to eq(response)
      end
    end

    def partially_played_music_collection
      described_class.new.tap do |music_collection|
        music_collection.response("add \"Ride the Lightning\" \"Metallica\"")
        music_collection.response("add \"Licensed to Ill\" \"Beastie Boys\"")
        music_collection.response("add \"Pauls Boutique\" \"Beastie Boys\"")
        music_collection.response("add \"Ride the Lightning\" \"Texas Polka Band\"")
        music_collection.response("add \"The Dark Side of the Moon\" \"Pink Floyd\"")
        music_collection.response('play "Licensed to Ill"')
        music_collection.response('play "The Dark Side of the Moon"')
      end
    end

  end
end

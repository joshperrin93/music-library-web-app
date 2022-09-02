require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums' do
    it 'should return a list of albums' do
      response = get("/albums")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include(
        '<p>Title: I Put a Spell on You</p>
        <p>Released: 1965</p>'
      )
      expect(response.body).to include('<a href="albums/2">See more info</a>')
    end
  end

  context 'POST /albums' do
    it 'should validate album parameters' do
      response = post(
        'albums',
        title: 'Voyage',
        artist_id: '2'
      )
      expect(response.status).to eq(400)
    end

    it 'should create a new album' do
      response = post(
        'albums',
        title: 'Voyage',
        release_year: '2022',
        artist_id: '2'
      )
      expect(response.status).to eq(200)
      expect(response.body).to include ('<p>Your album has been added!</p>')
      
      response = get("/albums")
      expect(response.body).to include ("Voyage")
    end
  end

  context 'GET /artists' do
    it 'will returns all artists' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include ('<h1>Artists</h1>')
      expect(response.body).to include ('<a href="/artists/1">View artist info</a>')
    end
  end

  context 'POST /artists' do
    it 'should validate artist parameters' do
      response = post('artists', name: 'Goldie Lookin Chain')
      expect(response.status).to eq(400)
    end

    it 'creates a new artist' do
      response = post('/artists', name: 'Goldie Lookin Chain', genre: 'Parody')

      expect(response.status).to eq(200)
      expect(response.body).to include ('<p>Your artist has been added!</p>')

      response = get('/artists')
      expect(response.body).to include 'Goldie Lookin Chain'
    end
  end

  context 'GET /albums/:id' do
    it 'gets a specific album' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Released: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context 'GET /artists/:id' do
    it 'returns details of a specific artist' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include ('<h1>Pixies</h1>')
      expect(response.body).to include ('Genre: Rock')
    end
  end

  context 'GET /albums/new' do
    it 'has a form to create a new album' do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add a new album</h1>')
      expect(response.body).to include('<form action="/albums" method="POST">')
      expect(response.body).to include('<input type="text" name="title">')
      expect(response.body).to include('<input type="text" name="release_year">')
      expect(response.body).to include('<input type="submit" value="Submit the form">')
    end
  end

  context 'GET /artists/new' do
    it 'has a form to create a new artist' do
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Add a new artist</h1>')
      expect(response.body).to include('<form action="/artists" emthod="POST">')
      expect(response.body).to include('<input type="text" name="name">')
      expect(response.body).to include('<input type="text" name="genre">')
      expect(response.body).to include('<input type="submit" value="Submit the form">')
    end
  end
end

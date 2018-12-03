require 'sinatra'
require 'httparty'

class Books < Sinatra::Base
  get('/') do
    erb(:search)
  end

  get('/search') do
    uri = 'https://www.googleapis.com/books/v1/volumes'
    generic_thumb = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Book_important2.svg/128px-Book_important2.svg.png"

    query = { 
      projection: 'lite',
      maxResults: 8,
      q: params[:search] 
    }
    response = HTTParty.get(uri, {query: query})
    @results = response['items'].map do |item|
      info = item['volumeInfo']
      { authors:    (info.dig('authors') || []).join('; '),
        title:      info.dig('title'),
        publisher:  info.dig('publisher'),
        link:       info.dig('infoLink'),
        thumb:      info.dig('imageLinks','smallThumbnail') || generic_thumb
      }
    end
    erb(:results)
  end
end

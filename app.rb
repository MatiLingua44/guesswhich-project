require 'sinatra'

get '/' do
    "Hola Sinatra!"
end

get '/page/:id' do
    puts "some client tried to get page: #{params['id']}"
    params['id']
end
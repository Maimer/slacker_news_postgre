require 'sinatra'

require_relative 'helpers'

get '/' do
  @articles = find_articles()
  erb :index
end

get '/submit' do
  @author = ""
  @title = ""
  @url = ""
  @desc = ""
  @resubmit = false
  erb :'submit/submit'
end

post '/submit' do
  @articles = find_articles()
  @author = params["author"]
  @title = params["title"]
  @url = params["url"]
  @desc = params["desc"]
  if check_blanks(@author, @title, @url, @desc) || check_url(@url) || check_desc(@desc) || check_dupurl(@url, @articles)
    @resubmit = true
    erb :'submit/submit'
  else
    save_article(@author, @url, @title, @desc)
    redirect '/'
  end
end

get '/article/:id' do
  @id = params[:id]
  @resubmit = false
  erb :'article/article'
end

post '/article/:id' do
  @id = params[:id]
  @author = params["author"]
  @comment = params["comment"]
  if check_author(@author) || check_desc(@comment)
    @resubmit = true
    erb :'article/article'
  else
    redirect '/article/:id'
  end
end

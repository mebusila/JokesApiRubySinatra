class Application < Sinatra::Base
  before do
    begin
      @limit = Integer(params[:limit])
    rescue
      @limit = 10
    end
    begin
      @offset = Integer(params[:offset])
    rescue
      @offset = 0
    end
    begin
      @tags = Array(params[:tags])
    rescue
      @tags = []
    end
    begin
      @lang = params[:lang]
    rescue
      @lang = null
    end
  end

  def get_count
    if @tags.any?
      count = Joke.where(:tags => @tags, :lang => @lang).count()
    else
      count = Joke.where(:lang => @lang).count()
    end
    halt(404, 'Not Found') if count == 0
    return count
  end

  get '/api/jokes' do
    content_type :json
    if @tags.any?
      jokes = Joke.limit(@limit).skip(@offset).where(:tags => @tags, :lang => @lang)
    else
      jokes = Joke.limit(@limit).skip(@offset).where(:lang => @lang)
    end
    { :jokes => jokes, :tags=>@tags, :total => self.get_count, :limit => @limit, :offset => @offset, :lang => @lang }.to_json
  end

  get '/api/jokes/random' do
    content_type :json
    count = get_count
    if @tags.any?
      offset = rand(count-@limit)
      jokes = Joke.limit(@limit).skip(offset).where(:tags => @tags, :lang => @lang)
    else
      offset = rand(count-@limit)
      jokes = Joke.limit(@limit).skip(offset).where(:lang => @lang)
    end
    { :jokes => jokes, :tags=>@tags, :total => count, :limit => @limit, :offset => offset, :lang => @lang }.to_json
  end

  get '/api/jokes/:id' do |id|
    joke = Joke.find(id) rescue nil
    halt(404, 'Not Found') if joke.nil?

    content_type 'application/json'
    { 'content' => joke }.to_json
  end

  post '/api/jokes' do
    content = Array(params[:content])
    halt(400) if content.nil? or !content.any?

    j = Joke.new(:content => content, :tags => params[:tags], :lang => params[:lang])
    halt(400) if !j.save

    response['Location'] = j.url
    response.status = 201
  end

  get '/' do
    haml :index
  end

  get '/joke/:id' do |id|
    joke = Joke.find(id) rescue nil
    halt(404, 'Not Found') if joke.nil?

    content = "";
    joke.content.each do |line|
      content+=line + '&#x0A;'
    end
    haml :view, :locals => { :joke => joke, :content=>content }
  end
end
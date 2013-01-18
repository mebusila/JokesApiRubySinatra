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
  end

  get '/api/jokes' do
    content_type :json
    if @tags.any?
      jokes = Joke.limit(@limit).skip(@offset).where(:tags => @tags)
      count = Joke.where(:tags => @tags).count()
    else
      jokes = Joke.limit(@limit).skip(@offset).all()
      count = Joke.count()
    end
    { :jokes => jokes, :tags=>@tags, :total => count }.to_json
  end

  get '/api/jokes/random' do
    content_type :json
    if @tags.any?
      count = Joke.where(:tags => @tags).count()
      offset = rand(0..count-@limit)
      jokes = Joke.limit(@limit).skip(offset).where(:tags => @tags)
    else
      count = Joke.count()
      offset = rand(0..count-@limit)
      jokes = Joke.limit(@limit).skip(offset).all()
    end
    { :jokes => jokes, :tags=>@tags, :total => count }.to_json
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

    j = Joke.new(:content => content, :tags => params[:tags])
    halt(400) if !j.save

    response['Location'] = j.url
    response.status = 201
  end
end
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
      @tags = nil
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

  post '/api/jokes' do
    content = params[:content]
    if content.nil? or content.empty?
      halt 400
    end
    j = Joke.new(:content => content, :tags => params[:tags])
    if j.save
      halt 200
    end
    halt 400
  end
end
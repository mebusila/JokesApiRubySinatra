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
      @tags = params[:tags]
    rescue
      @tags = nil
    end
  end

  get '/api/jokes' do
    content_type :json
    if(@tags)
      jokes = Joke.limit(@limit).skip(@offset).all(:tags => @tags)
    else
      jokes = Joke.limit(@limit).skip(@offset).all()
    end
    { :jokes => jokes, :tags=>@tags }.to_json
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
class Application < Sinatra::Base
  get '/' do
    "Hello visitor n" + Joke.increment.to_s
  end
end
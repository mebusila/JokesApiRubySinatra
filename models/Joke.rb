class Joke
  include Mongoid::Document

  field :content, :type => Array
  field :tags,    :type => Array
  field :lang,    :type => String

  def url
    "/api/jokes/#{self.id}"
  end
end
class Joke
  include Mongoid::Document

  field :content, :type => Array
  field :tags,    :type => Array
end
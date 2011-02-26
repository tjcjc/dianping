class Comment
  include Mongoid::Document
  field :date
  field :content
  embedded_in :hotel, :inverse_of => :comments
end

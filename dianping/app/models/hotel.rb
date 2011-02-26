class Hote
  include Mongoid::Document
  field :address
  field :telephone
  field :name
  field :price
  field :detail
  field :environment, :type => Integer
  field :delicious, :type => Integer
  field :server, :type => Integer
  field :feeling, :type => Float
  field :url
  field :recommend
  field :atomosphere
  field :feature
  embeds_many :comments
  referenced_in :city, :inverse_of => :hotel
  references_and_referenced_in_many :categories, :inverse_of => :hotels
  references_and_referenced_in_many :buses, :inverse_of => :hotels
  references_and_referenced_in_many :districts, :inverse_of => :hotels
  references_and_referenced_in_many :dishes, :inverse_of => :hotels
end

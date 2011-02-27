class Hotel
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
  referenced_in :city, :inverse_of => :hotels
  referenced_in :category, :inverse_of => :hotels
  references_and_referenced_in_many :buses, :inverse_of => :hotels
  referenced_in :district, :inverse_of => :hotels
  referenced_in :street, :inverse_of => :hotels
  references_and_referenced_in_many :dishes, :inverse_of => :hotels
end

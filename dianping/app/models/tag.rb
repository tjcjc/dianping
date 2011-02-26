class Tag
  include Mongoid::Document
  field :name
  references_many :hotels
end

class City < Tag
  references_many :districts
  
end

class District < Tag
  references_many :streets
  referenced_in :city, :inverse_of => :districts
  
end

class Street < Tag
  referenced_in :district, :inverse_of => :streets
  
end

class Category < Tag
  
end

class Bus
  include Mongoid::Document
  field :number, :type => Integer
  references_and_referenced_in_many :hotels, :inverse_of => :buses
  
end

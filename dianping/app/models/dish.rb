class Dish
  include Mongoid::Document
  references_and_referenced_in_many :hotels, :inverse_of => :dishes
end

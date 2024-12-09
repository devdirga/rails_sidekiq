class ProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :price, :description
end

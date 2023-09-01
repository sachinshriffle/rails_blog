class UserSerializer < ActiveModel::Serializer
  attributes :name ,:messages
  # has_many :articles

   def messages
    object.age
  end
end

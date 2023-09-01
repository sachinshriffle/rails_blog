class ArticleSerializer < ActiveModel::Serializer
  attributes :title
  has_many :comments
end

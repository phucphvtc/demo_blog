class BuildSerializer < ActiveModel::Serializer
  attributes :cpu,:main

  belongs_to :user
end

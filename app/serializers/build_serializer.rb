class BuildSerializer < ActiveModel::Serializer
  attributes :id, :cpu, :main, :psu, :cooler, :ssd, :ram, :gpu, :hdd

  # belongs_to :user
end

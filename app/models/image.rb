# == Schema Information
#
# Table name: images
#
#  id          :integer          not null, primary key
#  image       :string
#  parent_type :string
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_images_on_parent_type_and_parent_id  (parent_type,parent_id)
#

class Image < ApplicationRecord
    include Methods::Image
    include Scopes::Image
    include Validations::Image

    belongs_to :parent, polymorphic: true

    mount_uploader :image, AvatarUploader
end

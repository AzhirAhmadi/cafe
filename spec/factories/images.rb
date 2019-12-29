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


FactoryBot.define do
    factory :picture, class: Image do
        image { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/defultAvatar.jpg')) }
        parent {|a| a.association(:player)}
    end
end

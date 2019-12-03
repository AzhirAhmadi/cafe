# == Schema Information
#
# Table name: enrolments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  table_id   :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_enrolments_on_table_id                             (table_id)
#  index_enrolments_on_user_id                              (user_id)
#  index_enrolments_on_user_id_and_table_id_and_deleted_at  (user_id,table_id,deleted_at) UNIQUE
#

class Enrolment < ApplicationRecord
    include Generals::SoftDelete    

    include Methods::Enrolment
    include Scopes::Enrolment
    include Validations::Enrolment

    belongs_to :table
    belongs_to :user
end

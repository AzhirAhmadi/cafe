module  Validations::Enrolment
    def self.included base
        base.class_eval do
            validates :table, :user, presence: true
            validates :user_id, uniqueness: { scope: [:table_id, :deleted_at]}
            include ModelValidate::Enrolment

            validate :active_table, :active_user
        end
    end
end
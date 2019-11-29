module ModelValidate::Enrolment
    def active_table
        errors.add(:table, "is not active") unless  table&.active?
    end

    def active_user
        errors.add(:user, "is not active") unless  user&.active?
    end
end
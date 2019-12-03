module  Methods::Enrolment
    def self.included base
        base.class_eval do
            def enroled_at
                ccreated_at
            end
        end
    end
end
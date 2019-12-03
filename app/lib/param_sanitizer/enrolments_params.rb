
class  ParamSanitizer::EnrolmentsParams < ParamSanitizer::ParamSanitizer
    #           5               4               3               2               1
    # role: [   :sys_master,    :sys_admin,     :sys_expert,    :coffee_owner,    :player]
    def create_params
        return [:table_id] unless current_user.blank?
    end
end
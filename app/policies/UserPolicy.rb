class UserPolicy < ApplicationPolicy
    attr_reader :user, :args
  
    def initialize(user, args)
      @user = user
      @args = args
    end
  
    def profile?
        puts "**************************"
        true
    end
  end
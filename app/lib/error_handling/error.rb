class ErrorHandling::Error < StandardError
    @args
    def initialize(args={})
        @args = args
        self
    end
    
    def message
        "There no message for <" + self.class.to_s + ">"
    end

    def args
        @args 
    end
end
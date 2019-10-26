@@colors =[:green, :yellow, :cyan, :blue, :magenta]
@@light_colors=[:light_green, :light_yellow, :light_cyan, :light_blue, :light_magenta]

def check param
   MyLogger.add(caller_locations, param)
end

def start_check
    puts "start_check"
    MyLogger.start(caller_locations)
end

def end_check
    MyLogger.end 
end
class FileLog
    attr_reader :file_path, :file_name, :level
    @root
    def initialize(caller, param=nil, level)
        @root = []
        @file_path = caller.path
        @file_name = @file_path.split("/").last
        @level = level
        add_log caller, param unless param == nil
    end

    def add_log caller, param 
        line_on = caller.lineno.to_s
        new_log = Log.new(line_on, read_one_line(caller.path, line_on).strip.split(" ").last, param, @level+1)
        @root.push(new_log)
    end

    def add_file caller, param
        new_file = FileLog.new caller, param, @level+1

        @root.push(new_file)
    end

    def find caller_locations
        file_name = caller_locations[0].path.split("/").last
        if @file_name == file_name
            return self
        end
        result = nil
        @root.each do |item|
            if item.is_a? FileLog
                result = item.find caller_locations
            end
        end
        result
    end

    def parent file_stack
        x = file_stack.find{|item| item == @file_name}
        unless x == nil
            return self
        end

        result = nil
        @root.each do |item|
            if item.is_a? FileLog
                result = item.parent file_stack
            end
        end
        result
    end

    def show 
        (@level*4).times{print "*".send(@@colors[level-1])}
        puts file_name.send(@@colors[level-1])
        @root.each do |item|
            item.show
        end
        (@level*4).times{print "*".send(@@colors[level-1])}
        puts file_name.send(@@colors[level-1])
    end

    private
        def read_one_line file_name, line_number
            File.open(file_name)do |f|
                line = nil
                line_number.to_i.times { line = f.gets }
                return line
            end
        end
end

class Log
    attr_reader :line_on, :param_name, :param, :level

    def initialize(line_on, param_name, param, level)
        @param = param
        @line_on = line_on
        @param_name = param_name
        @level = level
    end

    def show
        (@level*4).times{print "*".send(@@light_colors[level-2])}

        print "line:"
        print line_on.send(@@light_colors[level-2])
        puts "> " + param_name.send(@@light_colors[level-2])

        (@level*4).times{print "*".send(@@light_colors[level-2])}
        puts param
    end
end

class MyLogger
    @@root = nil

    def self.start caller_locations
        @@root = FileLog.new caller_locations[0], 1
    end

    def self.add caller_locations, param
        caller = caller_locations[0]
        x = @@root.find caller_locations

        unless x == nil
            x.add_log caller, param
            return
        end

        file_stack = caller_locations.collect{|item| item.path.split("/").last}
        y = @@root.parent file_stack
           
        unless y == nil
            y.add_file caller, param
        end
    end

    def self.end
        @@root.show
    end
end
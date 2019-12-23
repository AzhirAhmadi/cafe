module Methods::Image
  def self.included base
    base.class_eval do
      def self.PP
        Image.all.order(id: :asc).each do  |item|
          puts "id: #{item.id} parent_type: #{item.parent_type} parent_id: #{item.parent_id} parent: #{item.parent}"
        end
        return nil
      end
    end
  end
end
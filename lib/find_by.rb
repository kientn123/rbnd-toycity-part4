class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |attribute|
      definition = %Q{
        def find_by_#{attribute}(arg)
          self.all.each do |product|
            return product if product.#{attribute} == arg
          end
        end
      }
      class_eval(definition)
    end
  end
end

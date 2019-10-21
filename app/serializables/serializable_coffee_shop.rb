class SerializableCoffeeShop < JSONAPI::Serializable::Resource
    type 'coffee_shops'
  
    attributes :name, :address

    has_one :owner do
      data do
        @object.owner
      end
    end

    has_one :maintainer do
      data do
        @object.maintainer
      end
    end

    has_one :creator do
      data do
        @object.creator
      end
    end
  end
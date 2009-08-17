class Flickr::Photos::Location

  attr_accessor :latitude, :longitude, :accuracy

  # Create an instance of Flickr::Photos::Location
  #
  # Params
  # * attributes (Required)
  #     a hash of attributes used to set the initial values of the Location object
  def initialize(attributes)
    case attributes
    when Flickr::Photos::Location
      return attributes
    when Hash
      attributes.each do |k,v|
        send("#{k}=", v)
      end
    when Array
      self.latitude, self.longitude, self.accuracy = attributes
    end
  end
end

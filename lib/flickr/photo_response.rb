# wrapping class to hold a photos response from the flickr api
#
class Flickr::Photos::PhotoResponse
  attr_accessor :page, :pages, :per_page, :total, :photos, :api, :method, :options
  
  # creates an object to hold the search response.
  # 
  # Params
  # * attributes (Required)
  #     a hash of attributes used to set the initial values of the response object
  def initialize(attributes)
    attributes.each do |k,v|
      send("#{k}=", v)
    end
  end

  # Create a PhotoResponse object from a typical flickr XML response
  def self.from_response(flickr, response, additional_options = {})
    returning new({
      :page     => response.photos[:page].to_i,
      :pages    => response.photos[:pages].to_i,
      :per_page => response.photos[:perpage].to_i,
      :total    => response.photos[:total].to_i,
      :photos   => []
    }.merge(additional_options)) do |photos|
      response.photos.photo.each do |photo|
        photos << Flickr::Photos::Photo.from_response(flickr, photo)
      end if response.photos.photo
    end
  end

  # Add a Flickr::Photos::Photo object to the photos array.  It does nothing if you pass a non photo object
  def <<(photo)
    self.photos ||= []
    self.photos << photo if photo.is_a?(Flickr::Photos::Photo)
  end

  # gets the next page from flickr if there are anymore pages in the current photos object
  def next_page
    api.send(self.method, options.merge(:page => self.page.to_i + 1)) if self.page.to_i < self.pages.to_i
  end

  # gets the previous page from flickr if there is a previous page in the current photos object
  def previous_page
    api.send(self.method, options.merge(:page => self.page.to_i - 1)) if self.page.to_i > 1
  end
  
  # passes all unknown request to the photos array if it responds to the method
  def method_missing(method, *args, &block)
    self.photos.respond_to?(method) ? self.photos.send(method, *args, &block) : super
  end
end
class Product < ActiveRecord::Base

  validates :title, :price, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: { case_sensitive: false },
                    length: { minimum: 10,
                    message: 'must be a minimum of 10 characters long'
                    }
  VALID_IMAGE_REGEX = %r(\S\.(png|jpg|gif)\Z)i
  validates :image_url, allow_blank: true, format: { 
                  with: VALID_IMAGE_REGEX,
                  message: 'must be a URL for JPG, PNG or GIF.'
                  }

  def self.latest
    Product.order(:updated_at).last 
  end
end

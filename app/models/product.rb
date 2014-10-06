class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

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

  private

    # Below hook method returns an error on the base object much like
    # a validation working on some given attribute of that object
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Cannot delete. Line items present.')
        return false
      end
    end

end

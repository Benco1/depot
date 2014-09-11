require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(
      title: "Lorem ipsum",
      description: "It's good. Buy it.",
      image_url: "image.png")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price =  1
    assert product.valid?
  end

  test "image URL must be valid" do
    def new_product(image_url)
      product = Product.new(
        title: "Lorem ipsum",
        description: "It's good. Buy it.",
        price: 1,
        image_url: image_url)
    end

    ok = %w{ image.jpg i.jpg i.jPg png.png png.PnG picture.gif picture.GIF }

    bad = %w{ .jpg xyz.xyz image_jpg .jpgimage .gif-mypic image.pngg }

    ok.each do |url|
      assert new_product(url).valid?, "#{url} should be valid"
    end

    bad.each do |url|
      assert new_product(url).invalid?, "#{url} should be invalid"
    end
  end

  test "product id is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product title must be a minimum of 10 characters long" do
    product = Product.new(title: "SQL",
                          description: "all about SQL",
                          price: 1,
                          image_url: "sql.jpg")
    assert product.invalid?
    assert_equal ["must be a minimum of 10 characters long"],
      product.errors[:title]
  end
end

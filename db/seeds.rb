require 'faker'
require 'open-uri'
require 'csv'
require 'cgi' # For URL encoding

# Define categories
categories = ["Home Decor", "Wellness", "Clothing", "Shoes"]
categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end
puts "Categories seeded!"

# Define a method to create a product with an attached image
def create_product_with_image(attributes, image_url)
  product = Product.new(attributes)
  begin
    # Attach an image
    product.image.attach(
      io: URI.open(image_url),
      filename: "#{product.name.parameterize}.jpg",
      content_type: 'image/jpg'
    )
    product.save! # Save the product only after attaching the image
    puts "Created product: #{product.name}"
    product
  rescue StandardError => e
    puts "Failed to attach image for #{product.name}: #{e.message}. Skipping product creation."
    nil
  end
end

# Seed products from CSV
csv_file_path = Rails.root.join('db', 'products.csv')
if File.exist?(csv_file_path)
  CSV.foreach(csv_file_path, headers: true) do |row|
    category = Category.find_by(name: row['Category']) || Category.first
    attributes = {
      name: row['Name'],
      description: row['Description'] || Faker::Marketing.buzzwords,
      price: row['Price'].to_f,
      stock_quantity: row['Stock Quantity'].to_i
    }
    image_url = row['Image URL'] || "https://via.placeholder.com/150?text=#{CGI.escape(row['Name'] || 'Product')}"
    product = create_product_with_image(attributes, image_url)
    ProductCategory.create!(product: product, category: category) if product
  end
  puts "Products seeded from CSV!"
else
  # Seed products dynamically if no CSV file is provided
  categories_objects = Category.all
  product_count = 100

  product_count.times do |i|
    category = categories_objects.sample
    product_name = Faker::Commerce.product_name
    product_description = Faker::Marketing.buzzwords + " " + Faker::Lorem.sentence(word_count: 15, supplemental: true)
    product_price = Faker::Commerce.price(range: 10..100)

    attributes = {
      name: product_name,
      description: product_description,
      price: product_price,
      stock_quantity: Faker::Number.between(from: 10, to: 100)
    }
    image_url = "https://via.placeholder.com/150?text=#{CGI.escape(product_name)}"
    product = create_product_with_image(attributes, image_url)
    ProductCategory.create!(product: product, category: category) if product
  end
  puts "Dynamically generated products seeded!"
end

# Seed provinces
Province.create!([
  { name: "Alberta", code: "AB", pst: 0.0, gst: 0.05, hst: 0.0 },
  { name: "British Columbia", code: "BC", pst: 0.07, gst: 0.05, hst: 0.0 },
  { name: "Manitoba", code: "MB", pst: 0.07, gst: 0.05, hst: 0.0 },
  { name: "New Brunswick", code: "NB", pst: 0.0, gst: 0.0, hst: 0.15 },
  { name: "Newfoundland and Labrador", code: "NL", pst: 0.0, gst: 0.0, hst: 0.15 },
  { name: "Northwest Territories", code: "NT", pst: 0.0, gst: 0.05, hst: 0.0 },
  { name: "Nova Scotia", code: "NS", pst: 0.0, gst: 0.0, hst: 0.15 },
  { name: "Nunavut", code: "NU", pst: 0.0, gst: 0.05, hst: 0.0 },
  { name: "Ontario", code: "ON", pst: 0.0, gst: 0.0, hst: 0.13 },
  { name: "Prince Edward Island", code: "PE", pst: 0.0, gst: 0.0, hst: 0.15 },
  { name: "Quebec", code: "QC", pst: 0.09975, gst: 0.05, hst: 0.0 },
  { name: "Saskatchewan", code: "SK", pst: 0.06, gst: 0.05, hst: 0.0 },
  { name: "Yukon", code: "YT", pst: 0.0, gst: 0.05, hst: 0.0 }
])
puts "Provinces seeded successfully!"

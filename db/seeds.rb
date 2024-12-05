# require 'net/http'
# require 'json'
# require 'uri'
# require 'open-uri'

# # Fetch data from a URL with custom headers and redirect handling
# def fetch_data(url)
#   uri = URI(url)
#   begin
#     # Set up HTTP client with SSL if needed
#     http = Net::HTTP.new(uri.host, uri.port)
#     http.use_ssl = true if uri.scheme == 'https'

#     # Prepare the GET request with headers
#     request = Net::HTTP::Get.new(uri)

#     # Add cookies from the provided cookie string
#     request['Cookie'] = 'client_key=2691; session_token.1731127698385777702=307e684275f6e2dec0561c7b3ebff4f3b60e06e192bc1f796c11edc3ae37925d'

#     # Make the request and handle redirects
#     response = http.request(request)

#     # Log the response code and body for debugging
#     puts "Response Code: #{response.code}"
#     puts "Response Body: #{response.body}"

#     # Follow redirects if necessary (status code 3xx)
#     while response.is_a?(Net::HTTPRedirection)
#       location = response['location']
#       uri = URI(location)
#       response = http.get(uri)
#     end

#     # Check if the response is successful
#     if response.is_a?(Net::HTTPSuccess)
#       JSON.parse(response.body)  # Parse the JSON data
#     else
#       raise "Failed to fetch data: #{response.code} - #{response.message}"
#     end
#   rescue StandardError => e
#     puts "Error fetching data from #{url}: #{e.message}"
#     nil
#   end
# end

# # Fetch categories
# category_api_url = 'https://www.shopperplus.ca/marathon_api/catalog_collections?locale=en&country=ca'
# category_data = fetch_data(category_api_url)

# if category_data && category_data['data'] && category_data['data']['departmentCatalogs']
#   category_data['data']['departmentCatalogs']['root'].each do |category|
#     begin
#       # Check for category name before creating the record
#       created_category = Category.create!(name: category['name'])
#       puts "Created category: #{created_category.name}"
#     rescue StandardError => e
#       puts "Error creating category '#{category['name']}': #{e.message}"
#     end
#   end
# else
#   puts "No category data found or error with the API response."
# end

# # Fetch products for each category
# category_data["data"]["departmentCatalogs"]["root"].each do |category_data|
#   products_url = "https://www.shopperplus.ca/marathon_api/catalog_collections/#{category_data['id']}/related_products?page=1&page_size=24&sort_by=default&locale=en&country=ca"
#   products_data = fetch_data(products_url)

#   if products_data && products_data["data"] && products_data["data"]["products"]
#     products_data["data"]["products"].each do |product_data|
#       next if Product.exists?(product_data["id"])

#       # Find the category
#       category = Category.find_by(name: category_data["name"])

#       # Create Product
#       product = Product.create!(
#         name: product_data["productsData"].first["name"],  # Name from the 'productsData'
#         price: product_data["productsData"].first["priceString"].delete('$').to_f,  # Price (convert from string to float)
#         description: product_data["seoAlt"],  # Use SEO alt as description (or you can use another field)
#       )

#       # Associate product with category via the join table
#       product.categories << category

#       # Step 3: Attach product image using ActiveStorage (if applicable)
#       image_url = product_data["smallImage"]

#       if image_url.present?
#         product.image.attach(io: URI.open(image_url), filename: "#{product.name.parameterize}.jpg")
#       else
#         # If no image URL is available, you can either skip or attach a default image
#         puts "No image available for product: #{product.name}. Skipping image attachment."
#         # Optionally, attach a default image here:
#         # product.image.attach(io: URI.open('https://path/to/default/image.jpg'), filename: 'default.jpg')
#       end

#       puts "Created product: #{product.name} in category: #{category.name}"
#     end
#   else
#     puts "No products found or error with the API response for category: #{category_data['name']}"
#   end
# end

# puts "Seeding completed!"



Province.create([
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

require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  # Your code goes here!
  10.times do
    # you will write the "create" method as part of your project
    Product.create( brand: Faker::Company.name,
                    name: Faker::Commerce.product_name,
                    price: Faker::Number.decimal(2) )
  end
end

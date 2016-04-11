module Analyzable
  # Your code goes here!
  def average_price(products)
    total = products.inject(0) {|sum, product| sum + product.price.to_f}
    (total / products.length).round(2)
  end

  def print_report(products)
    inventory_by_brand_string = "Inventory by Brand:\n"
    count_by_brand(products).each do |key, val|
      inventory_by_brand_string += "\s\s- #{key}: #{val}\n"
    end

    inventory_by_name_string = "Inventory by Name:\n"
    count_by_name(products).each do |key, val|
      inventory_by_name_string += "\s\s- #{key}: #{val}\n"
    end

    return "Average Price: #{average_price(products)}\n" + \
      inventory_by_brand_string + inventory_by_name_string
  end

  def count_by_brand(products)
    inventory_by_brand = {}
    products.each do |product|
      if inventory_by_brand[product.brand].nil?
        inventory_by_brand[product.brand] = 0
      end
      inventory_by_brand[product.brand] += 1
    end
    inventory_by_brand
  end

  def count_by_name(products)
    inventory_by_name = {}
    products.each do |product|
      if inventory_by_name[product.name].nil?
        inventory_by_name[product.name] = 0
      end
      inventory_by_name[product.name] += 1
    end
    inventory_by_name
  end

end

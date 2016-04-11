require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.headers
    headers = CSV.read(@@data_path).first
    index = headers.find_index("product")
    headers[index] = "name" if index
    headers.map {|header| header.to_sym}
  end

  def self.create(attributes = nil)
    data_existed = false
    CSV.read(@@data_path).drop(1).each do |row|
      data_equals_this_row = true
      row.each_with_index do |row_val, index|
        if row_val != attributes[self.headers[index]]
          data_equals_this_row = false
          break
        end
      end
      if data_equals_this_row
        data_existed = true
        break
      end
    end
    udacidata = self.new(attributes)
    if !data_existed
      CSV.open(@@data_path, "a") do |csv|
        csv << self.headers.map {|header| udacidata.send(header)}
      end
    end
    udacidata
  end

  def self.all
    CSV.read(@@data_path).drop(1).map do |product|
      args = Hash[self.headers.zip(product)]
      self.new(args)
    end
  end

  def self.first(*args)
    if args.length == 0
      product = CSV.read(@@data_path).drop(1).first
      args = Hash[self.headers.zip(product)]
      return self.new(args)
    else
      products = CSV.read(@@data_path).drop(1).first(args.first)
      return products.map do |product|
        args = Hash[self.headers.zip(product)]
        self.new(args)
      end
    end
  end

  def self.last(*args)
    if args.length == 0
      product = CSV.read(@@data_path).drop(1).last
      args = Hash[self.headers.zip(product)]
      return self.new(args)
    else
      products = CSV.read(@@data_path).drop(1).last(args.first)
      return products.map do |product|
        args = Hash[self.headers.zip(product)]
        self.new(args)
      end
    end
  end

  def self.find(id)
    table = CSV.table(@@data_path)
    table.each do |row|
      if row[:id] == id
        args = {}
        self.headers.each do |header|
          if header == :name
            args[header] = row[:product]
          else
            args[header] = row[header]
          end
        end
        return self.new(args)
      end
    end
    raise ProductNotFoundError, "No product with id: #{id}"
  end

  def self.destroy(id)
    res = self.find(id)
    table = CSV.table(@@data_path)
    table.delete_if do |row|
      row[:id] == id
    end

    File.open(@@data_path, "w") do |f|
      f.write(table.to_csv)
    end
    res
  end

  def self.method_missing(method_name, *args)
    if method_name.to_s.start_with?("find_by_")
      Module.create_finder_methods("brand", "name")
      self.public_send(method_name, args[0])
    else
      super
    end
  end

  def self.where(options)
    self.all.select do |product|
      satisfied = true
      options.each do |key, value|
        if product.send(key) != value
          satisfied = false
          break
        end
      end
      satisfied
    end
  end

  def update(options)
    res = nil
    products = CSV.read(@@data_path).drop(1)

    products.each do |product|
      if product[0].to_i == self.id
        Udacidata.headers.each_with_index do |header, index|
          if options.has_key?(header)
            product[index] = options[header]
          end
        end
        args = Hash[Udacidata.headers.zip(product)]
        res = self.class.new(args)
        break
      end
    end

    CSV.open(@@data_path, "w") do |csv|
      csv << ["id", "brand", "product", "price"]
      products.each do |product|
        csv << product
      end
    end

    res
  end

end

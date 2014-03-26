require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'product'
require 'transaction'
require 'cashier'
require 'return'
require 'quantity'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.before(:each) do
    Product.all {|product| product.destroy}
    Transaction.all {|transaction| transaction.destroy}
    Cashier.all {|cashier| cashier.destroy}
    Return.all {|retern| retern.destroy}
    Quantity.all {|quantity| quantity.destroy}
  end
end

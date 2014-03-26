class Cashier < ActiveRecord::Base
  has_many :transactions
  has_many :returns
end

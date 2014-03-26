class Transaction < ActiveRecord::Base
  belongs_to :cashier
  has_many :quantities
  has_many :returns
end

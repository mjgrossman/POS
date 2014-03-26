class Return < ActiveRecord::Base
  belongs_to :cashier
  belongs_to :transaction
end

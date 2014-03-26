require 'spec_helper'

describe Return do
  it {should belong_to :transaction}
  it {should belong_to :cashier}
end

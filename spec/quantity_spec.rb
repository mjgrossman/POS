require 'spec_helper'

describe Quantity do
  it {should belong_to :transaction}
  it {should belong_to :product}
end

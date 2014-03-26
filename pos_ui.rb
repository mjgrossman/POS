require 'active_record'
require './lib/cashier'
require './lib/product'
require './lib/quantity'
require './lib/return'
require './lib/transaction'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the POS system!"
  puts "---------------------"
  puts "Choose your destiny:"
  puts "Press 's' if you are the store manager"
  puts "Press 'c' if you are a cashier"
  puts "Press 'x' to exit the system"
  user_input = gets.chomp
  case user_input
  when 's'
    store_manager_menu
  when 'c'
    cashier_menu
  when 'x'
    puts "Good-bye!"
  else
    puts "Invalid option"
  end
end

def store_manager_menu
  choice = nil
  until choice == 'x'
    puts "\nSTORE MANAGER MENU"
    puts "==================="
    puts "\nPress 'p' if you would like to add a product"
    puts "Press 'c' if you would like to enter a new cashier"
    puts "Press 'r' for sales reports"
    puts "Press 'x' to exit"
    user_input = gets.chomp
    case user_input
    when 'p'
      add_product
    when 'c'
      add_cashier
    when 'r'
      sales_report
    when 'x'
      puts "Good-bye!"
      welcome
    else
      puts "Invalid option"
    end
  end
end

def add_product
  puts "Please enter the name of the product you would like to add to the database:"
  name_choice = gets.chomp
  puts "Please enter the price of the product"
  price_choice = gets.chomp
  new_product = Product.create(:name => name_choice, :price => price_choice)
  puts "\n#{new_product.name} has been added to the system at the following price: #{new_product.price}
  its id is #{new_product.id}"
end

def add_cashier
puts "Please enter the name of the cashier you would like to add to the database:"
  name_choice = gets.chomp
  new_cashier = Cashier.create(:name => name_choice)
  puts "\n#{new_cashier.name} has been added to the database #{new_cashier.created_at}"
end

def sales_report
  puts "\nSALES REPORT"
  puts "==========="
  puts "\nPress 't' for the total amount of sales for a date range"
  puts "Press 'c' to see the total number of transactions per cashier for a date range"
  puts "Press 'p' to see total movement per product"
  puts "Press 'r' to see total returns per product"
  user_input = gets.chomp
  case user_input
  when 't'
    total_sales
  when 'c'
    total_transactions
  when 'p'
    total_movement
  when 'r'
    total_returns
  else
    puts "Invalid option"
  end
end

def total_sales
  puts "Please enter a date range start date in this format 'YYYY-MM-DD HH':"
  start_date = gets.chomp + ' :00:01.000000'
  starting_date = Date.parse start_date
  puts "Please enter a date range end date in this format 'YYYY-MM-DD HH':"
  end_date = gets.chomp + ' :00:01.000000'
  ending_date = Date.parse end_date
  time_range = starting_date..ending_date
  items = Quantity.where(:created_at => time_range)
  total = 0
  items.each do |item|
    total += item.quantity * Product.where(:id => item.product_id).first.price
  end
  puts '$' + total.to_s
end

def total_transactions
  puts "Please enter a date range start date in this format 'YYYY-MM-DD':"
  start_date = gets.chomp
  starting_date = Date.parse start_date
  puts "Please enter a date range end date in this format 'YYYY-MM-DD':"
  end_date = gets.chomp
  ending_date = Date.parse end_date
  Cashier.all.each do |cashier|
    p cashier.transactions.first
    total = cashier.transactions.count {|transaction| transaction.created_at > start_date && transaction.created_at < end_date}
    puts "#{cashier.name} had #{total} transactions for the time period you have selected, night rider."
  end

end

def total_movement
end

def total_returns
end

def cashier_menu
  puts "\nCASHIER MENU"
    puts "============"
    puts "Please enter your cashier id:"
    cashier_id = gets.chomp
    cashier = Cashier.where(:id => cashier_id).first
    puts "Welcome #{cashier.name}."
    cashier_sub_menu(cashier)
end

def cashier_sub_menu(cashier)
  choice = nil
  until choice == 'x'
    puts "\nPress 't' for a new transaction,'r' for a new return or 'x' to exit this menu."
    cashier_choice = gets.chomp
    case cashier_choice
    when 't'
      new_transaction(cashier)
    when 'r'
      new_return(cashier)
    when 'x'
      puts 'see you soon'
      welcome
    else
      puts 'not a valid option'
    end
  end
end

def new_transaction(cashier)
  transaction = Transaction.create(:cashier_id => cashier.id)
  puts "\nPress 'a' to add an item or 'c' to complete the transaction."
  cashier_choice = gets.chomp
  if cashier_choice == 'a'
    add_item(transaction)
  elsif cashier_choice == 'c'
    complete_transaction(transaction)
  else
    puts 'not a valid option'
  end
end

def new_return(cashier)

end

def add_item(transaction)
  puts "\nPlease enter the ID of the product"
  user_choice = gets.chomp
  puts "Please enter the quantity you would like to purchase"
  number_choice = gets.chomp
  Quantity.create(:product_id => user_choice, :transaction_id => transaction.id, :quantity => number_choice)
  puts "\nPress 'a' to add another item or 'c' to complete the transaction."
  cashier_choice = gets.chomp
  if cashier_choice == 'a'
    add_item(transaction)
  elsif cashier_choice == 'c'
    complete_transaction(transaction)
  else
    puts 'not a valid option'
  end
end

def complete_transaction(transaction)
  puts "\nYour Receipt:"
  items = Quantity.where(:transaction_id => transaction.id)
  total = 0
  items.each do |item|
    product = Product.where(:id => item.product_id).first
    temp_calc = item.quantity * product.price
    puts "#{product.name}\t\tx #{item.quantity} --- $#{temp_calc}"
    total += temp_calc
  end
  cashier = Cashier.where(:id => transaction.cashier_id).first
  puts "\nYour total for this transaction is $#{total}
  Thank you for your patronage.  #{cashier.name} was your cashier today!"
end

welcome

# this class handles the  search and add
require_relative 'data_manager'
class ContactManager < DataManager
  def initialize(name=nil,phone_number=nil)
    if name != nil && phone_number != nil
      prepare_user_table
      user_hash={'user_name'=>name,'phone_number'=>phone_number}
      save_into_db('user_data',user_hash)
    end
    connect_db
  end
  def self.search_user
    look_up_user
  end

  def self.is_num_str?(num)
    num =~ /^\d+$/?true:false
  end

   def self.purify_number(number)
    if !is_num_str?(number)
      puts "Invalid phone Number. Try again"
      number = gets.chomp
      purify_number(number)
    end
    number
  end

  def add_new_contact(name, phone_number)
      saveContact(name, phone_number)
  end

  def check_phone_number?(phone_number)
    phone_number = phone_number.to_i
    phone_number
  end

  def search_contact(name)
    if name.empty?
      look_up_data(name)
    else
      false
    end
  end

  def display_search_result(listed_number)
    return_value = ''
    if listed_number.empty?
      return_value += 'Your search result has produced #{listedNumber.length}'
      return_value += ' results'
      return_value
    else
      false
    end
  end
end

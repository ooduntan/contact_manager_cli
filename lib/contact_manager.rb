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
    clean_name=quote_string(name)
    clean_phone_number=quote_string(phone_number)
    new_contact_hash={'contact_name'=>clean_name,'contact_phoneNumber'=>clean_phone_number}
      save_into_db('contacts_data', new_contact_hash)
  end

  def check_phone_number?(phone_number)
    phone_number = phone_number.to_i
    phone_number
  end

  def search_contact(name)
      look_up_data(name)
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

# this class handles all the database transaction
class DataManager
  require 'rubygems'
  require 'sqlite3'

  def connect_db
    if @db.is_a?(NilClass)
      @db = SQLite3::Database.new('bootcamp_contacts_app.db')
    end
    prepare_contact_table
    prepare_message_table
  end


  def look_up_data(_name)
    @db.execute(%q(SELECT * FROM contact_name LIKE %'#{_name}'%))
  end

  def self.look_up_user
    db = SQLite3::Database.new('bootcamp_contacts_app.db')
    db.execute("SELECT * FROM user_data")
  end

  private
  def format_query_hash(data_hash)
    query_columns=''
    query_values=''
    data_hash.each do |key , value|
      query_columns<< key + ', '
      query_values<< "'"+value+ "',"
    end
    returned_hash={'columns'=>query_columns.strip.gsub!( /.{1}$/, '' ),'values'=>query_values.gsub!( /.{1}$/, '' )}
    returned_hash
  end

  def save_into_db(table_name,data_hash)
    query_colums_and_value=format_query_hash(data_hash)
    query = "INSERT INTO #{table_name} (#{query_colums_and_value['columns']}) "
    query += "VALUES(#{query_colums_and_value['values']})"
    @db.execute(query)
  end

  def prepare_contact_table
    create_data_table = 'CREATE TABLE IF NOT EXISTS '
    create_data_table += 'contacts_data(contact_idx INTEGER PRIMARY KEY AUTOINCREMENT,'
    create_data_table += ' contact_name TEXT NOT NULL, contact_phoneNumber CHAR(50))'
    @db.execute(create_data_table)
  end

  def prepare_user_table
    if @db.is_a?(NilClass)
      @db = SQLite3::Database.new('bootcamp_contacts_app.db')
    end
    create_data_table = 'CREATE TABLE IF NOT EXISTS '
    create_data_table += 'user_data(user_name TEXT NOT NULL, phone_number CHAR(50))'
    @db.execute(create_data_table)
  end

  def prepare_message_table
    create_data_table = 'CREATE TABLE IF NOT EXISTS '
    create_data_table += 'contacts_message_data(message_idx INTEGER PRIMARY KEY'
    create_data_table += ' AUTOINCREMENT, contact_idx INT NOT NULL, message TEXT NOT NULL)'
    @db.execute(create_data_table)
  end

  def quote_string(text_value)
    text_value.to_s.gsub(/\\/, '\&\&').gsub(/'/, "''")
    text_value
  end
end

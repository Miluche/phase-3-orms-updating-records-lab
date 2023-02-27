require_relative "../config/environment.rb"

class Student
  attr_accessor :name
  attr_accessor :grade
  attr_accessor :id
  def initialize(id=nil, name , grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if @id.nil?
      insert_query = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(insert_query, [@name, @grade])
    else
      insert_query = "INSERT INTO students (id, name, grade) VALUES (?, ?, ?)"
      DB[:conn].execute(insert_query, [@id, @name, @grade])
    end
  end

  def self.create(name, grade)
    Student.new(name, grade).save
  end
  def self.new_from_db(data)
    Student.new(data[0], data[1], data[2])
  end
  def self.find_by_name(name)
    select_query = "SELECT * FROM students WHERE name=?"
    data = []
    DB[:conn].execute(select_query, name) do |row|
      data << row
    end
    new_from_db(data)
  end
  def update
    update_query = query = "UPDATE Students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(update_query,@name, @grade, @id)
  end
end

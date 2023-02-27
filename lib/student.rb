require_relative "../config/environment.rb"

class Student
  attr_accessor :name
  attr_accessor :grade
  attr_reader :id
  def initialize(id=nil, name , grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    create_sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(create_sql)
  end

  def self.drop_table
    drop_sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(drop_sql)
  end

  def save
    if self.id
      self.update
    else
      insert_sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
      SQL
      DB[:conn].execute(insert_sql, self.name, self.grade)
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end
  def self.new_from_db(data)
    new_student = Student.new(data[0], data[1], data[2])
    new_student
  end
  def self.find_by_name(name)
    select_sql = <<-SQL
    SELECT * FROM students WHERE name= ?
    SQL
    data = DB[:conn].execute(select_sql, name)[0]
    self.new_from_db(data)
  end
  def update
    update_sql = <<-SQL
    UPDATE Students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(update_sql, self.name, self.grade, self.id)
  end
  def ==(other)
    return false unless other.is_a?(Student)

    self.name == other.name && self.grade == other.grade
  end
end

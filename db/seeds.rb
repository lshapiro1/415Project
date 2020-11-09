# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# :password => "xyz"
Rails.application.eager_load!

User.create!(:email => 'lshapiro1@colgate.edu', :admin => true)
t1 = Course.create!(:name => 'Test1', :daytime => 'TR 8:30-9:45')
attendance1 = AttendanceQuestion.create!(:qname => "Attendance check in", :course => t1)

t2 = Course.create!(:name => 'Test2', :daytime => 'TR 9:55-11:10')
attendance3 = AttendanceQuestion.create!(:qname => "Attendance check in", :course => t2)

std101 = %w{
shapirolucass@gmail.com
}

puts "#{t1}"
std101.each do |email|
  std = User.create!(:email => email)
  u_to_add = std
  t1.students << std
end


puts "#{t2}"
std301 = %w{
}

std301.each do |email|
  std = User.create!(:email => email)
  t2.students << std
end



#exit

# dummy question seeds

q = Question.new # force loading model code
questions = []
options = ["Syntax error", "Runtime error", "Logic error"]
mc = MultiChoiceQuestion.create!(:qname => "What kind of error does this code exhibit?", :qcontent => options, :answer => "Logic error", :course => t1)
mcp = mc.new_poll(:round => 1)
mcp.save!
fr = FreeResponseQuestion.create!(:qname => "What does this image make you think of?", :course => t1)
fr.image.attach(io: File.open('testimg.png'), filename: 'testimg.png')
frp = fr.new_poll(:round => 1)
frp.save!
num = NumericQuestion.create!(:qname => "What value does this function return?", :answer => 8, :course => t1)
nump = num.new_poll(:round => 1)
nump.save!
s = User.create!(:email => "RightAnswer@colgate.edu")
t1.students << s
s.save!
r = mcp.new_response(:response => options[2], :user => s)
r.save!



fr_resp = %w{this that other something nothing}

# don't, by default, add dummy student seeds

slist = []
1.upto(10) do |i|
  s = User.create!(:email => "fakestudent#{i}@colgate.edu")
  t1.students << s
  slist << s

  r = mcp.new_response(:response => options[rand(3)], :user => s)
  r.save!
  r = frp.new_response(:response => fr_resp[rand(fr_resp.length)], :user => s)
  r.save!
  r = nump.new_response(:response => rand(10), :user => s)
  r.save!
end


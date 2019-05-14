# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(:email => 'jsommers@colgate.edu', :admin => true)
u = User.create!(:email => 'sommersmeister@gmail.com')
c = Course.create!(:name => 'COSC 101A', :daytime => 'TR 8:30-9:45')
c.students << u

Question.new # force loading model code
questions = []
mc = MultiChoiceQuestion.create!(:qname => "Which is correct?", :qcontent => %w{one two three four}, :answer => "four", :course => c)
mcp = mc.new_poll(:round => 1)
mcp.save!
fr = FreeResponseQuestion.create!(:qname => "What does this image make you think of?", :course => c)
fr.image.attach(io: File.open('testimg.png'), filename: 'testimg.png')
frp = fr.new_poll(:round => 1)
frp.save!
num = NumericQuestion.create!(:qname => "What is 2**3?", :answer => 8, :course => c)
nump = num.new_poll(:round => 1)
nump.save!

fr_resp = %w{this that other something nothing}

slist = []
1.upto(10) do |i|
  s = User.create!(:email => "fakestudent#{i}@colgate.edu")
  c.students << s
  slist << s

  r = mcp.new_response(:response => rand(4), :user => s)
  r.save!
  r = frp.new_response(:response => fr_resp[rand(fr_resp.length)], :user => s)
  r.save!
  r = nump.new_response(:response => rand(10), :user => s)
  r.save!
end

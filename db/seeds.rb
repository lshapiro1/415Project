# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# :password => "xyz"
Rails.application.eager_load!


User.create!(:email => 'wworrell@colgate.edu', :admin => true)

User.create!(:email => 'mmilke@colgate.edu', :admin => true)

User.create!(:email => 'lshapiro1@colgate.edu', :admin => true)

c101 = Course.create!(:name => 'COSC101S20', :daytime => 'TR 8:30-9:45')
attendance101 = AttendanceQuestion.create!(:qname => "Attendance check in", :course => c101)

c301 = Course.create!(:name => 'COSC301S20', :daytime => 'MWF 9:00-11:15')
attendance301 = AttendanceQuestion.create!(:qname => "Attendance check in", :course => c301)

#sommersmeister@gmail.com
std101 = ['dingflag@gmail.com', 'wrequaw@gmail.com', 'shapirolucass@gmail.com']

u0 = User.create!(:email => 'dingflag@gmail.com')
u1 = User.create!(:email => 'wrequaw@gmail.com')
u2 = User.create!(:email => 'shapirolucass@gmail.com')
c101.students << u0
c101.students << u1
c101.students << u2
c301.students << u0
c301.students << u1
c301.students << u2




#exit

# dummy question seeds

Question.new # force loading model code
questions = []
fr = FreeResponseQuestion.create!(:qname => "What does this image make you think of?", :course => c301)
fr.image.attach(io: File.open('testimg.png'), filename: 'testimg.png')
frp = fr.new_poll(:round => 1)
frp.save!
num = NumericQuestion.create!(:qname => "What value does this function return?", :answer => 8, :course => c301, :created_at => "2020-11-15")
nump = num.new_poll(:round => 1)
nump.save!
options = ["Syntax error", "Runtime error", "Logic error"]
mc = MultiChoiceQuestion.create!(:qname => "What kind of error does this code exhibit?", :qcontent => options, :answer => "Logic error", :course => c301,:created_at => "2020-11-15")
mcp = mc.new_poll(:round => 1)
mcp.save!
options = ["A", "B", "C", "D"]
mc0 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[1], :course => c301,:created_at => "2020-11-15")
mcp0 = mc0.new_poll(:round => 1)
mcp0.save!
mc1 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[0], :course => c301,:created_at => "2020-11-17")
mcp1 = mc1.new_poll(:round => 1)
mcp1.save!
mc2 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[3], :course => c301,:created_at => "2020-11-19")
mcp2 = mc2.new_poll(:round => 1)
mcp2.save!
mc3 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[0], :course => c301,:created_at => "2020-11-20")
mcp3 = mc3.new_poll(:round => 1)
mcp3.save!
mc4 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[2], :course => c301,:created_at => "2020-11-20")
mcp4 = mc4.new_poll(:round => 1)
mcp4.save!
mc5 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[0], :course => c301,:created_at => "2020-12-1")
mcp5 = mc5.new_poll(:round => 1)
mcp5.save!
mc6 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[1], :course => c301,:created_at => "2020-12-1")
mcp6 = mc6.new_poll(:round => 1)
mcp6.save!
mc7 = MultiChoiceQuestion.create!(:qname => "Which one?", :qcontent => options, :answer => options[2], :course => c301,:created_at => "2020-12-1")
mcp7 = mc7.new_poll(:round => 1)
mcp7.save!


fr_resp = %w{this that other something nothing}

# generate results for us
u_arr = [u0,u1,u2]
answers_arr = [options[1],options[0],options[1],options[0],options[1],options[1],options[1],options[0]]
mc_arr = [mcp0,mcp1,mcp2,mcp3,mcp4,mcp5,mcp6,mcp7]

u_arr.each do |user|
  answers_arr.zip(mc_arr).each do |answer, multichoicePoll|
    r0 = multichoicePoll.new_response(:response => answer, :user => user)
    r0.save!
  end
end


slist = []
1.upto(10) do |i|
  s = User.create!(:email => "fakestudent#{i}@colgate.edu")
  c301.students << s
  slist << s

  r = mcp.new_response(:response => options[rand(3)], :user => s)
  r.save!
  r = frp.new_response(:response => fr_resp[rand(fr_resp.length)], :user => s)
  r.save!
  r = nump.new_response(:response => rand(10), :user => s)
  r.save!
end

exit


class Course < ApplicationRecord
  validates :name, :presence => true
  validates :daytime, :presence => true, :format => { with: /[MTWRF]{2,3} \d{1,2}:\d{2}-\d{1,2}:\d{2}/ }

  has_and_belongs_to_many :students, :class_name => "User"
  has_many :questions, :dependent => :destroy

  def now?
    return false unless self.daytime =~ /([MTWRF]{2,3}) (\d{1,2}):(\d{2})-(\d{1,2}):(\d{2})/
    dow = %w{Su M T W R F Sa}
    n = Time.now
    day = dow[n.wday]
    return false if !$1.include? day

    xstart = $2.to_i * 60 + $3.to_i
    xend = $4.to_i * 60 + $5.to_i
    xnow = n.hour * 60 + n.min
    return xnow >= xstart && xnow <= xend 
  end
end

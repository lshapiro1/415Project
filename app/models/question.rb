class Question < ApplicationRecord
  belongs_to :course
  has_many :polls, :dependent => :destroy
  validates :qname, presence: true
  validates_associated :course
  validate :options_for_multichoice
  enum content_type: %i(html markdown plain)
  has_one_attached :image

  def active_poll
    polls.where(:isopen => true).first
  end

  def content_type
    read_attribute(:content_type) || write_attribute(:content_type, "plain")
  end

  def poll_responses_for(user) 
    user.poll_responses 
  end

protected
  def options_for_multichoice
    if type == "MultiChoiceQuestion" and qcontent.length < 2
      errors.add(:qcontent, "Invalid. Please add at least two options!")
    end
  end

  def prompt; end
end

class MultiChoiceQuestion < Question
  serialize :qcontent, Array  
  def qcontent
    read_attribute(:qcontent) || write_attribute(:qcontent, [])
  end

  def new_poll(h={})
    Poll.new(:type => "MultiChoicePoll", :question => self, **h)
  end

  def prompt
    "Select one option"
  end
end

class FreeResponseQuestion < Question
  def new_poll(h={})
    Poll.new(:type => "FreeResponsePoll", :question => self, **h)
  end

  def prompt
    "Enter a text response"
  end
end

class NumericQuestion < Question
  def new_poll(h={})
    Poll.new(:type => "NumericPoll", :question => self, **h)
  end

  def prompt
    "Enter a number"
  end
end

class AttendanceQuestion < Question
  def new_poll(h={})
    Poll.new(:type => "AttendancePoll", :question => self, **h)
  end

  def prompt
    "Check in now"
  end

  def attendance_taken?
    now = Time.now
    !self.polls.where('created_at BETWEEN ? AND ?', Time.new(now.year, now.month, now.day), Time.new(now.year, now.month, now.day, 23, 59, 59)).first.nil?
  end
end

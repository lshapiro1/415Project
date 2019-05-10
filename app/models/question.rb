class Question < ApplicationRecord
  belongs_to :course
  has_many :polls, :dependent => :destroy
  validates :qname, presence: true
  enum content_type: %i(html markdown plain)

  def content_type
    read_attribute(:content_type) || write_attribute(:content_type, "plain")
  end
end

class MultiChoiceQuestion < Question
  serialize :qcontent, Array  
  def qcontent
    read_attribute(:qcontent) || write_attribute(:qcontent, [])
  end

  def new_poll
    MultiChoicePoll.new(:question => self)
  end
end

class FreeResponseQuestion < Question
  def new_poll
    FreeResponsePoll.new(:question => self)
  end
end

class NumericQuestion < Question
  def new_poll
    NumericPoll.new(:question => self)
  end
end

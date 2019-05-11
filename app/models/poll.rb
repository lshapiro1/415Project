class Poll < ApplicationRecord
  belongs_to :question
  has_many :poll_responses, :dependent => :destroy
  has_many :users, :through => :poll_responses

  validates_associated :question
end

class MultiChoicePoll < Poll
  def new_response(h={})
    PollResponse.new(:type => "MultiChoicePollResponse", :poll => self, **h)
  end

  def options
    self.question.qcontent
  end
end

class FreeResponsePoll < Poll
  def new_response(h={})
    PollResponse.new(:type => "FreeResponsePollResponse", :poll => self, **h)
  end
end

class NumericPoll < Poll
  def new_response(h={})
    PollResponse.new(:type => "NumericPollResponse", :poll => self, **h)
  end
end

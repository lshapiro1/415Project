class Poll < ApplicationRecord
  belongs_to :question
  has_many :poll_responses, :dependent => :destroy
  has_many :users, :through => :poll_responses

  validates_associated :question

  def self.closeall(course)
    Poll.joins(:question).where("polls.isopen = ? AND polls.question_id = questions.id AND questions.course_id = ?", true, course.id).update_all(:isopen => false)
  end
end

class MultiChoicePoll < Poll
  def new_response(h={})
    PollResponse.new(:type => "MultiChoicePollResponse", :poll => self, **h)
  end

  def options
    self.question.qcontent
  end

  def responses
    h = {}
    opts = self.question.qcontent
    opts.each { |v| h[v] = 0 }
    self.poll_responses.each { |r| h[opts[r.response]] += 1 }
    h
  end
end

class FreeResponsePoll < Poll
  def new_response(h={})
    PollResponse.new(:type => "FreeResponsePollResponse", :poll => self, **h)
  end

  def responses
    h = Hash.new(0)
    self.poll_responses.each { |r| h[r.response.downcase] += 1 }
    h
  end
end

class NumericPoll < Poll
  def new_response(h={})
    PollResponse.new(:type => "NumericPollResponse", :poll => self, **h)
  end

  def responses
    resp = self.poll_responses.each {|r| r }.collect
    m1,m2 = resp.minmax
    h = {
        "min" => m1,
        "max" => m2,
    }
    h
  end
end

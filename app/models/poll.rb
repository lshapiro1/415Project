class Poll < ApplicationRecord
  belongs_to :question
  has_many :poll_responses, :dependent => :destroy
  has_many :users, :through => :poll_responses
end

class MultiChoicePoll < Poll
  def options
    self.question.multi_choice_options
  end
end

class FreeResponsePoll < Poll
end

class NumericResponsePoll < Poll
end

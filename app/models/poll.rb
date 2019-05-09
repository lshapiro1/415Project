class Poll < ApplicationRecord
  belongs_to :question
  has_many :poll_responses
  has_many :users, :through => :poll_responses
end

class MultiChoicePoll < Poll
end

class FreeResponsePoll < Poll
end

class NumericResponsePoll < Poll
end

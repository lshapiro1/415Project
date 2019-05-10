class PollResponse < ApplicationRecord
  belongs_to :user
  belongs_to :poll
end

class MultiChoicePollResponse < PollResponse
end

class FreeResponsePollResponse < PollResponse
end

class NumericPollResponse < PollResponse
end

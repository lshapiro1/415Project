class Question < ApplicationRecord
  belongs_to :course
  has_many :polls, :dependent => :destroy
  validates :qname, presence: true
  enum content_type: %i(html markdown plain)

  def content_type
    # FIXME: do lookup on parent
    self.content_type || "plain"
  end
end

class MultiChoiceQuestion < Question
  has_many :multi_choice_options, :dependent => :destroy
end

class FreeResponseQuestion < Question
end

class NumericQuestion < Question
end

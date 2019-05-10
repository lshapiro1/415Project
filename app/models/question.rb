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
end

class FreeResponseQuestion < Question
end

class NumericQuestion < Question
end

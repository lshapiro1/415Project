require 'rails_helper'

RSpec.describe Poll, type: :model do
  describe "multi choice poll options" do
    it "should return the question options with Poll#options" do
      c = Course.create(:name => "test", :daytime => "TR 9:55-10:10")
      opts= %w{opt1 opt2 opt3}
      q = MultiChoiceQuestion.create(:qname => "question", :course=>c, :qcontent => opts)
      q.save
      poll = q.new_poll
      expect(poll.options).to eq(opts)
    end

    it "#new_poll should return the right poll object" do
      c = Course.create(:name => "test", :daytime => "TR 9:55-10:10")
      q = FreeResponseQuestion.create(:qname => "question", :course => c)
      q.save
      poll = q.new_poll
      expect(poll.type).to eq("FreeResponsePoll")

      q = NumericQuestion.create(:qname => "question", :course => c)
      q.save
      poll = q.new_poll
      expect(poll.type).to eq("NumericPoll")
    end
  end
end

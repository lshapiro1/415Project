require 'rails_helper'

RSpec.describe Question, type: :model do
  it "should default content type to plain" do
    q = Question.new
    expect(q.content_type).to eq("plain")
    q.save
    expect(q.content_type).to eq("plain")
  end
end

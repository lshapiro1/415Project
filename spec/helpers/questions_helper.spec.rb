require 'rails_helper'

RSpec.describe QuestionsHelper, type: :helper do
  describe "question_type" do
    it "should give text before Question" do
      expect(question_type("XQuestion").to eq("X")
    end
  end

  describe "question_types" do
    it "should give the right list" do
      expect(question_types).to eq(%w{NumericQuestion MultiChoiceQuestion FreeResponseQuestion})
    end
  end

  describe "image helper" do
    it "should return nil if no image" do
      c = FactoryBot.create(:course)
      q = FactoryBot.create(:numeric_question, :course => c)
      expect(show_image(q.image)).to be nil
    end

    it "should return an image tag if an image exists" do
      c = FactoryBot.create(:course)
      q = FactoryBot.create(:numeric_question, :course => c)
      q.image.attach(io: File.open("testimg.png"), filename: "test.png")
      expect(show_image(q.image)).to match(/^<img/)
    end
  end
end

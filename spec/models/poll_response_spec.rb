require 'rails_helper'

RSpec.describe PollResponse, type: :model do
  describe "free poll response" do
    p = FactoryBot.create(:free_response_poll_response)
  end

  describe "numeric poll response" do
    p = FactoryBot.create(:numeric_poll_response)
  end

  describe "multichoice poll response" do
    p = FactoryBot.create(:multi_choice_poll_response)
  end
end

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "now?" do
    it "should return false if the day doesn't match" do
      # a tuesday, midnight
      allow(Time).to receive(:now) { Time.new(2019, 5, 7, 0, 0, 0, "-05:00") }
      c = Course.new(:name => "basket weaving", :daytime => "MWF 09:20-10:10")
      expect(c.now?).to be false

      allow(Time).to receive(:now) { Time.new(2019, 5, 7, 9, 20, 0, "-05:00") }
      expect(c.now?).to be false
    end

    it "should return false if the day matches but time doesn't" do
      # monday
      allow(Time).to receive(:now) { Time.new(2019, 5, 6, 9, 0, 0, "-05:00") }
      c = Course.new(:name => "basket weaving", :daytime => "MWF 09:20-10:10")
      expect(c.now?).to be false

      allow(Time).to receive(:now) { Time.new(2019, 5, 6, 9, 19, 0, "-05:00") }
      expect(c.now?).to be false

      allow(Time).to receive(:now) { Time.new(2019, 5, 6, 10, 11, 0, "-05:00") }
      expect(c.now?).to be false
    end

    it "should return true if the day and time match" do
      allow(Time).to receive(:now) { Time.new(2019, 5, 6, 9, 20, 0, "-05:00") }
      c = Course.new(:name => "basket weaving", :daytime => "MWF 09:20-10:10")
      expect(c.now?).to be true

      allow(Time).to receive(:now) { Time.new(2019, 5, 8, 9, 20, 0, "-05:00") }
      expect(c.now?).to be true

      allow(Time).to receive(:now) { Time.new(2019, 5, 10, 9, 20, 0, "-05:00") }
      expect(c.now?).to be true

      allow(Time).to receive(:now) { Time.new(2019, 5, 10, 10, 01, 0, "-05:00") }
      expect(c.now?).to be true
    end
  end
end

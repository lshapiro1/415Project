class Course < ApplicationRecord
  validates :name, :presence => true
  validates :daytime, :presence => true, :format => { with: /[MTWRF]{2,3} \d{1,2}:\d{2}-\d{1,2}:\d{2}/ }

  def isnow?
  end
end

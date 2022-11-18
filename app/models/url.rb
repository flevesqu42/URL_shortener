class Url < ApplicationRecord
  before_create :set_id
  before_validation :strip_whitespaces

  validates :full_url, presence: true, uniqueness: true, url: true

  private

  # Generated ID will be between 6 and 10 chars.
  def set_id
    size = Random.rand(5) + 6
    self.id = Nanoid.generate(size: size)
  end

  # Strip full_url whitespaces.
  def strip_whitespaces
    self.full_url.strip! unless self.full_url.nil?
  end
end

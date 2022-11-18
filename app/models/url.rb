class Url < ApplicationRecord
  validates :full_url, presence: true, uniqueness: true, url: true
end

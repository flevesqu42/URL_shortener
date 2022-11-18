class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless UrlValidator.string_valid?(value)
      record.errors.add attribute, (options[:message] || "usage: 'https://42.fr'")
    end
  end

  class << self
    # true if given URL as a string is valid
    def string_valid?(str)
      uri = URI.parse(str)
      uri.kind_of?(URI::HTTP)
    rescue => _exception
      false
    end
  end
end

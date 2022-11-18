class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless UrlValidator.string_valid?(value)
      record.errors.add attribute, (options[:message] || "not an actual URL: \"#{value}\"")
    end
  end

  # STATIC
  class << self
    # true if given URL as a string is valid
    def string_valid?(str)
      uri = URI.parse(str)
      uri.kind_of?(URI::HTTP)
    rescue => exception
      logger.debug("Unable to parse string: #{exception}")
      false
    end
  end
end

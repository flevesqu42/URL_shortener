class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless self.class.string_valid?(value)
      record.errors.add attribute, (options[:message] || "invalid: \"#{value}\"")
    end
  end

  # true if given URL as a string is valid
  def self.string_valid?(str)
    begin
      uri = URI.parse(str)
      uri.kind_of?(URI::HTTP)
    rescue URI::Error
      false
    end
  end
end

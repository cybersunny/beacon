require 'nokogiri' # => xml parsing
require 'open-uri' # => interaction with uri and https
# require 'net/http'


DEFAULT_URL = 'https://beacon.nist.gov/rest/record/last'.freeze
OutputValue = '/*/outputValue'


def get_beacon_xml
  xml = Nokogiri::XML(open(DEFAULT_URL))
  @xml = xml.css(OutputValue).text # => take value from <outputValue> tag and print it. -test beacon xml by unit test
  @count = @xml.scan(/[[:alnum:]]/i).each_with_object(Hash.new(0)) { |c, h| h[c] += 1 } # -test count func by unit => count the number of characters in the OutputValue the beacon returns.
  # @count.each do |(c, h)| # => test output unit
  #   puts "#{c}, #{h}"
  # end
  @count.each do |(c, h)| # => test output unit
    puts "#{c}, #{h}"
  end
end

get_beacon_xml
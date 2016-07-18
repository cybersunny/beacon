require 'test/unit'
require 'nokogiri' # => xml parsing
require 'open-uri' # => interaction with uri and https
# require 'net/http'


# require 'rspec/matchers'
require 'equivalent-xml'


class StringTest < Test::Unit::TestCase

  BEACON_LAST_RECORD = 'https://beacon.nist.gov/rest/record/last'
  BEACON_WRONG_RECORD = 'https://beacon.nist.gov/rest/record/?last'
  BEACON_FIRST_RECORD = 'https://beacon.nist.gov/rest/record/0'


  OutputValue = '/record outputValue'
  BEACON_XML = "/Users/sonic/beacon/dnikiforov/testdata/beacon.xml"

  def test_wrong_get_request_status_code
    res = Net::HTTP.get_response(URI.parse(BEACON_WRONG_RECORD.to_s))
    assert_equal("404", res.code)
  end

  def test_get_response_status_code
    res = Net::HTTP.get_response(URI.parse(BEACON_LAST_RECORD.to_s))
    assert_equal("200", res.code)
  end

  # def test_put_response_status_code
  #   res = Net::HTTP.new(Last_Record, nil).start {|http| http.request(req) }
  #   puts res.code
  #   assert_equal("405", res.code)
  # end

  def test_post_response_status_code
    res = Net::HTTP.post_form(URI.parse(BEACON_LAST_RECORD.to_s), {'postKey' => '?'})
    assert_equal("405", res.code)
  end

  def test_if_a_response_in_xml_format_wighout_errors
    res = Nokogiri::XML::Document.parse(open(BEACON_LAST_RECORD)).errors.empty?
    # assert('true', res)
    assert(res, "true")
  end

  def test_xml_schema
    node_1 = Nokogiri::XML::Document.parse(open(BEACON_FIRST_RECORD)).to_s
    node_2 = Nokogiri::XML::Document.parse(File.open(BEACON_XML)).to_s
    assert_equal(node_1, node_2)
  end

  def test_count_of_string_in_outputvalue_tag
    xml = Nokogiri::XML(open(BEACON_FIRST_RECORD))
    @xml = xml.css(OutputValue).text
    xml2 = Nokogiri::XML(File.open(BEACON_XML))
    @xml2 = xml2.css(OutputValue).text
    @count = @xml.scan(/[[:alnum:]]/i).each_with_object(Hash.new(0)) { |c, h| h[c] += 1 }
    @count2 = @xml2.scan(/[[:alnum:]]/i).each_with_object(Hash.new(0)) { |c, h| h[c] += 1 }
    assert_equal(@count, @count2)
  end

  def test_print_format_of_counted_string_in_outputvalue_tag

  end


end
require 'minitest/autorun'
require 'jekyll'
require_relative '../_plugins/myFunctions'

class FilterTest < Minitest::Test
  def setup
    @filters = Object.new
    [URLEncode, Jekyll::InsertPDF, Jekyll::StripNonNum,
     Jekyll::StripCat, Jekyll::StripFile, Jekyll::PathMatch,
     Jekyll::InsertPicFolder].each { |filter| @filters.extend(filter) }
  end
end

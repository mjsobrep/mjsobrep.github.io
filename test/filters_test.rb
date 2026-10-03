require_relative 'test_helper'

class SiteFiltersTest < FilterTest
  def test_phone_numbers_are_reduced_to_digits
    assert_equal '7703246196', @filters.stripNonNum('(770) 324-6196')
    assert_equal '123', @filters.stripNonNum(123)
  end

  def test_pdf_paths_with_spaces_are_encoded
    html = @filters.insertPDF('otherFiles/example paper.pdf')
    assert_includes html, "data='/otherFiles/example%20paper.pdf'"
    assert_includes html, "href = '/otherFiles/example%20paper.pdf'"
  end
end

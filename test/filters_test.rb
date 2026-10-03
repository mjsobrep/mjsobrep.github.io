require_relative 'test_helper'
require 'tmpdir'
require 'nokogiri'
require 'fileutils'

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

  def test_category_filter_excludes_matching_posts_without_logging
    post = Struct.new(:categories)
    blog = post.new(['blog'])
    project = post.new(['projects'])
    both = post.new(['blog', 'projects'])
    assert_output('', '') do
      assert_equal [project], @filters.stripCat([blog, project, both], 'blog')
      assert_empty @filters.stripCat([], 'blog')
    end
  end

  def test_windows_pdf_paths_and_html_characters_are_safe
    html = @filters.insertPDF('otherFiles\\projects\\a & b\'s #1.pdf')
    document = Nokogiri::HTML.fragment(html)
    assert_equal '/otherFiles/projects/a%20%26%20b%27s%20%231.pdf', document.at_css('object')['data']
    assert_equal document.at_css('object')['data'], document.at_css('a')['href']
    assert_equal "otherFiles\\projects\\a & b's #1.pdf", document.at_css('a').text
  end

  def test_gallery_quotes_paths_and_has_no_trailing_text
    Dir.mktmpdir do |directory|
      Dir.chdir(directory) do
        Dir.mkdir('images')
        Dir.mkdir('images/gallery')
        File.write('images/gallery/a & b.png', '')
        File.write('images/gallery/z.png', '')
        FileUtils.mkdir_p('images/gallery/subfolder')
        html = @filters.insertPicFolder('gallery', 'medPic', 'html')
        document = Nokogiri::HTML.fragment(html)
        assert_equal 2, document.css('img').length
        assert_equal '/images/gallery/a%20%26%20b.png', document.at_css('img')['src']
        assert_equal 'medPic', document.at_css('img')['class']
        assert_empty document.text.strip
        assert html.end_with?('</div>')
      end
    end
  end

  def test_path_filters_handle_root_files_and_missing_paths
    assert_equal 'guides/_posts', @filters.folder('guides/_posts/example.md')
    assert_equal '', @filters.folder('index.html')
    assert_equal true, @filters.pathMatch({ 'path' => 'guides/_posts/example.md' }, 'guides/_posts')
    assert_equal false, @filters.pathMatch({ 'path' => nil }, 'guides/_posts')
  end
end

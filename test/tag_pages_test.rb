require_relative 'test_helper'

class TagPagesTest < Minitest::Test
  Post = Struct.new(:date, :title)

  def test_case_variants_share_one_page_and_keep_all_posts
    recent = Post.new(Time.utc(2021), 'Recent')
    older = Post.new(Time.utc(2020), 'Older')
    site = Jekyll::Site.new(Jekyll.configuration('quiet' => true))
    site.define_singleton_method(:tags) do
      { 'Python' => [older], 'python' => [recent, older], 'GUI' => [recent], 'gui' => [older] }
    end
    Jekyll::TagPageGenerator.new.generate(site)

    assert_equal ['/tags/gui.html', '/tags/python.html'], site.pages.map(&:url).sort
    assert_equal [recent, older], site.pages.find { |page| page.url == '/tags/python.html' }.data['destTag']
    assert_equal '/tags/python.html', site.data['legacy_tag_urls']['Python.html']
    assert_equal '/tags/gui.html', site.data['legacy_tag_urls']['GUI.html']
  end

  def test_tags_with_spaces_have_consistent_safe_slugs
    site = Jekyll::Site.new(Jekyll.configuration('quiet' => true))
    site.define_singleton_method(:tags) { { 'Computer Vision' => [] } }
    Jekyll::TagPageGenerator.new.generate(site)

    template = Liquid::Template.parse('{{ tag | tag_slug }}')
    assert_equal 'computer-vision', template.render!('tag' => 'Computer Vision')
    assert_equal '/tags/computer-vision.html', site.pages.first.url
    assert_equal '/tags/computer-vision.html', site.data['legacy_tag_urls']['Computer Vision.html']
  end
end

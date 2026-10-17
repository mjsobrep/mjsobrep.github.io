# Liquid filters and tag-page generation used by the site's templates.
require 'liquid'
require 'uri'
require 'cgi'
# require 'pry'

module Jekyll
    # Return the containing folder for a Liquid file path.
    module StripFile
        def folder(input)
            path = File.dirname(input.to_s.tr('\\', '/'))
            path == '.' ? '' : path
        end
    end
end

Liquid::Template.register_filter(Jekyll::StripFile)

module Jekyll
    # Expose Ruby's comparison ordering as a Liquid filter.
    module StrCmp
        def compare(input1,input2)
            input1<=>input2
        end
    end
end

Liquid::Template.register_filter(Jekyll::StrCmp)

module Jekyll
    # List tags by descending post frequency, using tag names to break ties.
    module TagFrequency
        def sort_tags_by_frequency(tags)
            tags.sort_by { |tag, posts| [-posts.size, tag] }
        end
    end
end

Liquid::Template.register_filter(Jekyll::TagFrequency)

module Jekyll
    # Match documents by their containing source directory.
    module PathMatch
        def pathMatch(candidate,pattern)
            path = candidate['path']
            !path.nil? && File.dirname(path.tr('\\', '/')) == pattern
        end
    end
end

Liquid::Template.register_filter(Jekyll::PathMatch)



# Encode file path segments while preserving slashes and normalizing Windows separators.
module URLEncode
    def url_encode(url)
        url.to_s.tr('\\', '/').split('/', -1).map do |segment|
            URI.encode_www_form_component(segment).gsub('+', '%20')
        end.join('/')
    end
end

Liquid::Template.register_filter(URLEncode)


module Jekyll
    # Render an optional label and the current build timestamp.
    class RenderTimeTag < Liquid::Tag

        def initialize(tag_name, text, tokens)
            super
            @text = text
        end

        def render(_context)
            "#{@text} #{Time.now}"
        end
    end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)


module Jekyll
    # Embed a local PDF with an escaped download fallback.
    module InsertPDF
        def insertPDF(file)
            path = CGI.escapeHTML(url_encode('/' + file.to_s.sub(%r{\A[/\\]+}, '')))
            label = CGI.escapeHTML(file.to_s)
            "<div class='pdfBox'><div class='pdfContent'><object class='pdfContent' data='#{path}' type='application/pdf' width='100%' height='100%'>alternate download: <a href = '#{path}'>#{label}</a></object></div></div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::InsertPDF)


module Jekyll
    # Render a local image directory as HTML or Markdown.
    module InsertPicFolder
        def insertPicFolder(directory,style,type)
            if(type.include? 'md')
                toReturn=''
            else
                toReturn='<div class= "center">'
            end
            Dir.glob('images/'+directory+'/*'){|image|
                if not File.directory?(image)
                    if(type.include? 'md')
                        toReturn = toReturn + '[![]('+url_encode('/'+image)+'){: .'+style+'}]('+url_encode('/'+image)+')'
                    else
                        path = CGI.escapeHTML(url_encode('/' + image))
                        css_class = CGI.escapeHTML(style.to_s)
                        alt = CGI.escapeHTML(File.basename(image))
                        toReturn += "<a href='#{path}'><img src='#{path}' class='#{css_class}' alt='#{alt}'></a>"
                    end
                end
            }
            if(not type.include? 'md')
                toReturn=toReturn+'</div>'
            end
            return toReturn
        end
    end
end

Liquid::Template.register_filter( Jekyll::InsertPicFolder)

module Jekyll
    # Embed a video player in the site's responsive widescreen wrapper.
    module InsertYouTube
        def insertYouTube(source)
            return "<div class='wideMediaBox'> <div class='mediaContent'>    <iframe class='mediaContent' width='100%' height='100%' src='"+source+"' frameborder='0' allowfullscreen></iframe></div> </div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::InsertYouTube)

module Jekyll
    # Embed a presentation in the site's responsive media wrapper.
    module InsertPowerPoint
        def insertPowerPoint(source)
            return "<div class='widePP'> <div class='mediaContent'>    <iframe class = 'mediaContent' src='"+source+"' width='100%' height = '100%' frameborder='0' scrolling='no'></iframe></div> </div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::InsertPowerPoint)

module Jekyll
    # Embed an iframe using the site's 4:3 media wrapper.
    module FourThreeIframe
        def fourThreeIframe(source)
            return "<div class='fourThreeBox'> <div class='mediaContent'>    <iframe class='mediaContent' width='100%' height='100%' src='"+source+"' frameborder='0' allowfullscreen></iframe></div> </div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::FourThreeIframe)

module Jekyll
    # Embed an iframe using the site's portrait 9:16 media wrapper.
    module NineSixIframe
        def nineSixIframe(source)
            return "<div class = 'center'><div class='nineSixBox'> <div class='mediaContent'>    <iframe class='mediaContent' width='100%' height='100%' src='"+source+"' frameborder='0' allowfullscreen></iframe></div> </div></div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::NineSixIframe)

module Jekyll
    # Extract digits from phone numbers and media dimensions.
    module StripNonNum
        def stripNonNum(num)
            if(not num.is_a? String)
                num = num.to_s
            end
            return num.gsub(/[^0-9]/, '')
        end
    end
end

Liquid::Template.register_filter(Jekyll::StripNonNum)

module Jekyll
  # Normalize tag names to the canonical slugs used by generated pages and links.
  module TagSlug
    def tag_slug(tag)
      slug = Jekyll::Utils.slugify(tag.to_s)
      slug.empty? ? 'tag' : slug
    end
  end

  # Merge posts by tag slug and record redirects from legacy tag URLs.
  class TagPageGenerator < Generator
    include TagSlug

    # Render a generated tag listing through the shared tag layout.
    class TagPage < PageWithoutAFile
      def initialize(site, slug, tags, posts)
        super(site, site.source, 'tags', "#{slug}.html")
        self.data = {
          'layout' => 'tag',
          'destTitle' => "Tag: #{tags.first}",
          'destTag' => posts
        }
      end
    end

    def generate(site)
      site.data['legacy_tag_urls'] = {}
      site.tags.keys.group_by { |tag| tag_slug(tag) }.each do |slug, tags|
        posts = tags.flat_map { |tag| site.tags[tag] }.uniq.sort_by(&:date).reverse
        site.pages << TagPage.new(site, slug, tags, posts)
        tags.each { |tag| site.data['legacy_tag_urls']["#{tag}.html"] = "/tags/#{slug}.html" }
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::TagSlug)

module Jekyll
    # Exclude posts belonging to the requested category.
    module StripCat
        def stripCat(posts,category)
            posts.reject { |post| post.categories.include?(category) }
        end
    end
end

Liquid::Template.register_filter(Jekyll::StripCat)

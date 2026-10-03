require 'liquid'
require 'uri'
require 'cgi'
# require 'pry'

module Jekyll
    module StripFile
        def folder(input)
            path = File.dirname(input.to_s.tr('\\', '/'))
            path == '.' ? '' : path
        end
    end
end

Liquid::Template.register_filter(Jekyll::StripFile)

module Jekyll
    module StrCmp
        def compare(input1,input2)
            input1<=>input2
        end
    end
end

Liquid::Template.register_filter(Jekyll::StrCmp)

module Jekyll
    module PathMatch
        def pathMatch(candidate,pattern)
            path = candidate['path']
            !path.nil? && File.dirname(path.tr('\\', '/')) == pattern
        end
    end
end

Liquid::Template.register_filter(Jekyll::PathMatch)



# Percent encoding for URI confrming to RFC 3986.
# Ref: http://tools.ietf.org/html/rfc3986#page-12
module URLEncode
    def url_encode(url)
        url.to_s.tr('\\', '/').split('/', -1).map do |segment|
            URI.encode_www_form_component(segment).gsub('+', '%20')
        end.join('/')
    end
end

Liquid::Template.register_filter(URLEncode)


module Jekyll
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
    module InsertYouTube
        def insertYouTube(source)
            return "<div class='wideMediaBox'> <div class='mediaContent'>    <iframe class='mediaContent' width='100%' height='100%' src='"+source+"' frameborder='0' allowfullscreen></iframe></div> </div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::InsertYouTube)

module Jekyll
    module InsertPowerPoint
        def insertPowerPoint(source)
            return "<div class='widePP'> <div class='mediaContent'>    <iframe class = 'mediaContent' src='"+source+"' width='100%' height = '100%' frameborder='0' scrolling='no'></iframe></div> </div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::InsertPowerPoint)

module Jekyll
    module FourThreeIframe
        def fourThreeIframe(source)
            return "<div class='fourThreeBox'> <div class='mediaContent'>    <iframe class='mediaContent' width='100%' height='100%' src='"+source+"' frameborder='0' allowfullscreen></iframe></div> </div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::FourThreeIframe)

module Jekyll
    module NineSixIframe
        def nineSixIframe(source)
            return "<div class = 'center'><div class='nineSixBox'> <div class='mediaContent'>    <iframe class='mediaContent' width='100%' height='100%' src='"+source+"' frameborder='0' allowfullscreen></iframe></div> </div></div>"
        end
    end
end

Liquid::Template.register_filter(Jekyll::NineSixIframe)

module Jekyll
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
  module TagSlug
    def tag_slug(tag)
      slug = Jekyll::Utils.slugify(tag.to_s)
      slug.empty? ? 'tag' : slug
    end
  end

  class TagPageGenerator < Generator
    include TagSlug

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
    module StripCat
        def stripCat(posts,category)
            posts.reject { |post| post.categories.include?(category) }
        end
    end
end

Liquid::Template.register_filter(Jekyll::StripCat)

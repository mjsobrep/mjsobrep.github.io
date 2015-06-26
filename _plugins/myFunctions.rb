require 'liquid'
require 'uri'

module Jekyll
  module StripFile
    def folder(input)
      input[0,input.rindex("/")]
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
        rawPath = candidate["path"]
        trimmedPath = rawPath[0,rawPath.rindex("/")]
        toReturn = nil
        if((trimmedPath<=>pattern)==0)
            toReturn= true
        end
        return toReturn
    end
  end
end

Liquid::Template.register_filter(Jekyll::PathMatch)


 
# Percent encoding for URI confrming to RFC 3986.
# Ref: http://tools.ietf.org/html/rfc3986#page-12
module URLEncode
  def url_encode(url)
    return url.gsub(' ','%20')
  end
end

Liquid::Template.register_filter(URLEncode)


module Jekyll
  class RenderTimeTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "#{@text} #{Time.now}"
    end
  end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)

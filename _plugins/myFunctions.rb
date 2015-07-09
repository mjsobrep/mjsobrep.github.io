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


module Jekyll
  module InsertPDF
    def insertPDF(file)
      return "<div class='pdfBox'> <div class='pdfContent'>    <object class='pdfContent' data='"+url_encode('/'+file)+"' type='application/pdf' width='100%' height='100%'>   alternate download: <a href = '"+url_encode('/'+file)+"'>"+file+"</a></object></div> </div>"
    end
  end
end

Liquid::Template.register_filter(Jekyll::InsertPDF)


module Jekyll
  module InsertPicFolder
    def insertPicFolder(directory,style)
      toReturn=''
      Dir.glob('images/'+directory+'/*'){|image|
        if not File.directory?(image)
          toReturn = toReturn + '<a href='+url_encode('/'+image)+'><img src='+url_encode('/'+image)+' class='+style+'></a>'
        end
      }
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

import argparse
import re

def main():
    """Main entry point from the terminal to parse flickr embed code into liquid code"""
    # Parse in arguments
    parser = argparse.ArgumentParser(
        description='convert flickr embed to liquid')

    parser.add_argument("embed_string", type=str, nargs='+',
                        help='the embed string copied from flickr. paste inside [] with no extra quotes')

    parser.add_argument("--html", help="If you want the output to be for an html file.", 
                        action='store_true')

    args = parser.parse_args()

    # print(args.embed_string)
    # print('\n')
    full_string = ' '.join(args.embed_string)
    # print(full_string)
    # print('\n')

    m = re.search('href=(\S*)', full_string)
    src = m.group(1)
    # print(m.group(1))

    m = re.search('title=(.*?)>', full_string)
    title = m.group(1)
    # print(m.group(1))

    m = re.search('img src=(\S*)', full_string)
    img = m.group(1)
    # print(m.group(1))

    m = re.search('width=(\S*)', full_string)
    width = m.group(1)
    # print(m.group(1))

    m = re.search('height=(\S*)', full_string)
    height = m.group(1)
    # print(m.group(1))

    out = ''
    if not args.html:
        out = out + '{::nomarkdown}'
    
    out = out + '\n{% include flickr.html'
    out = out + '\n\tsrc="' + src + '"'
    out = out + '\n\ttitle="' + title + '"'
    out = out + '\n\timg="' + img + '"'
    out = out + '\n\twidth=' + width
    out = out + '\n\theight=' + height
    out = out + '\n\t%}'

    if not args.html:
        out = out + '\n{:/nomarkdown}'

    print(out)

if __name__ == "__main__":
    main()

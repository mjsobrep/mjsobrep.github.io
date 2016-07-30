import argparse
import re

def main():
    """Main entry point from the terminal to parse flickr embed code into liquid code"""
    # Parse in arguments
    parser = argparse.ArgumentParser(
        description='convert flickr embed to liquid')

    parser.add_argument("embed_string", type=str, nargs='+',
                        help='the embed string copied from flickr.')

    parser.add_argument("--html", help="If you want the output to be for an html file.", 
                        action='store_true')

    args = parser.parse_args()

    print('')

    out = ''
    if not args.html:
        out = out + '{::nomarkdown}'
    
    out = out + '\n{% include flickr.html'
    out = out + '\n\tsrc="' + args.embed_string[1] + '"'
    out = out + '\n\ttitle="' + args.embed_string[2] + '"'
    out = out + '\n\timg="' + args.embed_string[3] + '"'
    out = out + '\n\twidth=' + args.embed_string[4]
    out = out + '\n\theight=' + args.embed_string[5]
    out = out + '\n\t%}'

    if not args.html:
        out = out + '\n{:/nomarkdown}'

    print(out)

if __name__ == "__main__":
    main()

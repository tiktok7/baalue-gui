#!/usr/bin/env python
import os
import markdown


def convert_gfm(filename):
    source = ''
    with open(filename, 'r') as f:
        source = f.read()
    return markdown.markdown(source, extensions=['gfm'])


def convert_all(base_dir='.', header=None, footer=None):
    print ("converting in %s" % base_dir)

    header_html = ''
    footer_html = ''

    if header:
        print "header: %s" % header
        with open(header, 'r') as f:
            header_html = f.read()

    if footer:
        print "footer: %s" % footer
        with open(footer, 'r') as f:
            footer_html = f.read()

    for root, dirs, files in os.walk(base_dir):
        for fname in files:
            if fname.endswith('.md'):
                md_fname = os.path.join(root, fname)
                html_fname = '.'.join([md_fname, 'htm'])
                html = ''.join([header_html,
                                convert_gfm(md_fname), footer_html])
                html = html.replace('.md"', '.md.htm"')
                with open(html_fname, 'w') as f:
                    f.write(html)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--base_dir',
                        help='convert all gfm files in directory')
    # parser.add_argument('-c', '--css', metavar='css file',
    #                     help='add link to css stylesheet')
    parser.add_argument('--header', metavar='header htm file',
                        help='add header to start of output')
    parser.add_argument('--footer', metavar='footer htm file',
                        help='add footer to start of output')
    args = parser.parse_args()
    kwargs = {}
    if args.base_dir:
        kwargs['base_dir'] = args.base_dir
    if args.header:
        kwargs['header'] = args.header
    if args.footer:
        kwargs['footer'] = args.footer
    convert_all(**kwargs)

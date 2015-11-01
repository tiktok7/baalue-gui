#!/usr/bin/env python
if __name__ != '__main__':
    import pyotherside
import os
import markdown
import codecs


def docgen(filename):
    html = ""
    with codecs.open(filename, mode="r", encoding="utf-8") as md_file:
        md_text = md_file.read()
        html = markdown.markdown(md_text)
    return html


def chdir_file(filename):
    path = os.path.dirname(filename)
    norm_path = os.path.normpath(path)
    os.chdir(norm_path)
    return norm_path

if __name__ == '__main__':
    print(docgen('../docs/howto_sdcard.md'))
    print(chdir_file('../docs/../docs/README.md'))

import xmltree, datafuncs
from htmlparser import parseHtml
from strutils import contains

proc confirmLink(head, tail : string) : string =
    if tail.contains("https") or tail.contains(head):
        result = tail

    else:
        result = "https://" & head & tail

proc parseSite*(html : string, api : Api) : seq[Data] =
    let html = parseHtml(html)
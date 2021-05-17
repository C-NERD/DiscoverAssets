import xmltree, strtabs, datafuncs
from htmlparser import parseHtml
from strutils import contains

proc correctLink(head, tail : string) : string =
    if tail.contains("https") or tail.contains(head):
        result = tail

    else:
        result = "https://" & head & tail

proc parseSite*(html : string, api : Api) : seq[Data] =

    proc getImg(asset : XmlNode, data : var Data) {.closure.} =

        for img in asset.findAll(api.img_tag, true):
            data.img = correctLink(api.website, img.attr("src"))

            if img.attrs.hasKey "title":
                data.name = img.attr("title")

            elif img.attrs.hasKey "alt":
                data.name = img.attr("alt")


    proc getLink(asset : XmlNode, data : var Data) {.closure.} =

        for link in asset.findAll(api.assetlink_tag, true):
            data.link = correctLink(api.website, link.attr("href"))

            if link.attrs.hasKey "title":
                data.name = link.attr("title")


    proc getName(asset : XmlNode, data : var Data) {.closure.} =

        for name in asset.findAll(api.name_tag, true):
            if api.name_class != "":

                if name.attr("class") == api.name_class:
                    data.name = name.innerText()

            else:
                data.name = name.innerText()


    let html = parseHtml(html)

    for asset in html.findAll(api.asset_tag, true):
        var
            data : Data
        
        data.dimension = api.dimension
        data.website = api.website
        if asset.attr("class") == api.asset_class:

            asset.getImg(data)
            if api.assetlink_tag == api.name_tag:
                asset.getLink(data)

            else:
                asset.getName(data)

            result.add(data)
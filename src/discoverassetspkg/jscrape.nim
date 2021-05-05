# This is just an example to get you started. Users of your hybrid library will
# import this file by writing ``import discover3dpkg/submodule``. Feel free to rename or
# remove this file altogether. You may create additional modules alongside
# this file as required.

from datafuncs import Data, Api
from htmlparser import parseHtml
import xmltree
from karax/kajax import ajaxGet
import karax/[kdom, vdom, karax]


proc parse3dexport(data : string, getcount : bool) : tuple[data : seq[DATA], count : int] =
    var xmldata = data.parseHtml()
    var count : int

    if getcount == true:
        for item in xmldata.findAll("a"):

            if item.attr("class") == "btn btn-primary m-b-mini" and
            item.attr("rel") == "next":
                var link = item.attr("href")
                count = (link.split("=")[^1]).parseInt
                break

    for each in xmldata.findAll("div"):
        
        if each.attr("class") == "dribomos":
            var answ : DATA
            var name = each.attr("data-name")

            for item in xmldata.findAll("span"):

                if item.attr("class") == "thumbnail":
                    var linknode = item.child("a")
                    var link = linknode.attr("href")
                    var image = linknode.child("img").attr("src")
                    answ.name = $name
                    answ.dimension = "3d"
                    answ.img = $image
                    answ.link = $link
                    answ.website = "3dexport.com"
            
            result.data.add(answ)

    result.count = count
    condition = true

proc parseclara(data : string, getcount : bool) : tuple[data : seq[DATA], count : int] =
    var xmldata = data.parseHtml()
    var count : int

    if getcount == true:
        for item in xmldata.findAll("ul"):
            if item.attr("class") == "pagination":
                var content = item.findAll("li")
                var total = content[1].child("span").innerText.split(" ")[^1].parseInt
                count = (total / 50).toInt
                break

    for item in xmldata.findAll("a"):
        if item.attr("class") == "thumbnail":
            var imagenode = item.child("div").child("img")
            var info : DATA
            info.link = item.attr("href")
            info.dimension = "3d"
            info.website = "clara.io"
            info.img = imagenode.attr("src")
            info.name = imagenode.attr("title")

            result.data.add(info)

    result.count = count
    condition = true


proc parseblendswap(data : string, getcount : bool) : tuple[data : seq[DATA], count : int] =
    var xmldata = data.parseHtml()
    var count : int

    if getcount == true:
        var countcan : seq[XmlNode]
        try:
            for item in xmldata.findAll("a"):
                if item.attr("class") == "page-link page-number":
                    countcan.add(item)

            count = countcan[^1].innerText.parseInt

        except:
            discard

    for item in xmldata.findAll("div"):
        if item.attr("class") == "card":
            var info : DATA
            var linknode = item.child("a")
            if linknode != nil:
                info.link = linknode.attr("href")
                info.dimension = "3d"
                info.website = "blendswap.com"
                info.name = linknode.child("img").attr("title")
                info.img = linknode.child("img").attr("src")

                result.data.add(info)

    result.count = count
    condition = true

proc parse3dmodelhaven(data : string, getcount : bool) : tuple[data : seq[DATA], count : int] =
    var xmldata = data.parseHtml()
    var count : int

    for item in xmldata.findAll("div"):
        if item.attr("id") == "item-grid":
            var info = item.findAll("a")
            for each in info:
                var infos : DATA
                infos.link = each.attr("href")
                infos.dimension = "3d"
                infos.website = "3dmodelhaven.com"
                for i in each.findAll("img"):
                    if i.attr("class") == "thumbnail":
                        infos.img = i.attr("src")
                        infos.name = i.attr("alt")

                result.data.add(infos)

    result.count = count
    condition = true

proc parseopengameart(data : string, getcount : bool) : tuple[data : seq[DATA], count : int] =
    var xmldata = data.parseHtml()
    var count : int

    if getcount == true:
        for item in xmldata.findAll("a"):
            if item.attr("title") == "Go to last page":
                count = item.attr("href").split("=")[^1].parseInt
                break
            else:
                continue

    for item in xmldata.findAll("div"):
        if item.attr("class") == "ds-1col node node-art view-mode-art_preview clearfix":
            try:
                var info : DATA
                var infos = item.findAll("a")
                info.name = infos[0].innerText
                if infos[1] == nil:
                    info.link = infos[0].attr("href")
                    info.img = infos[0].child("img").attr("src")
                else:
                    info.link = infos[1].attr("href")
                    info.img = infos[1].child("img").attr("src")
                    
                info.dimension = "2d"
                info.website = "opengameart.org"

                result.data.add(info)

            except:
                continue
            
    result.count = count
    condition = true

proc parsegameart2d(data, keyword : string) : tuple[data : seq[DATA], count : int] =
    var xmldata = data.parseHtml()
    var count : int

    for item in xmldata.findAll("div"):
        if item.attr("class") == "galleryInnerImageHolder":
            var linknode = item.child("a")
            var name = linknode.attr("title")
    
            if not (name.toLowerAscii.contains(keyword.toLowerAscii)):
                continue

            var info : DATA
            info.link = linknode.attr("href")
            info.name = name
            info.website = "gameart2d.com"
            info.dimension = "2d"
            info.img = linknode.child("img").attr("src")

            result.data.add(info)

    result.count = count


proc parsecraftpix(data : string, getcount : bool) : tuple[data : seq[DATA], count : int] =
    var xmldata = data.parseHtml()
    var count : int

    if getcount == true:
        for item in xmldata.findAll("a"):
            if item.attr("class") == "last":
                var link = item.attr("href")
                count = link.split("/")[^2].parseInt
                break
    

    for item in xmldata.findAll("div"):
        if item.attr("class") == "blog-grid-item":
            var variant = item.child("div")[2].innerText
            
            if variant.strip == "free":
                var info : DATA
                info.website = "craftpix.net"
                info.dimension = "2d"
                var linknode = item.child("a")
                info.name = linknode.attr("title")
                info.link = linknode.attr("href")
                var imgnode = item.findAll("img")
                info.img = (imgnode[0].attr("data-srcset")).split(" ")[0]

                result.data.add(info)

    result.count = count
    condition = true

proc toCstr(data : string) : cstring =
    var data : cstring = data
    result = data

proc comlink(tail, head : string) : string =
    if tail.contains("https") or tail.contains(head):
        result = tail

    else:
        result = "https://" & head & tail

proc addmodels(data : tuple[data : seq[DATA], count : int], name : string) =
    var canvas = getElementById("models")
    var size = data.data.len
    var count1 = 0
    var count2 = 3
    var prev : string
    
    if data.data == fluke.data:
        for item in statuss:
            if $item.name == name:
                item.cond = false
                if pos == 1:
                    constatus()
                break
            else:
                continue


    if size > 4:
        for i in 0..(size div 4):
            var row = newVNode(tdiv)
            row.setAttr("class", "row")
            var rown = row.vnodeToDom
            
            for j in count1..count2:
                if prev == data.data[j].link:
                    continue

                prev = data.data[j].link
                var model = newVNode(tdiv)
                var name = newVNode(p)
                var site = newVNode(p)
                var dimension = newVNode(p)
                var img = newVNode(img)
                var link = newVNode(a)

                link.setAttr("href", data.data[j].link.comlink(data.data[j].website))
                img.setAttr("src", data.data[j].img.comlink(data.data[j].website))

                var modeln = model.vnodeToDom
                var linkn = link.vnodeToDom
                var imgn = img.vnodeToDom
                var siten = site.vnodeToDom
                siten.innerText = data.data[j].website.toCstr
                var namen = name.vnodeToDom
                namen.innerText = data.data[j].name.toCstr
                var dimensionn = dimension.vnodeToDom
                dimensionn.innerText = data.data[j].dimension.toCstr

                modeln.appendChild(imgn)
                modeln.appendChild(namen)
                modeln.appendChild(siten)
                modeln.appendChild(dimensionn)
                linkn.appendChild(modeln)
                rown.appendChild(linkn)

            count1 = count2 + 1
            count2 = count1 + 3

            if rown.children != @[]:
                canvas.appendChild(rown)
    else:
        var row = newVNode(tdiv)
        row.setAttr("class", "row")
        var rown = row.vnodeToDom

        for j in count1..count2:
            if prev == data.data[j].link:
                continue

            prev = data.data[j].link
            var model = newVNode(tdiv)
            var name = newVNode(p)
            var site = newVNode(p)
            var dimension = newVNode(p)
            var img = newVNode(img)
            var link = newVNode(a)

            link.setAttr("href", data.data[j].link.comlink(data.data[j].website))
            img.setAttr("src", data.data[j].img.comlink(data.data[j].website))

            var modeln = model.vnodeToDom
            var linkn = link.vnodeToDom
            var imgn = img.vnodeToDom
            var siten = site.vnodeToDom
            siten.innerText = data.data[j].website.toCstr
            var namen = name.vnodeToDom
            namen.innerText = data.data[j].name.toCstr
            var dimensionn = dimension.vnodeToDom
            dimensionn.innerText = data.data[j].dimension.toCstr

            modeln.appendChild(imgn)
            modeln.appendChild(namen)
            modeln.appendChild(siten)
            modeln.appendChild(dimensionn)
            linkn.appendChild(modeln)
            rown.appendChild(linkn)

            count1 = count2 + 1
            count2 = count1 + 3

            if rown.children != @[]:
                canvas.appendChild(rown)

proc refineurl(url : string) : string =
    var url = url.split("/")
    url[^3] = $pos

    for item in url:
        result.add($item & "/")

    result.removeSuffix('/')

proc getdata*(info : seq[URL], url, keyword : string, page : int)  =
    var headers : seq[(cstring, cstring)]

    if page == 1:
        for item in info:
            var url = url
            try:
                case $item.name

                of "3dexport.com":
                    url = url & "/3dexport.com"
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parse3dexport($resp, true)
                                if count < data.count:
                                    count = data.count
                                addmodels(data, "3dexport.com")
                        )


                of "clara.io":
                    url = url & "/clara.io"
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parseclara($resp, true)
                                if count < data.count:
                                    count = data.count
                                addmodels(data, "clara.io")
                        )

                of "blendswap.com":
                    url = url & "/blendswap.com"
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parseblendswap($resp, true)
                                if count < data.count:
                                    count = data.count
                                addmodels(data, "blendswap.com")
                        )

                of "3dmodelhaven":
                    url = url & "/3dmodelhaven"
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parse3dmodelhaven($resp, true)
                                if count < data.count:
                                    count = data.count
                                addmodels(data, "3dmodelhaven")
                        )

                of "opengameart.org":
                    url = url & "/opengameart.org"
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parseopengameart($resp, true)
                                if count < data.count:
                                    count = data.count
                                addmodels(data, "opengameart.org")
                        )

                of "gameart2d.com":
                    url = url & "/gameart2d.com"
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parsegameart2d($resp, keyword)
                                addmodels(data, "gameart2d.com")
                        )

                of "craftpix.net":
                    url = url & "/craftpix.net"
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parsecraftpix($resp, true)
                                if count < data.count:
                                    count = data.count
                                addmodels(data, "craftpix.net")
                        )

                else:
                    continue

            except:
                continue

    else:
        for item in info:
            var url = url
            try:
                case $item.name

                of "3dexport.com":
                    url = url & "/3dexport.com"
                    url = url.refineurl
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parse3dexport($resp, false)
                                addmodels(data, "3dexport.com"))


                of "clara.io":
                    url = url & "/clara.io"
                    url = url.refineurl
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parseclara($resp, false)
                                addmodels(data, "clara.io"))

                of "blendswap.com":
                    url = url & "/blendswap.com"
                    url = url.refineurl
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parseblendswap($resp, false)
                                addmodels(data, "blendswap.com"))

                #[of "3dmodelhaven":
                    url = url & "/3dmodelhaven"
                    url = url.refineurl
                    echo url
                    ajaxGet(url, headers, proc(status : int, resp : cstring) =
                        if status == 200:
                            var data = parse3dmodelhaven($resp, false)
                            addmodels(data))]#

                of "opengameart.org":
                    url = url & "/opengameart.org"
                    url = url.refineurl
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parseopengameart($resp, false)
                                addmodels(data, "opengameart.org"))

                #[of "gameart2d.com":
                    url = url & "/gameart2d.com"
                    ajaxGet(url, headers, proc(status : int, resp : cstring) =
                        if status == 200:
                            var data = parsegameart2d($resp, keyword)
                            addmodels(data)
                            if count < data.count:
                                count == data.count)]#

                of "craftpix.net":
                    url = url & "/craftpix.net"
                    url = url.refineurl
                    discard newPromise() do (resolve: proc()):
                        ajaxGet(url, headers, proc(status : int, resp : cstring) =
                            if status == 200:
                                var data = parsecraftpix($resp, false)
                                addmodels(data, "craftpix.net"))
        
                else:
                    continue

            except:
                continue
from datafuncs import Data, Api
from htmlparser import parseHtml
import xmltree
from karax/kajax import ajaxGet
import karax/[kdom, vdom, karax]


proc parseSite(html : string, api : Api) : seq[Data] =
    var html = parseHtml(html)
    discard


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
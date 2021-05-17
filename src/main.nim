import karax / [karax, karaxdsl, vdom, kdom], global, datafuncs, asyncjs, domparse
from json import to, `$`
from strutils import split, format


proc getKeyword() : string =
    result = ($window.location.href).split('/')[^1]


proc getInfo(data : Site, page : string) {.async.} =
    let
        container = getElementById("container")

    for api in data.apis:
        let
            keyword = getKeyword()
            page = page
            form = @[
                (keys : "url", values : $(api.link.format([keyword, page])))
            ]

            info = await callBackend($window.location.href, form)

        #echo info
        for intel in parseSite(info, api):
            echo intel
            #try:
            container.appendChild(makeAssetNode(intel).vnodeToDom())

            #except:
            #    continue

proc getData(page : string) {.async.} =
    let
        info = await callApi($window.location.href & "/../../sites")
        site = info.to(Site)

    discard site.getInfo(page)


proc home(): VNode =

    result = buildHtml(main(id = "canvas")):
        background()

        span(id = "content"):
            navBar()
            searchBar(getKeyword(), false)

            span(id = "container")

            bottomBar()

when isMainModule:
    setRenderer home

    discard setTimeout(
        proc() {.closure.} =
            discard getData($1)
        ,
        500
    )
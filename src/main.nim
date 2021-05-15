import karax / [karax, karaxdsl, vdom, kdom], global, datafuncs, asyncjs
from json import to, `$`
from strutils import split, format


proc getKeyword() : string =
    result = ($window.location.href).split('/')[^1]


proc getInfo(data : Site, page : string) {.async.} =

    for api in data.apis:
        let
            keyword = getKeyword()
            page = page
            form = @[
                (keys : "url", values : $(api.link.format([keyword, page])))
            ]

            info = await callBackend($window.location.href, form)

        echo info


proc getData(page : string) {.async.} =
    let
        info = await callApi($window.location.href & "/../../sites")
        site = info.to(Site)

    discard site.getInfo(page)


discard setTimeout(
    proc() {.closure.} =
        discard getData($1)
    ,
    0
)

proc home(): VNode =

    result = buildHtml(main(id = "canvas")):
        background()

        span(id = "content"):
            navBar()
            searchBar(readCookies("query"), false)

            span(id = "container")

            bottomBar()

when isMainModule:
    setRenderer home
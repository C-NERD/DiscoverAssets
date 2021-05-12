import karax / [karax, karaxdsl, vdom, kdom]
import global
#import jscrape

#[let
    url = window.location.href
    height : int = window.innerHeight

window.addEventListener("scroll", proc (e : Event) {.closure.} =
    var 
        model = getElementById("models")
        top = document.documentElement.scrollTop
        limit = document.documentElement.scrollHeight - height
    
    if top > limit - (height/4).toInt:
        discard
        #[if pos < count and model.children != @[] and condition == true:
            pos.inc
            condition = false
            getdata(geturl(), $url, $getkeyword(), pos)

        elif pos > count or pos == count: 
            var modelcon = getElementById("modelcon")
            var child = getElementById("loadimg")
            modelcon.removeChild(child)]#
,true
)]#


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
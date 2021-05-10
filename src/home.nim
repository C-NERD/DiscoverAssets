import karax / [karax, karaxdsl, vdom, kdom]
import global

proc home(): VNode =
    result = buildHtml(main(id = "canvas")):
        background()

        span(id = "content"):
            navBar()
        
            tdiv(id = "main"):
                searchBar("")

            bottomBar()

when isMainModule:
    setRenderer home
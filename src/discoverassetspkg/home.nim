import karax / [karax, karaxdsl, vdom, kdom]
import global

proc home(): VNode =
    result = buildHtml(main(id = "canvas")):
        navBar()
        
        tdiv(id = "main"):
            searchBar("")
            tdiv(id = "logo"):
                text "DiscoverAssets"

        bottomBar()

when isMainModule:
    setRenderer home
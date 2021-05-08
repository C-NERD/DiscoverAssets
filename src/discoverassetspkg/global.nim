import karax / [karaxdsl, vdom]

proc navBar*(hide : bool = false) : VNode =
    result = buildHtml(nav(id = "nav")):

            if hide:
                tdiv(id = "logo"):
                    text "DiscoverAssets"

            tdiv(id = "setbtn"):
                a(href = "/settings"):
                    tdiv(class = "tinybtns", id = "settings")
                tdiv(class = "tinybtns", id = "theme")


proc searchBar*(keyword : cstring, hide : bool = true) : VNode =
    result = buildHtml(form(action = "/", Method = "POST", id = "mainsearch", enctype = "multipart/form-data")):
        tdiv(id = "searchgroup"):
            tdiv(id = "searchbar"):
                input(Type = "text", placeholder = "Search Assets", name = "tag", value = $keyword)
                button(Type = "search", id = "searchbtn")

        if not hide:
            ul(class = "unorder"):
                tdiv(class = "order"):
                    text "3D"

                tdiv(class = "order"):
                    text "2D"

proc bottomBar*() : VNode =
    result = buildHtml(footer(id = "foot")):
        text "@Cnerd 2021"
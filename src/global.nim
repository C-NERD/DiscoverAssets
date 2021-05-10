import karax / [karax, karaxdsl, vdom, kdom]

proc background*() : VNode =
    result = buildHtml(span(id = "background")):
        for num in 1..3:
            tdiv(class = "backgroundrow"):
                tdiv(class = "colouredcircle", id = "colouredcircle" & $num)


proc navBar*() : VNode =
    proc changeTheme(ev : Event, n : VNode) {.closure.} =
        let html = document.getElementsByTagName("html")
        
        if html[0].style.background == "rgb(151, 160, 162)":
            html[0].style.background = "rgb(254 254 254)"

        else:
            html[0].style.background = "rgb(151 160 162)"

    result = buildHtml(nav(id = "nav")):

            tdiv(id = "logo")

            tdiv(id = "setbtn"):
                tdiv(class = "tinybtnsback"):
                    a(href = "/"):
                        tdiv(class = "tinybtns", id = "home")

                tdiv(class = "tinybtnsback"): 
                    a(href = "/settings"):
                        tdiv(class = "tinybtns", id = "settings")
                        
                #tdiv(class = "tinybtns", id = "theme", onclick = changeTheme)


proc searchBar*(keyword : cstring, hide : bool = true) : VNode =
    var
        formid = "searchform"

    if not hide:
        formid = "mainsearchform"

    result = buildHtml(form(action = "/", Method = "POST", id = formid, enctype = "multipart/form-data")):
        tdiv(id = "searcharea"):
            tdiv(id = "searchbar"):
                input(Type = "text", placeholder = "Asset name", name = "tag", value = $keyword)
                button(Type = "search", id = "searchbtn")

        if not hide:
            ul(class = "unorder"):
                tdiv(class = "order"):
                    text "All"

                tdiv(class = "order"):
                    text "3D"

                tdiv(class = "order"):
                    text "2D"

proc bottomBar*() : VNode =
    result = buildHtml(footer(id = "foot")):
        text "@Cnerd 2021"
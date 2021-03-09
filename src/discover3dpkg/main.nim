include karax / prelude
import karax / [kdom]
import jscrape

var
    height : int = window.innerHeight

proc menu(e : Event, n : VNode) =
    var line1 = getElementById("line1")
    var line2 = getElementById("line2")
    var line3 = getElementById("line3")
    var menu = getElementById("menu")
    var legal = getElementById("legal")
    var social = getElementById("social")
    var img = getElementById("loadimg")

    if menu.className == "menu1":
        line1.class = "line11"
        line2.class = "line21"
        line3.class = "line31"
        menu.class = "menu2"
        legal.style.display = "block"
        social.style.display = "block"
        img.style.display = "none"

    elif menu.className == "menu2":
        line1.class = ""
        line2.class = ""
        line3.class = ""
        menu.class = "menu1"
        legal.style.display = "none"
        social.style.display = "none"
        img.style.display = "block"

var url = window.location.href
getdata(geturl(), $url, $getkeyword(), 1)

window.addEventListener("scroll", proc (e : Event) {.closure.} =
    var model = getElementById("models")
    var top = document.documentElement.scrollTop
    var limit = document.documentElement.scrollHeight - height
    
    if top > limit - (height/4).toInt:
        if pos < count and model.children != @[] and condition == true:
            pos.inc
            condition = false
            getdata(geturl(), $url, $getkeyword(), pos)

        elif pos > count or pos == count: 
            var modelcon = getElementById("modelcon")
            var child = getElementById("loadimg")
            modelcon.removeChild(child)
,true
)

proc setdimension(e : Event, n : VNode) =
    var dimension = getdimension()

    if dimension == "3D":
        var box = getElementById("3dbox")
        box.checked = true

    elif dimension == "2D":
        var box = getElementById("2dbox")
        box.checked = true

    else:
        var box = getElementById("3dbox")
        var box2 = getElementById("2dbox")
        box.checked = true
        box2.checked = true

var info = clean()
proc home(): VNode =
    
    result = buildHtml(main(id = "canvas")):
        nav(id = "nav"):
            form(action = "/", Method = "POST", id = "mainsearch", enctype = "multipart/form-data"):
                tdiv(id = "searchgroup"):
                    tdiv(id = "searchbar"):
                        input(Type = "text", placeholder = "Search Assets", name = "tag", value = getkeyword())
                        button(Type = "search", id = "searchbtn"):
                            img(src = "../../../../img/search.svg", onload = setdimension)
                ul(class = "unorder"):
                    li(class = "order"):
                        h3:
                            text "3D"
                        input(Type = "checkbox", name = "3D", id = "3dbox")

                    li(class = "order"):
                        h3:
                            text "2D"
                        input(Type = "checkbox", name = "2D", id = "2dbox")


            tdiv(id = "burg", onclick = menu):
                tdiv(id = "line1", class = "")
                tdiv(id = "line2", class = "")
                tdiv(id = "line3", class = "")

        tdiv(id = "menu", class = "menu1"):
            tdiv(id = "legal"):
                a(href = "/policy"):
                    text "Privacy Policies"

                a(href = "/"):
                    text "Home"

            tdiv(id = "social"):
                a(href = info.youtube):
                    p:
                        text "Youtube"
                    tdiv(id = "youtube", class = "social")
                a(href = info.twitter):
                    p:
                        text "Twitter"
                    tdiv(id = "twitter", class = "social")
                a(href = info.mail):
                    p:
                        text "Contact me via gmail"
                    tdiv(id = "gmail", class = "social")

        tdiv(id = "modelcon"):
            tdiv(id = "models")
            tdiv(id = "loadimg")

when isMainModule:
    setRenderer home
include karax / prelude
import karax / kdom
from strutils import parseBool

proc menu(e : Event, n : VNode) =
    var line1 = getElementById("line1")
    var line2 = getElementById("line2")
    var line3 = getElementById("line3")
    var menu = getElementById("menu")

    if menu.className == "menu1":
        line1.class = "line11"
        line2.class = "line21"
        line3.class = "line31"
        menu.class = "menu2"

    elif menu.className == "menu2":
        line1.class = ""
        line2.class = ""
        line3.class = ""
        menu.class = "menu1"

proc cancelnotification(e : Event, n : VNode) =
    var notification = getElementById("notification")
    var parent = notification.parentNode
    parent.removeChild(notification)

proc home(): VNode =

    proc hide(e : Event, n : VNode) {.closure.} =
        var ad = getElementById("amzn-assoc-ad-55d1182b-8b25-4cc6-960b-201cf7162da5")
        ad.class = "hide"

    proc clean() : tuple[youtube, twitter, mail, logo, notification : cstring, notify : bool] =
        var youtube = getElementById("youtubelink")
        var twitter = getElementById("twitterlink")
        var mail = getElementById("maillink")
        var logo = getElementById("logoname")
        var notification = getElementById("notifyinfo")
        var notify = getElementById("notifybool")

        var parent = logo.parentNode

        result.youtube = youtube.value
        result.twitter = twitter.value
        result.mail = mail.value
        result.logo = logo.value
        result.notification = notification.value
        result.notify = ($notify.value).parseBool
            
        parent.removeChild(logo)
        parent.removeChild(youtube)
        parent.removeChild(twitter)
        parent.removeChild(mail)
        parent.removeChild(notification)
        parent.removeChild(notify)

    var info = clean()
    result = buildHtml(main(id = "canvas")):

        nav(id = "navbar"):
            tdiv(id = "burger", onclick = menu):
                tdiv(id = "line1", class = "")
                tdiv(id = "line2", class = "")
                tdiv(id = "line3", class = "")

        tdiv(id = "menu", class = "menu1"):
            tdiv(id = "legal"):
                a(href = "/policy"):
                    text "Privacy Policies"

            tdiv(id = "social"):
                a(href = $info.youtube):
                    p:
                        text "Youtube"
                    tdiv(id = "youtube", class = "social")
                a(href = $info.twitter):
                    p:
                        text "Twitter"
                    tdiv(id = "twitter", class = "social")
                a(href = $info.mail):
                    p:
                        text "Contact me via gmail"
                    tdiv(id = "gmail", class = "social")

        tdiv(id = "main"):
            tdiv(id = "logo"):
                for item in info.logo:
                    h2(class = "logochar", id = $item):
                        text $item

            form(action = "/", Method = "POST", id = "search", enctype = "multipart/form-data"):
                tdiv(id = "searchgroup"):
                    tdiv(id = "searchbar"):
                        input(Type = "text", placeholder = "Search Assets", name = "tag")
                        button(Type = "search", id = "searchbtn"):
                            img(src = "img/search.svg", onload = hide)
                ul(class = "unordered"):
                    li(class = "ordered"):
                        h3:
                            text "3D"
                        input(Type = "checkbox", name = "3D")

                    li(class = "ordered"):
                        h3:
                            text "2D"
                        input(Type = "checkbox", name = "2D")


        if info.notify == true:
            tdiv(class = "admininfo", id = "notification"):
                tdiv(id = "notify"):
                    p:
                        text "notification"

                    tdiv(id = "notifycancel", onclick = cancelnotification):
                        tdiv(class = "line11")
                        tdiv(class = "line31")

                tdiv(id = "notifyinfo"):
                    text info.notification
                    
        footer(id = "foot"):
            text "made by cnerd"

when isMainModule:
    setRenderer home
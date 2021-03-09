include karax / prelude
import karax / kdom
from strutils import splitlines, strip, splitWhitespace, find, format, replaceWord

proc parseMarkdown(info : cstring) : cstring {.importc.}

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

proc home(): VNode =

    proc clean() : tuple[youtube, twitter, mail, policy : cstring] =
        var youtube = getElementById("youtubelink")
        var twitter = getElementById("twitterlink")
        var mail = getElementById("maillink")
        var policy = getElementById("policyinfo")
        var logo = getElementById("logoname")
        var notification = getElementById("notifyinfo")
        var notify = getElementById("notifybool")

        var parent = logo.parentNode

        result.youtube = youtube.value
        result.twitter = twitter.value
        result.mail = mail.value
        result.policy = (policy.value).parseMarkdown
            
        parent.removeChild(logo)
        parent.removeChild(youtube)
        parent.removeChild(twitter)
        parent.removeChild(mail)
        parent.removeChild(policy)
        parent.removeChild(notification)
        parent.removeChild(notify)

    var info = clean()
    
    discard setTimeout(
        proc() {.closure.} =
            var policy = getElementById("policy")
            policy.innerHTML = info.policy
        ,1000
    )
    
    result = buildHtml(main(id = "canvas")):
        nav(id = "navbar"):
            tdiv(id = "burger", onclick = menu):
                tdiv(id = "line1", class = "")
                tdiv(id = "line2", class = "")
                tdiv(id = "line3", class = "")

        tdiv(id = "menu", class = "menu1"):
            tdiv(id = "legal"):
                a(href = "/"):
                    text "Home"

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

        tdiv(id = "policy")

when isMainModule:
    setRenderer home
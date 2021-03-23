include karax / prelude
import karax / kdom
from json import parseJson, items, getStr 
from strutils import strip, parseBool, removePrefix, removeSuffix, unescape, format
from strformat import fmt


proc getCookies() : seq[tuple[key : string, value : string]] =
    var info = decodeURIComponent(document.cookie)
    var data : tuple[key : string, value : string]

    for item in info.split(";"):
        var keyvalue = item.split("=")
            
        if keyvalue[0].strip() == "position" or keyvalue[0].strip() == "type" or keyvalue[0].strip() == "message":
            data.key = $keyvalue[0]
            data.value = $keyvalue[1]
            result.add(data)
            

proc prettystr(info : string) : string =
    var info = info
    info.removePrefix("\"")
    info.removeSuffix("\"")

    result = info

proc ad(e : Event, n : VNode) =
    var forminfo = getElementById("siteads")
    var countinfo = getElementById("count")
    var count = (countinfo.value).parseInt

    proc delparent(e : Event) {.closure.} =

        if count == 0:
            var parent = getElementById("cancel" & $count).parentNode
            var parentparent = parent.parentNode

            parentparent.removeChild(parent)

        else:
            var parent = getElementById("cancel" & $(count - 1)).parentNode
            var parentparent = parent.parentNode

            parentparent.removeChild(parent)


    var child = newVNode(tdiv)
    var childchild = newVNode(input)
    var cancel = newVNode(tdiv)
    var line1 = newVNode(tdiv)
    var line2 = newVNode(tdiv)

    cancel.setAttr("id", "cancel" & $count)
    cancel.setAttr("class", "cancel")
    cancel.setAttr("onclick", "delparent")
    line1.setAttr("id", "line1111")
    line2.setAttr("id", "line2222")
    child.setAttr("class", "add")
    childchild.setAttr("type", "text")
    childchild.setAttr("name", "ad" & $count)
    childchild.setAttr("placeholder", "ad link")

    count.inc

    var nchild = child.vnodeToDom
    var nchildchild = childchild.vnodeToDom
    var ncancel = cancel.vnodeToDom
    ncancel.onclick = delparent
    var nline1 = line1.vnodeToDom
    var nline2 = line2.vnodeToDom
    ncancel.appendChild(nline1)
    ncancel.appendChild(nline2)
    nchild.appendChild(nchildchild)
    nchild.appendChild(ncancel)
    forminfo.appendChild(nchild)
    countinfo.value = $count


proc piechart(s, m, p : int) : proc() =
    result = proc() =
    
        var sdeg : int
        var mdeg : int
        var pdeg : int
        var denum = s + m + p

        if s == 0 and m == 0 and p == 0:
            sdeg = 120
            mdeg = 120
            pdeg = 120

        elif s != 0 and m == 0 and p == 0:
            sdeg = ((s / denum) * 360).toInt
            mdeg = 0
            pdeg = 0
        
        elif s == 0 and m != 0 and p == 0:
            mdeg = ((m / denum) * 360).toInt
            sdeg = 0
            pdeg = 0

        elif s == 0 and m == 0 and p != 0:
            pdeg = ((p / denum) * 360).toInt
            sdeg = 0
            mdeg = 0
        
        else:
            mdeg = ((m / denum) * 360).toInt
            sdeg = ((s / denum) * 360).toInt
            pdeg = ((p / denum) * 360).toInt

        var sty : cstring = fmt"""conic-gradient(
        aqua {sdeg}deg,
        rgb(74, 255, 67) 0deg {mdeg + sdeg}deg,
        rgb(255, 52, 52) 0deg {pdeg}deg
        )"""

        var pie = getElementById("piechart")
        pie.style.backgroundImage = sty


proc setimage() {.importc.}

proc home() : VNode =

    proc clean() : tuple[logo, youtube, twitter, mail, notification, notify, policy : cstring,  page1, page2, page3 : int, ads : seq[kstring]] =
        var logo = getElementById("logoname")
        var youtube = getElementById("youtubelink")
        var twitter = getElementById("twitterlink")
        var mail = getElementById("maillink")
        var notification = getElementById("notifyinfo")
        var notify = getElementById("notifybool")
        var page1 = getElementById("searchnum")
        var page2 = getElementById("mainnum")
        var page3 = getElementById("policynum")
        var policy = getElementById("policyinfo")
        var ads = getElementById("siteads")

        var parent = logo.parentNode
        var adsarray : seq[kstring]
        if not ads.isNil:
            if ads.innerText != "":
                var jdata : string = $ads.innerText
                var siteads = parseJson(jdata)
                for item in items(siteads):
                    adsarray.add((item.getStr.unescape).prettystr)

            parent.removeChild(ads)

        result.logo = logo.value
        result.youtube = youtube.value
        result.twitter = twitter.value
        result.mail = mail.value
        result.notification = notification.value
        result.notify = notify.value
        result.page1 = (page1.value).parseInt
        result.page2 = (page2.value).parseInt
        result.page3 = (page3.value).parseInt
        result.policy = policy.value
        result.ads = adsarray
            
        parent.removeChild(logo)
        parent.removeChild(youtube)
        parent.removeChild(twitter)
        parent.removeChild(mail)
        parent.removeChild(notification)
        parent.removeChild(notify)
        parent.removeChild(page1)
        parent.removeChild(page2)
        parent.removeChild(page3)
        parent.removeChild(policy)


    var info = clean()        
    var data = getCookies()
        
    proc condition() = 
        var check = getElementById("notifycond")

        if ($info.notify).parseBool == true:
            check.checked = true
        else:
            check.checked = false

    discard setTimeout(condition, 100)
    discard setTimeout(piechart(info.page1, info.page2, info.page3), 100)


    proc addimg(e : Event, n : VNode) {.closure.} =
        var info = getElementById("polimg")
        setimage()
        info.value = ""
        

    result = buildHtml(main):
        main(id = "canvas"):

            tdiv(id = "input"):
                form(class = "admininfo", id = "analytics", Method = "POST", action = "/visitors"):
                    p(id = "svisitors"):
                        text "Search Page : " & $info.page1

                    p(id = "mvisitors"):
                        text "Assets Page : " & $info.page2

                    p(id = "pvisitors"):
                        text "Policy Page : " & $info.page3

                    p:
                        text "Total visitors since reset : " & $(info.page1 + info.page2 + info.page3)

                    tdiv(id = "piechart")

                    input(Type = "submit", value = "Reset", class = "btn")

                tdiv(id = "linkandpass"):

                    form(class = "admininfo", id = "authentication", Method = "POST", enctype = "multipart/form-data", action = "/password"):
                        label:
                            text "reset password"
                        input(Type = "password", name = "olpassword", placeholder = "old password")
                        input(Type = "password", name = "password", placeholder = "new password")
                        input(Type = "password", name = "repassword", placeholder = "retype password")
                        input(Type = "submit", value = "Submit", class = "btn")

                        if data != @[]:
                        
                            if data[0].value == "password" and data[1].value == "error":
                                p(class = "red"):
                                    text data[2].value

                            elif data[0].value == "password" and data[1].value == "success":
                                p(class = "green"):
                                    text data[2].value
                    
                    form(class = "admininfo", id = "socialmedia", Method = "POST", enctype = "multipart/form-data", action = "/social"):
                        label:
                            text "social media links"
                        input(Type = "text", name = "youtube", placeholder = "link to Youtube channel", value = info.youtube)
                        input(Type = "text", name = "twitter", placeholder = "link to Twitter handle", value = info.twitter)
                        input(Type = "text", name = "mail", placeholder = "link to mail account", value = info.mail)
                        input(Type = "submit", value = "Submit", class = "btn")

            form(class = "admininfo", id = "sitelogo", Method = "POST", enctype = "multipart/form-data", action = "/logo"):
                label:
                    text "Site name"
                input(Type = "text", name = "logo", id = "logoentry", placeholder = "logo", value = info.logo)
                input(Type = "submit", value = "Submit", class = "btn")

            form(class = "admininfo", id = "sitepolicy", Method = "POST", enctype = "multipart/form-data", action = "/policy"):
                label:
                    text "privacy policy"
                input(Type = "file", accept = "image/*", class = "hide", id = "polimg", onchange = addimg)
                label(class = "btn", For = "polimg"):
                    p:
                        text "Add image"
                textarea(name = "policy", placeholder = "Type in the site's privacy policy", id = "privacy", value = info.policy)
                input(Type = "submit", value = "Submit", class = "btn")

            form(class = "admininfo", id = "sitenotification", Method = "POST", enctype = "multipart/form-data", action = "/notification"):
                label:
                    text "notification"
                textarea(name = "notification", placeholder = "Type in notification for users to see", value = info.notification)
                
                input(Type = "checkbox", name = "notifycond", id = "notifycond")
                input(Type = "submit", value = "Submit", class = "btn")
                
            form(class = "admininfo", id = "siteads", Method = "POST", enctype = "multipart/form-data", action = "/ads"):
                input(Type = "hidden", name = "count", value = $info.ads.len, id = "count")
                label:
                    text "ad links"
                tdiv(class = "add"):
                    tdiv(id = "plus", onclick = ad):
                        tdiv(id = "line111")
                        tdiv(id = "line222")

                input(Type = "submit", value = "Submit", class = "btn")

                proc delparent(id : kstring) : proc() =
                    result = proc() =
                        var parent = getElementById($id).parentNode
                        var parentparent = parent.parentNode

                        parentparent.removeChild(parent)
                
                for i in 0..<(info.ads).len:
                    
                    tdiv(class="add"):
                        input(type="text", name="ad" & $i, placeholder="ad link", value = $info.ads[i])
                        tdiv(id="cancel" & $i, class="cancel", onclick = delparent("cancel" & $i)):
                            tdiv(id="line1111")
                            tdiv(id="line2222")
                

when isMainModule:
    setRenderer home
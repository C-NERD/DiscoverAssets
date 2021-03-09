# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import jester, asyncdispatch
import discover3dpkg/[datafuncs]
from md5 import toMD5, `$`
from times import now, seconds, `+`, hours, utc
from strutils import parseInt, escape, unescape, removePrefix, removeSuffix, strip, format
from sequtils import concat, filterIt
from httpclient import newHttpClient, getContent
include "discover3dpkg/views.tmpl"

proc getinfo(name, query, num : string, url : tuple[d3 : URL, d2 : URL]) : Future[string] {.async.} =
    try:
        var client = newHttpClient()
        var allurl = url.d3.info.concat(url.d2.info)

        var link = allurl.filterIt(it.name == name)
    
        result = client.getContent(link[0].url.format([query, num]))
        echo now().utc, "   got data from third party"
    except:
        result = ""


routes:
    get "/":
        echo now().utc, "   loading home page"
        var data = getsearch()
        resetvisitors("search")
        resp frontend("home", "", data)

    post "/":
        echo now().utc, "   searching"
        var query = request.formData.getOrDefault("tag").body
        if query == "":
            query = "Not found"
        var check = checkpass(query)
        var d3 = request.formData.getOrDefault("3D").body
        var d2 = request.formData.getOrDefault("2D").body

        if check.condition == true:
            echo now().utc, "   authenticating admin password"
            setCookie("pass", check.escpass, now() + 1.hours)
            redirect("/admin")

        if d3 == "on" and d2 != "on":
            redirect("/search/" & query & "/1/3D")

        elif d3 != "on" and d2 == "on":
            redirect("/search/" & query & "/1/2D")

        else:
            redirect("/search/" & query & "/1/both")


    get "/admin":
        echo now().utc, "   loading admin page"
        cond '.' notin "admin"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:

                var data = adminbackend()
                resp frontend("admin", "", data)

        redirect("/")

    post "/visitors":
        echo now().utc, "   reseting visitors number"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:
                resetvisitors("reset")
                redirect("/admin")
        
        redirect("/")

    post "/password":
        echo now().utc, "   changing admin password"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:

                var oldpassword = request.formData.getOrDefault("olpassword").body
                var newpassword = request.formData.getOrDefault("password").body
                var repassword = request.formData.getOrDefault("repassword").body
                var olpass = getpassword().password

                if $oldpassword.toMD5 == olpass and newpassword == repassword:
                    setCookie("position", "password", now() + 5.seconds)#, secure = true)
                    setCookie("type", "success", now() + 5.seconds)#, secure = true)
                    setCookie("message", "password changed successfully", now() + 5.seconds)#, secure = true)
                    setpassword($newpassword.toMD5)
                    setCookie("pass", $newpassword.toMD5, now() + 1.hours)
                    echo now().utc, "   password changed successfully"
                    redirect("/admin")

                elif $oldpassword.toMD5 != olpass:
                    setCookie("position", "password", now() + 5.seconds)#, secure = true)
                    setCookie("type", "error", now() + 5.seconds)#, secure = true)
                    setCookie("message", "oldpassword is not correct", now() + 5.seconds)#, secure = true)
                    echo now().utc, "   oldpassword incorrect"
                    redirect("/admin")

                elif newpassword != repassword:
                    setCookie("position", "password", now() + 5.seconds)#, secure = true)
                    setCookie("type", "error", now() + 5.seconds)#, secure = true)
                    setCookie("message", "newpassword and retype password are different", now() + 5.seconds)#, secure = true)
                    echo now().utc, "   newpassword and retype password are different"
                    redirect("/admin")

                else:
                    setCookie("position", "password", now() + 5.seconds)#, secure = true)
                    setCookie("type", "error", now() + 5.seconds)#, secure = true)
                    setCookie("message", "An error occured", now() + 5.seconds)#, secure = true)
                    echo now().utc, "   an error occured"
                    redirect("/admin")
        
        redirect("/")

    post "/social":
        echo now().utc, "   changing social media links"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:

                var youtube = request.formData.getOrDefault("youtube").body
                var twitter = request.formData.getOrDefault("twitter").body
                var mail = request.formData.getOrDefault("mail").body

                updatelinks(youtube, twitter, mail)
                redirect("/admin")

        redirect("/")

    post "/logo":
        echo now().utc, "   changing site name"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:
                var logo = request.formData.getOrDefault("logo").body
                updatelogo(logo)
                redirect("/admin")


        redirect("/")

    post "/policy":
        echo now().utc, "   changing policy"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:

                var policy = request.formData.getOrDefault("policy").body

                updatepolicy(policy)
                redirect("/admin")

        redirect("/")

    post "/notification":
        echo now().utc, "   changing notification"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:

                var notification = request.formData.getOrDefault("notification").body
                var notify = request.formData.getOrDefault("notifycond").body
                
                updatenotification(notification, notify)
                redirect("/admin")

        redirect("/")

    post "/ads":
        echo now().utc, "   updating ads"
        if request.cookies.hasKey("pass"):
            var password = getpassword()
            var cpassword = request.cookies["pass"]

            if password.password == cpassword:
                
                try: 
                    var count = request.formData.getOrDefault("count").body.parseInt
                    var ads : seq[string]
                    
                    if count < 0:
                        count = 0
                    
                    for i in 0..<count:
                        var ad = request.formData.getOrDefault("ad" & $i).body
                        if ad != "":
                            ads.add(ad)

                    updatead(ads)
                
                except:
                    discard
                
                redirect("/admin")

        redirect("/")

    get "/policy":
        echo now().utc, "   loading policy page"
        cond '.' notin "policy"
        var policy = getpolicy()
        resetvisitors("policy")
        resp frontend("policy", "", policy)

    get "/search/@query/@num/@dimension":
        echo now().utc, "   loading search page"
        var fluke : DATA = getsearch()
        fluke.keyword = @"query"
        resetvisitors("main")
        var url = geturljson()

        if @"dimension" == "3D":
            fluke.d3 = url.d3

        elif @"dimension" == "2D":
            fluke.d2 = url.d2

        else:
            fluke.d3 = url.d3
            fluke.d2 = url.d2


        resp frontend("main", "../../../", fluke)

    get "/search/@query/@num/@dimension/@name":
        echo now().utc, "   serving data to js via api"
        try:
            let data = waitFor getinfo(@"name", @"query", @"num", geturl())
            resp data
        except:
            let data = ""
            resp data

    error {Http404..Http503}:
        var fluke : DATA
        echo now().utc, "   some idiot caused an error"
        resp frontend("error", "", fluke)

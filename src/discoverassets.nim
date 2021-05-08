# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import jester, asyncdispatch
import discoverassetspkg/[datafuncs]
from httpclient import newHttpClient, getContent
include "discoverassetspkg/views.tmpl"

#[proc getinfo(name, query, num : string, url : tuple[d3 : URL, d2 : URL]) : Future[string] {.async.} =
    try:
        var client = newHttpClient()
        var allurl = url.d3.info.concat(url.d2.info)

        var link = allurl.filterIt(it.name == name)
    
        result = client.getContent(link[0].url.format([query, num]))
        echo now().utc, "   got data from third party"
    except:
        result = ""]#


routes:
    get "/":
        var data : Site
        resp frontend("home", "", data)

    get "/settings":
        cond '.' notin "settings"

        var data : Site
        resp frontend("settings", "", data)

    get "/search/@query":
        cond '.' notin @"query"

        var fluke : Site
        resp frontend("main", "../", fluke)

    get "/search/@query/@num":
        #[try:
            let data = waitFor getinfo(@"name", @"query", @"num", geturl())
            resp data
        except:
            let data = ""
            resp data]#
        redirect("/search/@query")

    error {Http404..Http503}:
        var fluke : Site
        resp frontend("error", "", fluke)

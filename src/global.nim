import karax / [karaxdsl, vdom, kdom], asyncjs
from karax / kajax import ajaxPost, ajaxGet, newFormData, append
from jsffi import to
from json import parseJson, JsonNode
from strutils import split


proc readCookies*(keyword : string) : string =
    let cookies = $document.cookie

    for cookie in cookies.split(";"):
        let splitcookie = cookie.split("=")

        if splitcookie[0] == keyword:
            return splitcookie[1]

proc toCstr*[T](str : T) : cstring =
    let str : cstring = $str
    return str

proc callApi*(url : string, useget : bool = false) : Future[JsonNode] =
    let 
        url : cstring = url

    var 
        headers : seq[(cstring, cstring)]
        data : cstring
        promise : Future[JsonNode]

    if useget:
        promise = newPromise() do (resolve : proc(response : JsonNode)):
            ajaxGet(url, headers, proc (status : int, resp : cstring) =
                    if status == 200:
                        echo resp, url
                        let jsonresp = parseJson($resp)
                        resolve(jsonresp)
            )

    else:
        promise = newPromise() do (resolve : proc(response : JsonNode)):
            ajaxPost(url, headers, data, proc (status : int, resp : cstring) =
                    if status == 200:
                        let jsonresp = parseJson($resp)
                        resolve(jsonresp)
            )

    return promise

proc callApi*(url : string, form : seq[tuple[keys, values : string]]) : Future[string] =

    var
        url : cstring = url
        info = newFormData()

    for each in form:
        info.append(each.keys.toCstr, each.values.toCstr)
    
    var 
        data : cstring = info.to(cstring)
        headers : seq[(cstring, cstring)]
        promise = newPromise() do (resolve : proc(response : string)):
            ajaxPost(url, headers, data, proc (status : int, resp : cstring) =
                    if status == 200:
                        #let jsonresp = parseJson($resp)
                        #resolve(jsonresp)
                        resolve($resp)
            )

    return promise


proc clearDecendants*(id : string) =
    let element = getElementById(id)
    let children = element.children

    for child in children:
        element.removeChild(child)


proc background*() : VNode =
    result = buildHtml(span(id = "background")):
        for num in 1..3:
            tdiv(class = "backgroundrow"):
                tdiv(class = "colouredcircle", id = "colouredcircle" & $num)


proc navBar*() : VNode =
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
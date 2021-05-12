import karax / [karax, karaxdsl, vdom, kdom], asyncjs, global, datafuncs
from json import `$`, to


proc addSite() : VNode =
    proc duos(name : string) : VNode {.closure.} =
        result = buildHtml(tdiv(class = "duo")):
            input(Type = "text", placeholder = name & " class", name = name & "class")
            input(Type = "text", placeholder = name & " tag", name = name & "tag")

    result = buildHtml(form(action = "/addsite", Method = "POST", class = "addsite", enctype = "multipart/form-data")):
        input(Type = "text", placeholder = "Website's name", name = "website")
        input(Type = "text", placeholder = "Website's icon link", name = "icon")
        input(Type = "text", placeholder = "Website's link", name = "link")
        input(Type = "text", placeholder = "Keyword", name = "keyword")
        input(Type = "text", placeholder = "Page Number", name = "page")
        duos("Asset")
        duos("Name")
        duos("Img")
        duos("AssetLink")
        tdiv(id = "submitcon"):
            input(Type = "submit", value = "+")

proc updateSite(api : Api) : VNode =

    proc duos(name, classvalue, tagvalue : string) : VNode {.closure.} =
        result = buildHtml(tdiv(class = "duo")):
            input(Type = "text", placeholder = name & " class", name = name & "class", value = classvalue)
            input(Type = "text", placeholder = name & " tag", name = name & "tag", value = tagvalue)

    result = buildHtml(form(action = "/updatesite", Method = "POST", class = "addsite", enctype = "multipart/form-data")):
        input(Type = "text", placeholder = "Website's name", name = "website", value = api.website)
        input(Type = "text", placeholder = "Website's icon link", name = "icon", value = api.icon)
        input(Type = "text", placeholder = "Website's link", name = "link", value = api.link)
        input(Type = "text", placeholder = "Keyword", name = "keyword")
        input(Type = "text", placeholder = "Page Number", name = "page")
        duos("Asset", api.asset_class, api.asset_tag)
        duos("Name", api.name_class, api.name_tag)
        duos("Img", api.img_class, api.img_tag)
        duos("AssetLink", api.assetlink_class, api.assetlink_tag)
        tdiv(id = "submitcon"):
            input(Type = "submit", value = "+")

proc menuPanel() : VNode =
    proc addsite(ev : Event, n : VNode) {.closure.} =
        clearDecendants("settingsobject")
        let canvas = getElementById("settingsobject")
        let child = addSite().vnodeToDom()
        canvas.appendChild(child)

    proc updatesites(ev : Event, n : VNode) {.closure.} =
        proc addsiteinfo() {.closure, async.} =
            let 
                resp = await callApi($window.location.href & "/../sites")
                site = resp.to(Site)
                canvas = getElementById("settingsobject")
                
            for api in site.apis:
                let 
                    child = updateSite(api).vnodeToDom()

                canvas.appendChild(child)

        clearDecendants("settingsobject")
        discard addsiteinfo()


    result = buildHtml(span(id = "settingscontainer")):
        span(class = "innercontainer", id = "settingsbtns"):
            tdiv(class = "btns", onclick = addsite):
                text "Add new site"

            tdiv(class = "btns", onclick = updatesites):
                text "Update sites info"

        span(class = "innercontainer", id = "settingsobject"):
            addSite()


proc home() : VNode =
    result = buildHtml(main(id = "canvas")):
        background()

        span(id = "content"):
            menuPanel()
                
            navBar()

            bottomBar()
                

when isMainModule:
    setRenderer home
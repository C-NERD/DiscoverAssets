import karax / [karax, karaxdsl, vdom, kdom], asyncjs, global, datafuncs
from json import to

proc siteForm(api : Api = Api()) : VNode =
    proc duos(name, classvalue : string = "", tagvalue : string = "") : VNode {.closure.} =
        result = buildHtml(tdiv(class = "duo")):
            input(Type = "text", placeholder = name & " class", name = name & "class", value = classvalue)
            input(Type = "text", placeholder = name & " tag", name = name & "tag", value = tagvalue)
    
    result = buildHtml(span()):
        input(Type = "text", placeholder = "Website's name", name = "website", value = api.website)
        #input(Type = "text", placeholder = "Website's icon link", name = "icon", value = api.icon)
        input(Type = "text", placeholder = "Website's link", name = "link", value = api.link)
        #input(Type = "text", placeholder = "Keyword", name = "keyword", value = api.keyword_tag)
        #input(Type = "text", placeholder = "Page Number", name = "page", value = api.page_tag)
        select(name = "dimension", value = api.dimension, placeholder = "dimensions"):
            option(value = "3D"):
                text "3D"

            option(value = "2D"):
                text "2D"

        select(name = "search", placeholder = "manual search"):
            option(value = "false"):
                text "Disable Manual Search"

            option(value = "true"):
                text "Enable Manual Search"

        duos("Asset", api.asset_class, api.asset_tag)
        duos("Name", api.name_class, api.name_tag)
        duos("Img", api.img_class, api.img_tag)
        duos("AssetLink", api.assetlink_class, api.assetlink_tag)

proc addSite() : VNode =

    result = buildHtml(form(action = "/addsite", Method = "POST", class = "addsite", enctype = "multipart/form-data")):
        siteForm()
        tdiv(class = "submitcon"):
            input(Type = "submit", value = "+")

proc updateSite(api : Api) : VNode =

    result = buildHtml(form(action = "/updatesite", Method = "POST", class = "addsite", enctype = "multipart/form-data")):
        siteForm(api)

        tdiv(class = "submitcon"):
            input(Type = "submit", value = "update")
            input(Type = "submit", value = "x", formaction = "/deletesite", formenctype = "multipart/form-data", formmethod = "POST")


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
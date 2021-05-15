import jester, asyncdispatch, datafuncs, database
from db_sqlite import open, close
from json import `%`, `$`
from httpclient import newAsyncHttpClient, getContent, newMultipartData, `[]=`
include "views.tmpl"

proc getinfo(data : Proxy) : Future[string] {.async.} =
    try:
        #[var
            multipart = newMultipartData()

        multipart[data.keyword_tag] = data.keyword
        multipart[data.page_tag] = data.page]#

        let
            client = newAsyncHttpClient()
        
        result = await client.getContent(data.url)

    except:
        discard


routes:
    get "/":
        var data : Site
        resp frontend("home", "", data)

    post "/":
        let query = request.formData.getOrDefault("tag").body
        redirect("/search/" & query)

    get "/settings":
        cond '.' notin "settings"

        var data : Site
        resp frontend("settings", "", data)

    get "/search/@query":
        cond '.' notin @"query"

        var fluke : Site
        resp frontend("main", "../", fluke)

    post "/search/@query":
        let
            keyword_tag = request.formData.getOrDefault("keyword_tag").body
            keyword = request.formData.getOrDefault("keyword").body
            page_tag = request.formData.getOrDefault("page_tag").body
            page = request.formData.getOrDefault("page").body
            url = request.formData.getOrDefault("url").body

            data : Proxy = Proxy(
                keyword_tag : keyword_tag,
                keyword : keyword,
                page_tag : page_tag,
                page : page,
                url : url
            )

        resp waitFor getinfo(data)

    post "/sites":
        let db  = open("database.db", "", "", "")
        let jsonresp = $(% db.getSearch())
        db.close()

        resp jsonresp

    post "/addsite":
        let 
            db  = open("database.db", "", "", "")

            website = request.formData.getOrDefault("website").body
            icon = request.formData.getOrDefault("icon").body
            link = request.formData.getOrDefault("link").body
            keyword = request.formData.getOrDefault("keyword").body
            page = request.formData.getOrDefault("page").body
            asset_class = request.formData.getOrDefault("Assetclass").body
            asset_tag = request.formData.getOrDefault("Assettag").body
            name_class = request.formData.getOrDefault("Nameclass").body
            name_tag = request.formData.getOrDefault("Nametag").body
            img_class = request.formData.getOrDefault("Imgclass").body
            img_tag = request.formData.getOrDefault("Imgtag").body
            assetlink_class = request.formData.getOrDefault("AssetLinkclass").body
            assetlink_tag = request.formData.getOrDefault("AssetLinktag").body

            api : Api = Api(website : website, icon : icon, link : link,
            keyword_tag : keyword, page_tag : page, asset_class : asset_class,
            asset_tag : asset_tag, name_class : name_class, name_tag : name_tag,
            img_class : img_class, img_tag : img_tag, assetlink_class : assetlink_class,
            assetlink_tag : assetlink_tag)
        
        db.addApi(api)
        db.close()
        redirect("/settings")

        #[var status : bool

        try:
            db.addApi(api)
            status = true
            resp $(% status)

        except:
            status = false
            resp $(% status)]#

    post "/updatesite":
        let 
            db  = open("database.db", "", "", "")

            website = request.formData.getOrDefault("website").body
            icon = request.formData.getOrDefault("icon").body
            link = request.formData.getOrDefault("link").body
            keyword = request.formData.getOrDefault("keyword").body
            page = request.formData.getOrDefault("page").body
            asset_class = request.formData.getOrDefault("Assetclass").body
            asset_tag = request.formData.getOrDefault("Assettag").body
            name_class = request.formData.getOrDefault("Nameclass").body
            name_tag = request.formData.getOrDefault("Nametag").body
            img_class = request.formData.getOrDefault("Imgclass").body
            img_tag = request.formData.getOrDefault("Imgtag").body
            assetlink_class = request.formData.getOrDefault("AssetLinkclass").body
            assetlink_tag = request.formData.getOrDefault("AssetLinktag").body

            api : Api = Api(website : website, icon : icon, link : link,
            keyword_tag : keyword, page_tag : page, asset_class : asset_class,
            asset_tag : asset_tag, name_class : name_class, name_tag : name_tag,
            img_class : img_class, img_tag : img_tag, assetlink_class : assetlink_class,
            assetlink_tag : assetlink_tag)
        
        db.updateApi(api)
        db.close()
        redirect("/settings")

    post "/deletesite":
        let 
            db  = open("database.db", "", "", "")
            website = request.formData.getOrDefault("website").body

        db.deleteApi(website)
        db.close()
        redirect("/settings")

    error {Http404..Http503}:
        var fluke : Site
        resp frontend("error", "", fluke)

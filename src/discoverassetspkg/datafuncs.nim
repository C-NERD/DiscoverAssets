import db_sqlite

type
    Data* = object   
        img* : string
        name* : string
        website* : string
        link* : string
        dimension* : string

    Api* = object
        link* : string
        dimension* : string
        website* : string
        icon* : string
        icon_tag* : string
        asset_class* : string
        asset_tag* : string
        name_class* : string
        name_tag* : string
        img_class* : string
        img_tag* : string
        assetlink_class* : string
        assetlink_tag* : string

    Site* = object
        logo* : string
        apis* : seq[Api]


proc updateLogo*(db : DbConn, logo : string) =
    db.exec(sql"UPDATE site SET logo = ? WHERE id = ?;", logo, $1)


proc addApi*(db : DbConn, api : Api) =
    discard db.insertID(sql"""INSERT INTO api 
    (siteid, link, dimension, website, icon, icon_tag, asset_class, asset_tag,
    name_class, name_tag, img_class, img_tag, assetlink_class, assetlink_tag)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);""", $1, api.link, api.dimension, 
    api.website, api.icon, api.icon_tag, api.asset_class, api.asset_tag, api.name_class, 
    api.name_tag, api.img_class, api.img_tag, api.assetlink_class, api.assetlink_tag)


proc getSearch*(db : DbConn) : Site =
    result.logo = db.getValue(sql"SELECT logo FROM site WHERE id = ?;", $1)

    for api in db.fastRows(sql"SELECT * FROM api WHERE siteid = 1;"):
        var info : Api

        info.link = api[2]
        info.dimension = api[3]
        info.website = api[4]
        info.icon = api[5]
        info.icon_tag = api[6]
        info.asset_class = api[7]
        info.asset_tag = api[8]
        info.name_class = api[9]
        info.name_tag = api[10]
        info.img_class = api[11]
        info.img_tag = api[12]
        info.assetlink_class = api[13]
        info.assetlink_tag = api[14]

        result.apis.add(info)
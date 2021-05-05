import db_sqlite

var db = open("database.db", "", "", "")

type
    Data* = object   
        img* : string
        name* : string
        website* : string
        link* : string
        dimension* : string

    Api* = object
        link* : string
        icon* : string
        dimension* : string
        website* : string
        asset_class* : string
        name_class* : string
        img_class* : string
        assetlink_class* : string

    Site* = object
        logo* : string
        apis* : seq[Api]


proc updateLogo*(logo : string) =
    db.exec(sql"UPDATE site SET logo = ? WHERE id = ?;", logo, $1)


proc addApi*(api : Api) =
    discard db.insertID(sql"""INSERT INTO api 
    (siteid, link, dimension, website, asset_class, name_class, img_class, assetlink_class)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?);""", $1, api.link, api.dimension, api.website,
    api.asset_class, api.name_class, api.img_class, api.assetlink_class)


proc getSearch*() : Site =
    result.logo = db.getValue(sql"SELECT logo FROM site WHERE id = ?;", $1)

    for api in db.fastRows(sql"SELECT * FROM api WHERE siteid = 1;"):
        var info : Api

        info.link = api[2]
        info.icon = api[3]
        info.dimension = api[4]
        info.website = api[5]
        info.asset_class = api[6]
        info.name_class = api[7]
        info.img_class = api[8]
        info.assetlink_class = api[9]

        result.apis.add(info)
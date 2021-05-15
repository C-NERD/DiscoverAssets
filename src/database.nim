import db_sqlite, datafuncs

var db  = open("database.db", "", "", "")

proc addApi*(api : Api) =
    discard db.insertID(sql"""
    INSERT INTO api (siteid, link, keyword_tag, page_tag, dimension, website, icon, 
    asset_class, asset_tag, name_class, name_tag, img_class, img_tag, assetlink_class, 
    assetlink_tag) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
    """, $1, api.link, api.keyword_tag, api.page_tag, api.dimension, api.website, api.icon, 
    api.asset_class, api.asset_tag, api.name_class, api.name_tag, api.img_class, api.img_tag, 
    api.assetlink_class, api.assetlink_tag)

proc updateApi*(api : Api) =
    db.exec(sql"""
    UPDATE api SET siteid = ?, link = ?, keyword_tag = ?, page_tag = ?, dimension = ?, 
    website = ?, icon = ?, asset_class = ?, asset_tag = ?, name_class = ?, name_tag = ?, 
    img_class = ?, img_tag = ?, assetlink_class = ?, assetlink_tag = ? WHERE website = ?;
    """, $1, api.link, api.keyword_tag, api.page_tag, api.dimension, api.website, api.icon, 
    api.asset_class, api.asset_tag, api.name_class, api.name_tag, api.img_class, api.img_tag, 
    api.assetlink_class, api.assetlink_tag, api.website)

proc deleteApi*(website : string) =
    db.exec(sql"DELETE FROM api WHERE website = ?", website)

proc getSearch*() : Site =

    for api in db.fastRows(sql"SELECT * FROM api WHERE siteid = 1;"):
        var info : Api

        info.link = api[1]
        info.keyword_tag = api[2]
        info.page_tag = api[3]
        info.dimension = api[4]
        info.website = api[5]
        info.icon = api[6]
        info.asset_class = api[7]
        info.asset_tag = api[8]
        info.name_class = api[9]
        info.name_tag = api[10]
        info.img_class = api[11]
        info.img_tag = api[12]
        info.assetlink_class = api[13]
        info.assetlink_tag = api[14]

        result.apis.add(info)

proc newdatabase() =
    db.exec(sql"DROP TABLE IF EXISTS site")
    db.exec(sql"DROP TABLE IF EXISTS api")

    db.exec(sql"""
    CREATE TABLE IF NOT EXISTS site(
        id int NOT NULL,
        PRIMARY KEY (id)
    );
    """)

    db.exec(sql"""
    CREATE TABLE IF NOT EXISTS api(
        siteid int NOT NULL REFERENCES site,
        link text,
        keyword_tag text,
        page_tag text,
        dimension text,
        website text,
        icon text,
        asset_class text,
        asset_tag text,
        name_class text,
        name_tag text,
        img_class text,
        img_tag text,
        assetlink_class text,
        assetlink_tag text
    );
    """)

    discard db.insertID(sql"INSERT INTO site (id) VALUES (?)", $1)


proc populate() =
    const sites : seq[Api]  =
        @[
            Api(
                link : "https://3dexport.com/free-search/keywords($1)?page=$2",
                dimension : "3D",
                website : "3dexport.com"
            ),
            Api(
                link : "https://clara.io/library?gameCheck=true&public=true&query=$1&page=$2&perPage=$3",
                dimension : "3D",
                website : "clara.io"
            ),
            Api(
                link : "https://www.blendswap.com/search?page=$2&keyword=$1",
                dimension : "3D",
                website : "blendswap.com"
            ),
            Api(
                link : "https://3dmodelhaven.com/models/?c=&s=$1",
                dimension : "3D",
                website : "3dmodelhaven"
            ),
            Api(
                link : "https://opengameart.org/art-search?keys=$1&page=$2",
                dimension : "2D",
                website : "opengameart.org"
            ),
            Api(
                link : "https://www.gameart2d.com/freebies.html",
                dimension : "2D",
                website : "gameart2d.com"
            ),
            Api(
                link : "https://craftpix.net/page/$2/?s=$1",
                dimension : "2D",
                website : "craftpix.net"
            )
        ]

    for site in sites:
        addApi(site)

when isMainModule:
    newdatabase()
    populate()
    db.close()
import db_sqlite
from datafuncs import addApi, Api

var db  = open("database.db", "", "", "")

proc newdatabase() =
    db.exec(sql"DROP TABLE IF EXISTS site")
    db.exec(sql"DROP TABLE IF EXISTS api")

    db.exec(sql"""
    CREATE TABLE IF NOT EXISTS site(
        id int NOT NULL,
        logo blob,
        PRIMARY KEY (id)
    );
    """)

    db.exec(sql"""
    CREATE TABLE IF NOT EXISTS api(
        siteid int NOT NULL REFERENCES site,
        link text,
        dimension text,
        website text,
        icon text,
        icon_tag text,
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
        db.addApi(site)

newdatabase()
populate()
db.close()
import db_sqlite

var db  = open("database.db", "", "", "")

proc newdatabase() =
    db.exec(sql"DROP TABLE IF EXISTS site")
    db.exec(sql"DROP TABLE IF EXISTS api")

    db.exec(sql"""
    CREATE TABLE IF NOT EXISTS site(
        id int NOT NULL,
        logo blob
    );
    """)

    db.exec(sql"""
    CREATE TABLE IF NOT EXISTS api(
        apiid int NOT NULL,
        siteid int NOT NULL REFERENCES site,
        link text,
        link_tag text,
        icon text,
        icon_tag text,
        dimension text,
        website text,
        asset_class text,
        asset_tag text,
        name_class text,
        name_tag text,
        img_class text,
        img_tag text,
        assetlink_class text,
        assetlink_tag text,
        PRIMARY KEY (apiid)
    );
    """)

    discard db.insertID(sql"INSERT INTO site (id) VALUES (?)", $1)

newdatabase()
db.close()
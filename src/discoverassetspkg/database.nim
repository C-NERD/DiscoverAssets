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
        icon text,
        dimension text,
        website text,
        asset_class text,
        name_class text,
        img_class text,
        assetlink_class text,
        PRIMARY KEY (apiid)
    );
    """)

    discard db.insertID(sql"INSERT INTO site (id) VALUES (?)", $1)

newdatabase()
db.close()
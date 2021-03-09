import db_sqlite
from md5 import toMD5, `$`

var db  = open("database.db", "", "", "")

proc newdatabase() =
    db.exec(sql"DROP TABLE IF EXISTS site")

    db.exec(sql"""
    CREATE TABLE IF NOT EXISTS site(
        id int NOT NULL,
        logo text,
        searchpage int,
        mainpage int,
        policypage int,
        password text NOT NULL,
        youtube text,
        twitter text,
        mail text,
        policy text,
        notification text,
        notify bool,
        ads text,
        d3 text,
        d2 text,
        PRIMARY KEY (id)
    );
    """)

var d3 = """
{"info" :
    [
        {"name" : "3dexport.com", "url" : "https://3dexport.com/free-search/keywords($1)?page=$2"},
        {"name" : "clara.io", "url" : "https://clara.io/library?gameCheck=true&public=true&query=$1&page=$2&perPage=50"},
        {"name" : "blendswap.com", "url" : "https://www.blendswap.com/search?page=$2&keyword=$1"},
        {"name" : "3dmodelhaven", "url" : "https://3dmodelhaven.com/models/?c=&s=$1"}
    ]
}
"""

var d2 = """
{"info" :
    [
        {"name" : "opengameart.org", "url" : "https://opengameart.org/art-search?keys=$1&page=$2"},
        {"name" : "gameart2d.com", "url" : "https://www.gameart2d.com/freebies.html"},
        {"name" : "craftpix.net", "url" : "https://craftpix.net/page/$2/?s=$1"}
    ]
}
"""
var 
    youtube = "https://www.youtube.com/channel/UCDAN3oIUauqL5e7-6gf09MQ"
    twitter = "https://twitter.com/CNERD7"
    mail = "mailto:alayaa694@gmail.com"
    policy = """
## Privacy Policy

This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.

## Definitions
For the purposes of this Privacy Policy:


- You means the individual accessing or using the Service.

- We, Us, Our, Website or Service in this Agreement refers to discoverAssets.com.

- Personal Data is any information that relates to an identified or identifiable individual.

- Cookies are small files that are placed on Your computer, mobile device or any other device by a website, containing the details of Your browsing history on that website among its many uses.

- Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.

## Cookies and Data Collection

*This site does not collect any data whatsoever from any device that access its service, but this site communicates with 3rd party sites whom may wish to collect personal data independent of discoverAssets.com.*

## Links to Other Websites

Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party&ampampaposs site. We strongly advise You to review the Privacy Policy of every site You visit.

We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.

## Changes to this Privacy Policy

*We may update our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.*

You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

## Third party websites

The third party websites connected to discoverAssets.com are:

- ![3dExport](https://d36fr9tcqf0n5n.cloudfront.net/images/logo-3de.png)
**3dExport.com**




- ![clara](https://clara.io/img/ClaraLogo.png)
**clara.io**





- ![blendswap](https://www.blendswap.com/static/img/logo.svg)
**blendswap.com**




- ![opengameart](https://opengameart.org/sites/default/files/archive/sara-logo.png)
**opengameart.org**





- ![gameart2d](https://www.gameart2d.com/uploads/3/0/9/1/30917885/1413209609.png)
**gameart2d.com**





- ![craftpix](https://craftpix.net/wp-content/themes/craftpix/assets/images/logo.svg)
**craftpix.net**





More third party websites will be added in the future
"""

proc textdata() =
    db.exec(sql"INSERT INTO site VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
    $1, "discoverAssets", $0, $0, $0, $"Default".toMD5, youtube, twitter, mail, policy, "Notification", $false, "", d3, d2)

newdatabase()
textdata()
db.close
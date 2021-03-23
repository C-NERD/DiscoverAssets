import db_sqlite
from strutils import parseInt, parseBool, multiReplace, escape, removePrefix, removeSuffix, unescape
from json import `%`, `$`, parseJson, getElems, getStr, to
from md5 import toMD5, `$`
from sequtils import applyIt

var db = open("database.db", "", "", "")

type
    DATA* = object
        id* : int
        logo* : string
        searchpage* : int
        mainpage* : int
        policypage* : int
        password* : string
        youtube* : string
        twitter* : string
        mail* : string
        policy* : string
        notification* : string
        notify* : bool
        ads* : string
        displayads* : seq[string]
        d3* : string
        d2* : string
        keyword* : string


    URL* = object
        info* : seq[tuple[name : string, url : string]]

proc escapehtml(data : string, quote : bool = true) : string = 
    
    case quote
    of true:
        result = data.multiReplace([("<", "&lt"), (">", "&gt"), 
        ("\"", "&quot"), ("&", "&amp"), ("'", "&apos")])

    else:
        result = data.multiReplace([("<", "&lt"), (">", "&gt"), ("&", "&amp")])

proc prettystr(info : string) : string =
    var info = info
    info.removePrefix("\"")
    info.removeSuffix("\"")

    result = info

proc escapead(data : string, quote : bool = true) : string = 
    
    case quote
    of true:
        result = data.multiReplace([("&lt", "<"), ("&gt", ">"), 
        ("&quot", "\""), ("&amp", "&"), ("&apos", "'")])

    else:
        result = data.multiReplace([("&lt", "<"), ("&gt", ">"), ("&amp", "&")])

proc parseads(data : string) : seq[string] =
    if data != "":
        var ads = parseJson(data)
        try:
            for item in (ads.getElems):
                var a1 = (item.getStr.unescape.escapead).prettystr
                result.add(a1)

        except:
            discard

proc adminbackend*() : DATA =
    var info = db.getRow(sql"SELECT * FROM site WHERE id = ?;", $1)
    
    try:
        result.logo = info[1]
        result.searchpage = info[2].parseInt
        result.mainpage = info[3].parseInt
        result.policypage = info[4].parseInt
        result.youtube = info[6]
        result.twitter = info[7]
        result.mail = info[8]
        result.policy = info[9]
        result.notification = info[10]
        result.notify = info[11].parseBool
        result.ads = info[12]
    except:
        discard


proc getpassword*() : DATA = 
    let password = db.getValue(sql"SELECT password FROM site WHERE id = ?;", $1)

    result.password = password

proc setpassword*(password : string) =
    var password = escapehtml(password)
    db.exec(sql"UPDATE site SET password = ? WHERE id = ?;", password, $1)

proc updatelinks*(youtube, twitter, mail : string) =
    var youtube = escapehtml(youtube)
    var twitter = escapehtml(twitter)
    var mail = escapehtml(mail)
    db.exec(sql"UPDATE site SET youtube = ?, twitter = ?, mail = ? WHERE id = ?;",
    youtube, twitter, mail, $1)

proc updatepolicy*(policy : string) =
    var policy = escapehtml(policy)
    db.exec(sql"UPDATE site SET policy = ? WHERE id = ?;", policy, $1)

proc updatenotification*(notification, cond : string) =
    var notify : bool
    
    if cond == "on":
        notify = true
    elif cond == "":
        notify = false

    var notification = notification.escapehtml

    db.exec(sql"UPDATE site SET notification = ?, notify = ? WHERE id = ?;",
    notification, $notify, $1)

proc updatead*(ads : seq[string]) =
    var ads = ads
    ads.applyIt((it.escapehtml(false)).escape)
    var jads = %ads

    db.exec(sql"UPDATE site SET ads = ? WHERE id = ?;",
    $jads, $1)

proc updatelogo*(logo : string) =
    var logo = logo.escapehtml
    db.exec(sql"UPDATE site SET logo = ? WHERE id = ?;", logo, $1)

proc resetvisitors*(reset : string) =

    var info = db.getRow(sql"SELECT searchpage, mainpage, policypage FROM site WHERE id = ?;",
    $1)

    if reset == "reset":
        db.exec(sql"UPDATE site SET searchpage = ?, mainpage = ?, policypage = ? WHERE id = ?;",
        $0, $0, $0, $1)

    elif reset == "search":
        db.exec(sql"UPDATE site SET searchpage = ? WHERE id = ?;",
        $(info[0].parseInt + 1), $1)

    elif reset == "main":
        db.exec(sql"UPDATE site SET mainpage = ? WHERE id = ?;",
        $(info[1].parseInt + 1), $1)

    elif reset == "policy":
        db.exec(sql"UPDATE site SET policypage = ? WHERE id = ?;",
        $(info[2].parseInt + 1), $1)

proc getpolicy*() : DATA =
    var info = db.getRow(sql"SELECT policy, youtube, twitter, mail, ads, logo FROM site WHERE id = ?;", $1)
    result.policy = info[0]
    result.youtube = info[1]
    result.twitter = info[2]
    result.mail = info[3]
    result.ads = info[4]
    result.logo = info[5]
    result.displayads = parseads(info[4])

proc getsearch*() : DATA =
    var info = db.getRow(sql"SELECT youtube, twitter, mail, logo, ads, notification, notify FROM site WHERE id = ?;", $1)
    result.youtube = info[0]
    result.twitter = info[1]
    result.mail = info[2]
    result.logo = info[3]
    result.ads = info[4]
    result.displayads = parseads(info[4])
    result.notification = info[5]
    result.notify = info[6].parseBool

proc checkpass*(password : string) : tuple[condition : bool, escpass : string] =
    var password = escapehtml(password)
    try:
        var spassword = db.getValue(sql"SELECT password from site WHERE id = ?;", $1)

        if $password.toMD5 == spassword:
            result.condition = true
            result.escpass = $password.toMD5

        else:
            result.condition = false

    except:
        result.condition = false

proc geturl*() : tuple[d3 : URL, d2 : URL] =
    var d3 = db.getValue(sql"SELECT d3 FROM site WHERE id = ?;", $1)
    var d2 = db.getValue(sql"SELECT d2 FROM site WHERE id = ?;", $1)
    
    var dimension3 = parseJson(d3)
    var dimension2 = parseJson(d2)

    result.d3 = dimension3.to(URL)
    result.d2 = dimension2.to(URL)

proc geturljson*() : tuple[d3 : string, d2 : string] =
    var d3 = db.getValue(sql"SELECT d3 FROM site WHERE id = ?;", $1)
    var d2 = db.getValue(sql"SELECT d2 FROM site WHERE id = ?;", $1)
    
    result.d3 = d3
    result.d2 = d2
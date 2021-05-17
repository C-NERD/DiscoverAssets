# Package

version       = "0.2.0"
author        = "C-NERD"
description   = "Search Engine for free game and animation assets"
license       = "MIT"
srcDir        = "src"
bin           = @["discoverassets"]
binDir        = "bin"

backend       = "cc"

# Dependencies

requires "nim >= 1.0.0", "jester >= 0.4.0", "karax >= 1.2.1"

proc moveToBin() =
    mkDir("bin")
    cpDir("public", "bin/public")
    cpFile("database.db", "bin/database.db")

    if defined(Linux):
        mvFile "discoverassets", "bin/discoverassets"
    elif defined(Windows):
        mvFile "discoverassets.exe", "bin/discoverassets.exe"

proc moveExe() =
    # move executable to the project root directory
    # if you use macOs kindly add a condition to move the
    # executable to the project root dir and make a PR

    if defined(Linux):
        mvFile "src/discoverassets", "discoverassets"
    elif defined(Windows):
        mvFile "src/discoverassets.exe", "discoverassets.exe"

task database, "compiles and runs the code to create a new database":
    exec "nim c -r src/database.nim"
    rmFile "src/database"

task make, "compiles with thread":
    exec "nim c -d:ssl --threads:on src/discoverassets.nim"
    moveExe()
    
task makerelease, "compiles a release version of the code":
    exec "nim c -d:ssl -d:release -d:danger --gc:orc --threads:on src/discoverassets.nim"
    moveExe()
    
task settings, "compiles code for the settings page to js":
    exec "nim js src/settings.nim"
    mvFile "src/settings.js", "public/frontend/settings.js"
    
task home, "compiles code for the home page to js":
    exec "nim js src/home.nim"
    mvFile "src/home.js", "public/frontend/home.js"
    
task main, "compiles code for the main page to js":
    exec "nim js src/main.nim"
    mvFile "src/main.js", "public/frontend/main.js"
    
task standalone, "compiles a standalone deployable version of the code into a bin dir on the projects root dir":
    exec "nimble makerelease"
    exec "nimble database"
    exec "nimble settings"
    exec "nimble home"
    exec "nimble main"
    
    if dirExists("bin"):
        rmDir("bin")
        moveToBin()
    else:
        moveToBin()

    rmFile "database.db"

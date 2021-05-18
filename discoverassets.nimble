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


task make, "compiles with thread":
    exec "nim c -d:ssl --o: discoverassets --threads:on src/discoverassets.nim"

task database, "compiles the database code then creates a new database in the bin directory":
    exec "nim c -r src/database.nim"
    rmFile "src/database"
    
task settings, "compiles code for the settings page to js":
    exec "nim js --o: public/frontend/settings.js src/settings.nim"
    
task home, "compiles code for the home page to js":
    exec "nim js --o: public/frontend/home.js src/home.nim"
    
task main, "compiles code for the main page to js":
    exec "nim js --o: public/frontend/main.js src/main.nim"
    
task standalone, "compiles a standalone deployable version of the code into a bin dir on the projects root dir":

    if dirExists("bin"):
        rmDir("bin")
        
    mkDir("bin")
    cpDir "public/img", "bin/public/img"
    cpFile "public/style.css", "bin/public/style.css"

    exec "nim c -d:ssl -d:release -d:danger --o: bin/discoverassets --gc:orc --threads:on src/discoverassets.nim"
    exec "nim c -r --o: bin/database src/database.nim"
    mvFile "database.db", "bin/database.db"

    exec "nim js -d:release -d:danger --o: bin/public/frontend/settings.js src/settings.nim"
    exec "nim js -d:release -d:danger --o: bin/public/frontend/home.js src/home.nim"
    exec "nim js -d:release -d:danger --o: bin/public/frontend/main.js src/main.nim"
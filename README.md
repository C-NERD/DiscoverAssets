# discoverassets
A simple but powerful search engine for free 3D and 2D assets

# Compilation
To compile the code to this project make sure you have the [nim compiler](https://nim-lang.org/install.html) and it's
dependencies installed on your local machine.

- Then open a terminal in the root directory of the project
- Finally type `nimble standalone` in the terminal and then wait until compilation is over


Your webapp standalone should now be present in a bin directory along with it's dependencies. If you decide to use the program in a production enviroment you might want to setup a [reverse proxy](https://www.nginx.com/resources/glossary/reverse-proxy-server/) using [nginx](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/) or [apache](http://httpd.apache.org/docs/current/install.html)

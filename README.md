# minecraft-server-nucicraft
My Minecraft server optimised for Raspberry Pi 4

# Installation

## DynMap

It is recommended to run DynMap using an external web server

### lighttpd

Install the following packages: `lighttpd`, `fcgi`, `php-cgi`

Update `/etc/lighttpd/lighttpd.conf` to:

```
server.port		        = 25550
server.username		    = "http"
server.groupname	    = "http"
server.document-root	= "/srv/http"
server.errorlog		    = "/var/log/lighttpd/error.log"
dir-listing.activate	= "enable"
index-file.names	    = ( "index.html" )
mimetype.assign	    	= (
				".html" => "text/html",
				".txt" => "text/plain",
				".css" => "text/css",
				".js" => "application/x-javascript",
				".jpg" => "image/jpeg",
				".jpeg" => "image/jpeg",
				".gif" => "image/gif",
				".png" => "image/png",
				"" => "application/octet-stream"
			)
include "conf.d/fastcgi.conf"
```

Create the `/etc/lighttpd/conf.d/fastcgi.conf` file with:

```
server.modules += ("mod_fastcgi")
index-file.names += ("index.php")
fastcgi.server = (
    ".php" => (
        "localhost" => (
            "bin-path" => "/usr/bin/php-cgi",
            "socket" => "/tmp/php-fastcgi.sock",
            "broken-scriptfilename" => "enable",
            "max-procs" => "4",
            "bin-environment" => (
                "PHP_FCGI_CHILDREN" => "1"
            )
        )
    )
)
```

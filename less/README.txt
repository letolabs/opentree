Files in this directory are the *source* for client-side CSS in the opentree
app. I'm using a setup suggested by BootSwatch creator Thomas Park, as
described here:
    http://coding.smashingmagazine.com/2013/03/12/customizing-bootstrap/

Here's the layout of this folder:

less/
    README.txt      # this file
    bootstrap/      # .less files copied from Twitter Bootstrap, version 2.3.2
        less/
            bootstrap.less
            variables.less
        img/
        
        ...etc...
    custom-bootstrap.less   # our "main" .less file, orders and imports all others
    custom-variables.less   # overrides bootstrap/variables.less
    custom-other.less       # any other overrides that can't be done with variables


SETUP (AND BOOTSTRAP UPDATES)
`````````````````````````````

We begin by downloading the latest source version of Twitter Bootstrap from:

    https://github.com/twitter/bootstrap/zipball/master

The initial version is v2.3.2, with this zipfile:

    twitter-bootstrap-v2.3.2-0-gd9b502d.zip

This was unzipped, and its contents moved into place as follows:

    $ cd opentree/less
    $ unzip twitter-bootstrap-v2.3.2-0-gd9b502d.zip

This creates a subdir less/twitter-bootstrap-d9b502d, or similar. Move its
source files into our less/bootstrap/ directory, creating directories or
overwriting old stuff as needed:

    $ mkdir -pv bootstrap
    $ mv twitter-bootstrap-d9b502d/less bootstrap
    $ mv twitter-bootstrap-d9b502d/img bootstrap
    $ mv twitter-bootstrap-d9b502d/js bootstrap

Move pre-digested files (incl. initial CSS) to the final static directories: 

    $ cp twitter-bootstrap-d9b502d/docs/assets/css/bootstrap*.css ../webapp/static/css
    $ cp twitter-bootstrap-d9b502d/docs/assets/js/bootstrap*.js ../webapp/static/js
    $ cp twitter-bootstrap-d9b502d/docs/assets/js/html5shiv.js ../webapp/static/js
    $ mkdir -pv ../webapp/static/img
    $ cp twitter-bootstrap-d9b502d/docs/assets/img/glyphicons-*.png ../webapp/static/img

NOTE that this also applies to any supplemental web2py apps like 'curator'.
Just repeat the above commands, replacing '../webapp' with the path to your
app. This can be handled with a Bash script that lists all app directories,
like so:

    #!/bin/bash
    for app_path in {webapp, curator}
    do
        cp twitter-bootstrap-d9b502d/docs/assets/css/bootstrap*.css ../${app_path}/static/css
        cp twitter-bootstrap-d9b502d/docs/assets/js/bootstrap*.js ../${app_path}/static/js
        cp twitter-bootstrap-d9b502d/docs/assets/js/html5shiv.js ../${app_path}/static/js
        mkdir -pv ../${app_path}/static/img
        cp twitter-bootstrap-d9b502d/docs/assets/img/glyphicons-*.png ../${app_path}/static/img
    done

Now we can delete what's left of the zip output (we don't need it):

    $ rm -rf twitter-bootstrap-d9b502d 


    
(RE)BUILDING CUSTOM CSS
```````````````````````
This requires a Less compiler (command-line via npm, or any of various desktop
apps). Here we assume lessc, the command-line compiler that installs as part of
node.js, or installed via npm.

(Once again: To apply the same look and feel to other web2py apps, repeat the commands below 
specifying their paths in place of '../webapp'.)

Make all customizations in custom-*.less, then build the new stuff and test locally:
    
    $ cd opentree/less
    $ lessc custom-bootstrap.less > ../webapp/static/css/bootstrap.css 
    $ lessc custom-responsive.less > ../webapp/static/css/bootstrap-responsive.css 

Or, to generate compressed/minified CSS:

    $ cd opentree/less
    $ lessc --compress custom-bootstrap.less > ../webapp/static/css/bootstrap.min.css 
    $ lessc --compress custom-responsive.less > ../webapp/static/css/bootstrap-responsive.min.css 

--

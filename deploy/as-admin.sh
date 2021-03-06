# Run this script as an admin user (having 'sudo' privileges)
#  = 'admin' on debian, 'ubuntu' on ubuntu

set -e

# Current directory = home dir for admin user

if [ ! -r .updated ]; then
    sudo apt-get --assume-yes update
    touch .updated
fi

if [ ! -x `which dialog` ]; then
    # I was hoping this would help with apache2's configure step, but it doesn't
    sudo apt-get --assume-yes install dialog
fi

# ---------- RSYNC ----------
if [ `which rsync`x = x ]; then
    sudo apt-get --assume-yes install rsync
fi

# ---------- GCC (for some python packages) ----------
if [ `which gcc`x = x ]; then
    sudo apt-get --assume-yes install gcc
fi

# ---------- PYTHON-DEV (for some python packages) ----------
if [ ! -r /usr/include/*/Python.h ]; then
    sudo apt-get --assume-yes install python-dev
fi

# ---------- APACHE ----------
if [ ! -r /etc/init.d/apache2 ]; then
    echo Installing apache httpd
    # Prompts "do you want to continue?"
    sudo apt-get --assume-yes install apache2
    echo Done
fi

# Enable the apache proxy module
if [ ! -r /etc/apache2/mods-enabled/proxy.load ]; then
    sudo a2enmod proxy
fi
if [ ! -r /etc/apache2/mods-enabled/proxy_http.load ]; then
    sudo a2enmod proxy_http
fi

# ---------- UNZIP ----------
# unzip is needed for unpacking web2py.  Somebody broke the 'which' program -
# you can't just check the status code any more.
if [ `which unzip`x = x ]; then
    sudo apt-get --assume-yes install unzip
fi

# ---------- PIP ----------
# Get pip
if [ `which pip`x = x ]; then
    sudo apt-get --assume-yes install python-pip
fi

# ---------- LIBCURL + PYCURL ---------- # only needed on debian, may cause problems on ubunutu
# used by oti indexing script
#if [ `which pip`x = x ]; then
#    sudo apt-cache search libcurl-dev
    sudo apt-get --assume-yes install libcurl4-openssl-dev
    echo "installing pycurl"
    sudo pip install pycurl
#fi

exit

# ---------- GIT ----------
# Get git (so we can clone the opentree repo)
if [ `which git`x = x ]; then
    sudo apt-get --assume-yes install git
fi

# ---------- WSGI ----------
# Get wsgi (apache / web2py communication)
if [ ! -r /etc/apache2/mods-enabled/wsgi.load ]; then
    sudo apt-get --assume-yes install libapache2-mod-wsgi
fi

# AWS has python 2.7.3 built in, no need to install it.

# ---------- PYTHON VIRTUALENV ----------
# Get virtualenv
if [ `which virtualenv`x = x ]; then
    sudo apt-get --assume-yes install python-virtualenv
fi

# ---------- JAVA ----------
if [ `which javac`x = x ]; then
    sudo apt-get --assume-yes install openjdk-7-jre 
    sudo apt-get --assume-yes install openjdk-7-jdk
fi

# Cf. file 'activate' - should be the same
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

if [ ! -d $JAVA_HOME ]; then
    echo 1>&2 No directory $JAVA_HOME
    exit 1
fi

# ---------- MAVEN 3 ----------
if [ `which mvn`x = x ]; then
    sudo apt-get --assume-yes install maven
fi

# ---------- LSOF ----------
# neo4j needs this
if [ `which lsof`x = x ]; then
    sudo apt-get --assume-yes install lsof
fi

# ---------- APACHE VHOST ----------

# Set up apache so that web2py takes over the vhost

# How the apache config (the one found in the deployment setup
# directory) was created: we copied the apache default vhost config
# (000-default) from a fresh EC2 instance, then modified it to make
# web2py work, per instructions found on the web.  See
# /etc/apache2/sites-available/default .

# The purpose here (of clobbering the default vhost) is to avoid
# having to know all of our own vhost names.  Instead we make opentree
# the default 'vhost'.  The opentree config file gets put into
# place later on in the setup sequence.

sudo rm -f /etc/apache2/sites-enabled/000-default
(cd /etc/apache2/sites-enabled; \
 sudo ln -sf ../sites-available/opentree ./000-opentree)

# ---------- UNPRIVILEGED USER ----------

if [ ! -e ~opentree ]; then
    sudo useradd opentree
    sudo cp -pr /etc/skel ~opentree
    sudo chown -R opentree:opentree ~opentree
    sudo chmod g+sw ~opentree
    sudo chsh -s /bin/bash opentree 
fi

if [ ! -e ~opentree/.ssh ]; then
    sudo mkdir ~opentree/.ssh
    sudo cp -p .ssh/authorized_keys ~opentree/.ssh/
    sudo chmod 700 ~opentree/.ssh/
    sudo chown -R opentree:opentree ~opentree
fi

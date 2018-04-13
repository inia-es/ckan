#install requirements for the DataPusher
apt-get install python-dev python-virtualenv build-essential libxslt1-dev libxml2-dev git

#create a virtualenv for datapusher
virtualenv /usr/lib/ckan/datapusher

#create a source directory and switch to it
mkdir /usr/lib/ckan/datapusher/src
cd /usr/lib/ckan/datapusher/src

#clone the source (this should target the latest tagged version)
git clone -b 0.0.10 https://github.com/ckan/datapusher.git

#install the DataPusher and its requirements
cd datapusher
/usr/lib/ckan/datapusher/bin/pip install -r requirements.txt
/usr/lib/ckan/datapusher/bin/python setup.py develop

#copy the standard Apache config file
# (use deployment/datapusher.apache2-4.conf if you are running under Apache 2.4)
cp deployment/datapusher.conf /etc/apache2/sites-available/datapusher.conf

#copy the standard DataPusher wsgi file
#(see note below if you are not using the default CKAN install location)
cp deployment/datapusher.wsgi /etc/ckan/

#copy the standard DataPusher settings.
cp deployment/datapusher_settings.py /etc/ckan/

#open up port 8800 on Apache where the DataPusher accepts connections.
#make sure you only run these 2 functions once otherwise you will need
#to manually edit /etc/apache2/ports.conf.
sh -c 'echo "NameVirtualHost *:8800" >> /etc/apache2/ports.conf'
sh -c 'echo "Listen 8800" >> /etc/apache2/ports.conf'

#enable DataPusher Apache site
a2ensite datapusher

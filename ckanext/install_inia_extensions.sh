#!/bin/bash

set -e

cd /usr/lib/ckan/default/src

#Download extensions

git clone https://github.com/ckan/ckanext-basiccharts.git
git clone https://github.com/fernandobac03/ckanext-gallery-inia.git 
git clone https://github.com/inia-es/ckanext-scheming.git
git clone https://github.com/inia-es/ckanext-repeating.git
git clone https://github.com/inia-es/ckanext-predataset.git
git clone https://github.com/fernandobac03/ckanext-recordviewer.git 
git clone https://github.com/NaturalHistoryMuseum/ckanext-ldap.git
#git clone https://github.com/fernandobac03/ckanext-quality.git
git clone https://github.com/inia-es/ckanext-quality.git

source /usr/lib/ckan/default/bin/activate

#pip install git+https://github.com/NaturalHistoryMuseum/ckanext-userdatasets#egg=ckanext-userdatasets
pip install -e "git+https://github.com/datagovuk/ckanext-hierarchy.git#egg=ckanext-hierarchy"

#Install private datasets
#pip install ckanext-privatedatasets

#Install chart plugin

cd ckanext-basiccharts
python setup.py install

#Install gallery plugin 

cd ../ckanext-gallery-inia
python setup.py install

#Install scheming extension

cd ../ckanext-scheming
python setup.py develop
pip install -r requirements.txt

#Install repeating extension

cd ../ckanext-repeating
python setup.py install

#Install pre-dataset extension with new metadata


cd ../ckanext-predataset
python setup.py develop
pip install -r dev-requirements.txt

#install recordviewer extension

cd ../ckanext-recordviewer 
python setup.py install 

#Install quality component

cd ../ckanext-quality
python setup.py develop

#Install LDAP extension
cd ../ckanext-ldap
pip install -r requirements.txt
python setup.py develop

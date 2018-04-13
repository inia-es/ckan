#!/bin/bash

service apache2 restart;
/usr/lib/ckan/default/bin/paster serve /etc/ckan/default/ckan.ini;

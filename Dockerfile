# docker build . -t ckan && docker run -d -p 80:5000 --link db:db --link redis:redis --link solr:solr ckan

FROM debian:jessie
MAINTAINER Open Knowledge

ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_STORAGE_PATH /var/lib/ckan
ENV CKAN_SITE_URL http://localhost:5000

# Install required packages
RUN apt-get update

RUN apt-get -q -y update && apt-get -q -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
        python-dev \
        python-pip \
        python-virtualenv \
        libpq-dev \
        git-core \
        nginx \
        apache2 \
        libapache2-mod-rpaf \
        libapache2-mod-wsgi \
        nano \
        build-essential \
        libxslt1-dev \
        libxml2-dev \
        zlib1g-dev \
        git \
	libldap2-dev \
	libsasl2-dev \
	libssl-dev \
        libffi-dev \
	&& apt-get -q clean

# SetUp Virtual Environment CKAN
RUN mkdir -p $CKAN_HOME $CKAN_CONFIG $CKAN_STORAGE_PATH
RUN virtualenv $CKAN_HOME
RUN ln -s $CKAN_HOME/bin/pip /usr/local/bin/ckan-pip
RUN ln -s $CKAN_HOME/bin/paster /usr/local/bin/ckan-paster

# SetUp Requirements
ADD ./requirements.txt $CKAN_HOME/src/ckan/requirements.txt
RUN ckan-pip install --upgrade -r $CKAN_HOME/src/ckan/requirements.txt

# TMP-BUGFIX https://github.com/ckan/ckan/issues/3388
ADD ./dev-requirements.txt $CKAN_HOME/src/ckan/dev-requirements.txt
RUN ckan-pip install --upgrade -r $CKAN_HOME/src/ckan/dev-requirements.txt

# SetUp CKAN
ADD . $CKAN_HOME/src/ckan/
RUN ckan-pip install -e $CKAN_HOME/src/ckan/
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini

# Install and config DataPusher

COPY ./ckanext/datapusher/install_datapusher.sh /
RUN chmod +x /install_datapusher.sh
RUN ./install_datapusher.sh
COPY ./ckanext/datapusher/datapusher.conf /etc/apache2/sites-available/

# Install INIA extensions
COPY ./ckanext/install_inia_extensions.sh /
RUN chmod +x /install_inia_extensions.sh
RUN ./install_inia_extensions.sh


#*** OEG - Install New requirements - OEG ***#
ADD ./inia/inia-requirements.txt $CKAN_HOME/src/ckan/inia-requirements.txt
RUN ckan-pip install --upgrade -r $CKAN_HOME/src/ckan/inia-requirements.txt 

# SetUp EntryPoint
COPY ./contrib/docker/ckan-entrypoint.sh /
RUN chmod +x /ckan-entrypoint.sh
ENTRYPOINT ["/ckan-entrypoint.sh"]

# Volumes
VOLUME ["/etc/ckan/default"]
VOLUME ["/var/lib/ckan"]
EXPOSE 5000 8800

COPY /start_ckan.sh /
RUN chmod +x /start_ckan.sh
CMD ["/start_ckan.sh"]

#CMD ["ckan-paster","serve","/etc/ckan/default/ckan.ini"]

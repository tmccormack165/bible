FROM ubuntu:22.04
FROM tmccormack14/emdros-image:2023_11_13

# authors
LABEL org.opencontainers.image.authors = "@tmccormack14, @ulrikp"

# expose port 8000
EXPOSE 8000

# non-interactive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# update
RUN apt update -y

# add mysql installation script 
ADD mysql_install.sh /
RUN chmod +x /mysql_install.sh

# add mysql configuration script
ADD mysql_config.sh /
RUN chmod +x mysql_config.sh

# add script to install client side software 
# PLEASE DO NOT INSTALL CLIENT SOFTWARE IN A WEB SERVER
ADD client_install.sh /
RUN chmod +x client_install.sh

# install the dependencies
RUN apt-get install -y \
    apache2 php-dev php-sqlite3 \
    mysql-client php-intl php-xml \
    mysql-server php-json git \
    php php-mbstring curl \
    php-curl php-mysql \
    systemctl

# start apache2 server
RUN systemctl enable apache2.service
RUN systemctl start apache2.service

# install emdros
RUN dpkg -i /tmp/emdros_deb/*.deb

# enable php extension
RUN phpenmod EmdrosPHP8

# clone Bible Online Learner and download databases
RUN cd /var/www/html/ && \
    git clone --recursive https://github.com/EzerIT/BibleOL && \
    cd BibleOL && \
    /bin/bash git-hooks/setup.sh 

CMD "/bin/bash"
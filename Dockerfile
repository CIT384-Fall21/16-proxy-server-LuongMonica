FROM ubuntu:20.04
# bc newer ubuntu asks for timezone info
ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y apache2 apache2-utils curl
WORKDIR /etc/apache2

RUN a2enmod ssl
RUN a2enmod autoindex

# create dir for each site, copy index.html in, setup vhost files
RUN mkdir /var/www/html/site1
RUN mkdir /var/www/html/site2
RUN mkdir /var/www/html/site3
COPY images /home/images
COPY site1.html /var/www/html/site1/index.html
COPY site2.html /var/www/html/site2/index.html
COPY site3.html /var/www/html/site3/index.html
COPY vhosts/site1.conf /etc/apache2/sites-available
COPY vhosts/site2.conf /etc/apache2/sites-available
COPY vhosts/site3.conf /etc/apache2/sites-available

# enable the sites
RUN a2ensite site1.conf
RUN a2ensite site2.conf
RUN a2ensite site3.conf

LABEL maintainer="monica.luong.234@my.csun.edu"
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

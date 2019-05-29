FROM ubuntu
MAINTAINER rosemberg <rosemberg.al@gmail.com>
ADD ./files /files_aux
RUN export DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install apache2 -y && \
apt-get install software-properties-common -y && \
add-apt-repository ppa:ondrej/php -y && \
apt-get install -y tzdata && \
ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime   && \
dpkg-reconfigure --frontend noninteractive tzdata  && \
apt-get update && \
apt-get install -y php7.3 php7.3-xml php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline libapache2-mod-php7.3 php-pear php7.3-dev php7.3-pgsql php7.3-mysql && \
apt-get install -y libaio1  && \
apt-get install -y alien && \
alien -i /files_aux/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm  && \
alien -i /files_aux/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm  && \
alien -i /files_aux/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm  && \
echo "/usr/lib/oracle/11.2/client64/lib" > /etc/ld.so.conf.d/oracle.conf  && \
ldconfig  && \
export ORACLE_HOME=/usr/lib/oracle/11.2/client64/   && \
cd /files_aux/php-src-PHP-7.3.5/ext/oci8/  && \
phpize  && \
./configure --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib  && \
make install  && \
echo "extension=oci8.so" > /etc/php/7.3/mods-available/oci8.ini   && \
ln -s /etc/php/7.3/mods-available/oci8.ini /etc/php/7.3/apache2/conf.d/oci8.ini  && \
cd /files_aux/php-src-PHP-7.3.5/ext/pdo_oci/  && \
phpize  && \
./configure --with-pdo-oci=instantclient,/usr/lib/oracle/11.2/client64/lib  && \
make install  && \
echo "extension=pdo_oci.so" > /etc/php/7.3/mods-available/pdo_oci.ini  && \
ln -s /etc/php/7.3/mods-available/pdo_oci.ini /etc/php/7.3/apache2/conf.d/pdo_oci.ini 
#RUN ln -sf /dev/stderr /var/log/apache2/error.log
RUN rm -rf /files_aux
EXPOSE 80
CMD apachectl -D FOREGROUND

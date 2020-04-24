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
apt-get install -y php7.4 php7.4-xml php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline libapache2-mod-php7.4 php-pear php7.4-dev php7.4-pgsql php7.4-mysql && \
apt-get install -y php7.4-bcmath php7.4-calendar php7.4-cgi  php7.4-ctype  php7.4-dom php7.4-exif php7.4-fileinfo php7.4-ftp php7.4-gettext php7.4-iconv php7.4-imap php7.4-mbstring php7.4-mysqli  && \
apt-get install -y php7.4-mysqlnd php7.4-pdo php7.4-pdo-mysql php7.4-pdo-pgsql php7.4-phar php7.4-posix php7.4-shmop php7.4-simplexml php7.4-sockets php7.4-sysvmsg php7.4-sysvsem php7.4-sysvshm && \
apt-get install -y php7.4-tokenizer php7.4-xmlreader php7.4-xmlwriter php7.4-xsl php7.4-zip composer && \
apt-get install -y libaio1  && \
apt-get install -y alien && \
alien -i /files_aux/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm  && \
alien -i /files_aux/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm  && \
alien -i /files_aux/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm  && \
echo "/usr/lib/oracle/11.2/client64/lib" > /etc/ld.so.conf.d/oracle.conf  && \
ldconfig  && \
export ORACLE_HOME=/usr/lib/oracle/11.2/client64/   && \
cd /files_aux/php-src-PHP-7.4.3/ext/oci8/  && \
phpize  && \
./configure --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib  && \
make install  && \
echo "extension=oci8.so" > /etc/php/7.4/mods-available/oci8.ini   && \
ln -s /etc/php/7.4/mods-available/oci8.ini /etc/php/7.4/apache2/conf.d/oci8.ini  && \
ln -s /etc/php/7.4/mods-available/oci8.ini /etc/php/7.4/cli/conf.d/oci8.ini  && \
cd /files_aux/php-src-PHP-7.4.3/ext/pdo_oci/  && \
phpize  && \
./configure --with-pdo-oci=instantclient,/usr/lib/oracle/11.2/client64/lib  && \
make install  && \
echo "extension=pdo_oci.so" > /etc/php/7.4/mods-available/pdo_oci.ini  && \
ln -s /etc/php/7.4/mods-available/pdo_oci.ini /etc/php/7.4/apache2/conf.d/pdo_oci.ini && \
ln -s /etc/php/7.4/mods-available/pdo_oci.ini /etc/php/7.4/cli/conf.d/pdo_oci.ini && \
cp /files_aux/apache2.conf /etc/apache2/apache2.conf && \
a2enmod rewrite && \
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php --filename=composer --install-dir="/usr/local/sbin" && \
php -r "unlink('composer-setup.php');"
#RUN chmod -R 777 /var/www/html
RUN ln -sf /dev/stderr /var/log/apache2/error.log
RUN rm -rf /files_aux
WORKDIR /var/www/html/
EXPOSE 80
CMD apachectl -D FOREGROUND

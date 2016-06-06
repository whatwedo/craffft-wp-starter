FROM whatwedo/wordpress-nginx-w3tc:latest

RUN mkdir -p /theme
ADD ./dist/wp-content/themes/{PACKAGE_NAME} /theme

RUN echo "mkdir -p /var/www/wp-content/themes/" >> /bin/everyboot
RUN echo "rm -rf /var/www/wp-content/themes/{PACKAGE_NAME}" >> /bin/everyboot
RUN echo "cp -r /theme /var/www/wp-content/themes/{PACKAGE_NAME}" >> /bin/everyboot
RUN echo "chown -R www-data:www-data /var/www" >> /bin/everyboot

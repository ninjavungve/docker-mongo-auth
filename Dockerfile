# Fix mongo version
FROM mongo:3.6.10

MAINTAINER <Linh Le> linh.ld.vp@gmail.com

##################################################################
# Auth Configuration. Modify as needed.                          #
# These environment variables can also be                        #
# specified through command line or docker-compose configuration #
##################################################################

# Example
# ENV AUTH 'YES'
# ENV AUTH_TYPE 'STRING'

# ENV MONGODB_ADMIN_USER root
# ENV MONGODB_ADMIN_PASS password

# ENV MONGODB_APPLICATION_DATABASE your_db
# ENV MONGODB_APPLICATION_USER user
# ENV MONGODB_APPLICATION_PASS password

EXPOSE 27017 27017

ADD startup.sh /startup.sh
ADD config_auth_mongodb.sh /config_auth_mongodb.sh

RUN chmod +x /startup.sh
RUN chmod +x /config_auth_mongodb.sh

CMD ["/startup.sh"]

# docker-mongo-auth
A Docker Image for MongoDB which makes it easy to create an Admin, a Database and a Database User when the container is first launched.

# Thanks to
# =========
Aashrey Sharma for [docker-mongo-auth](https://github.com/aashreys/docker-mongo-auth)

# Customization
There are a number of environment variables which you can specify to customize the username and passwords of your users.

- With Dockerfile apply AUTH_TYPE=STRING
  ```
  # ENV AUTH YES
  # ENV AUTH_TYPE STRING
  # ENV MONGODB_ADMIN_USER root
  # ENV MONGODB_ADMIN_PASS password
  # ENV MONGODB_APPLICATION_DATABASE your_db
  # ENV MONGODB_APPLICATION_USER user
  # ENV MONGODB_APPLICATION_PASS password
  ```

- With Dockerfile apply AUTH_TYPE=SECRETS
  ```
  # ENV AUTH YES
  # ENV AUTH_TYPE SECRETS
  # ENV MONGODB_ADMIN_USER /run/secrets/[root_username]
  # ENV MONGODB_ADMIN_PASS /run/secrets/[root_userpass]
  # ENV MONGODB_APPLICATION_DATABASE /run/secrets/[app_database_name]
  # ENV MONGODB_APPLICATION_USER /run/secrets/[app_username]
  # ENV MONGODB_APPLICATION_PASS /run/secrets/[app_userpass]
  ```

- With docker-compose.yml apply AUTH_TYPE=STRING
  ```
  services:
    db:
      image: mttjsc/mongo-auth2:latest
      environment:
        - AUTH=YES
        - AUTH_TYPE=STRING
        - MONGODB_ADMIN_USER=root
        - MONGODB_ADMIN_PASS=root
        - MONGODB_APPLICATION_DATABASE=mytestdatabase
        - MONGODB_APPLICATION_USER=testuser
        - MONGODB_APPLICATION_PASS=testpass
      ports:
        - "27017:27017"
  // more configuration
  ```

- With docker-compose.yml apply AUTH_TYPE=SECRETS
  ```
  services:
    db:
      image: mttjsc/mongo-auth2:latest
      environment:
        - AUTH=YES
        - AUTH_TYPE=SECRETS
        - MONGODB_ADMIN_USER=/run/secrets/[root_username]
        - MONGODB_ADMIN_PASS=/run/secrets/[root_userpass]
        - MONGODB_APPLICATION_DATABASE=/run/secrets/[app_database_name]
        - MONGODB_APPLICATION_USER=/run/secrets/[app_username]
        - MONGODB_APPLICATION_PASS=/run/secrets/[app_userpass]
      ports:
        - "27017:27017"
  // more configuration
  ```

- With command line
  ```
  docker run -it \
    -e AUTH=YES \
    -e AUTH=STRING \
    -e MONGODB_ADMIN_USER=root \
    -e MONGODB_ADMIN_PASS=root \
    -e MONGODB_APPLICATION_DATABASE=mytestdatabase \
    -e MONGODB_APPLICATION_USER=testuser \
    -e MONGODB_APPLICATION_PASS=testpass \
    -p 27017:27017 mttjsc/mongo-auth2:latest
  ```

Find the image on Docker Cloud @ https://hub.docker.com/r/mttjsc/mongo-auth2

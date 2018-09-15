#!/bin/bash

# Get values from environment or attach default value string
# ENV TYPE
AUTH_TYPE=${AUTH_TYPE:-"STRING"}

# Admin User
MONGODB_ADMIN_USER=${MONGODB_ADMIN_USER:-"admin"}
MONGODB_ADMIN_PASS=${MONGODB_ADMIN_PASS:-"4dmInP4ssw0rd"}

# Application Database User
MONGODB_APPLICATION_USER=${MONGODB_APPLICATION_USER:-"restapiuser"}
MONGODB_APPLICATION_PASS=${MONGODB_APPLICATION_PASS:-"r3sT4pIp4ssw0rd"}
MONGODB_APPLICATION_DATABASE=${MONGODB_APPLICATION_DATABASE:-"admin"}

# # Check environment values by AUTH_TYPE
if [ "$AUTH_TYPE" == "SECRETS" ]; then
    # Admin User
    MONGODB_ADMIN_USER=$(cat "$MONGODB_ADMIN_USER")
    MONGODB_ADMIN_PASS=$(cat "$MONGODB_ADMIN_PASS")

    # Application Database User
    MONGODB_APPLICATION_USER=$(cat "$MONGODB_APPLICATION_USER")
    MONGODB_APPLICATION_PASS=$(cat "$MONGODB_APPLICATION_PASS")
    MONGODB_APPLICATION_DATABASE=$(cat "$MONGODB_APPLICATION_DATABASE")
fi

# Wait for MongoDB to boot
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup..."
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

# Create the admin user
echo "=> Creating admin user with a password in MongoDB"
mongo admin --eval "db.createUser({user: '$MONGODB_ADMIN_USER', pwd: '$MONGODB_ADMIN_PASS', roles:[{role:'root',db:'admin'}]});"

sleep 3

# If we've defined the MONGODB_APPLICATION_DATABASE environment variable and it's a different database
# than admin, then create the user for that database.
# First it authenticates to Mongo using the admin user it created above.
# Then it switches to the REST API database and runs the createUser command
# to actually create the user and assign it to the database.
if [ "$MONGODB_APPLICATION_DATABASE" != "admin" ]; then
    echo "=> Creating a ${MONGODB_APPLICATION_DATABASE} database user with a password in MongoDB"
    mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS << EOF
    echo "Using $MONGODB_APPLICATION_DATABASE database"
    use $MONGODB_APPLICATION_DATABASE
    db.createUser({user: '$MONGODB_APPLICATION_USER', pwd: '$MONGODB_APPLICATION_PASS', roles:[{role:'dbOwner', db:'$MONGODB_APPLICATION_DATABASE'}]})
EOF
fi

sleep 1

# If everything went well, add a file as a flag so we know in the future to not re-create the
# users if we're recreating the container (provided we're using some persistent storage)
touch /data/db/.config_auth_mongodb_success

echo "MongoDB configured successfully. You may now connect to the DB."

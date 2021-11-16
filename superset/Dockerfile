FROM apache/superset
# Switching to root to install the required packages
USER root
# Find which driver you need based on the analytics database
# you want to connect to here:
# https://superset.incubator.apache.org/installation.html#database-dependencies
RUN pip install psycopg2 flask_oauthlib Authlib
# Switching back to using the `superset` user
USER superset
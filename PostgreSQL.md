**<span style="font-size:3em;color:black">PostgreSQL</span>**
***

# pgAdmin

## Run in a Docker container with Web UI

```bash
docker run --name webui-pgadmin4 -p 5050:80 \
    -e 'PGADMIN_DEFAULT_EMAIL=pgadmin4@pgadmin.org' \
    -e 'PGADMIN_DEFAULT_PASSWORD=admin' \
    -v "/c/pgAdmin/servers.json":/pgadmin4/servers.json \
    -d dpage/pgadmin4
```

Then access via http://localhost:5050.

This is very useful when you're collaborating with teammates and already sharing a web browser window. It lets you add a pgAdmin browser tab, instead of switching the application that's being shared, or sharing your entire screen.

C:\pgAdmin\servers.json is optional, but can be exported from pgAdmin via Tools → Import/Export Servers...

References: https://www.pgadmin.org/download/pgadmin-4-container/ and https://hub.docker.com/r/dpage/pgadmin4/

# Misc

## Run client commands from a Docker container
For example:
```
docker run --rm --network=host -v "//c/:/c" postgres pg_dump --format=custom -d db_name --verbose -f "/c/tmp/dump.backup"
```

**<span style="font-size:3em;color:black">PostgreSQL pgAdmin</span>**
***

# Run in a Docker container with Web UI

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





# Hanukkah of Data 5783
Hanukkah of Data solutions in Postgres

Spoilers in the sql files, obviously.

Get the data:
```
wget https://hanukkah.bluebird.sh/5783/noahs-csv.zip
```

Unzip with the password from the zeroth puzzle:
```
unzip noahs-csv.zip
```

Create a database:
```
psql -c 'create database noahs;'
```

Load the data:
```
psql noahs -f load_data.sql

```

Solve puzzle N by running:
```
psql noahs -f puzzleN.sql
```




import sqlite3
import requests
import json

db = sqlite3.connect('amiibo.db')
print("Successfully opened database")
c = db.cursor()


def create_tables():
    c.execute('''CREATE TABLE amiibos
       (id INT NOT NULL,
       name TEXT NOT NULL,
       head TEXT NOT NULL,
       tail TEXT NOT NULL,
       characters TEXT NOT NULL,
       game_series TEXT,
       type TEXT NOT NULL,
       PRIMARY KEY(id)
       );''')

    c.execute('''CREATE TABLE usages
       (id INT NOT NULL,
       amiibo TEXT NOT NULL,
       game TEXT NOT NULL,
       platform TEXT NOT NULL,
       usage TEXT NOT NULL,
       write INT NOT NULL,
       PRIMARY KEY(id)
       );''')

    print("Successfully created tables")

    db.commit()


def construct_amiibos():
    amiibo_data = []
    usage_data = []

    api_data = requests.get("https://amiiboapi.com/api/amiibofull/")
    json_data = api_data.json()["amiibo"]
    i = 0
    j = 0

    for item in json_data:
        amiibo_data.append((i, item["name"], item["head"], item["tail"], item["character"], item["gameSeries"], item["type"]))
        for usage in item["games3DS"]:
            usage_data.append((j, item["name"], usage["gameName"], "3DS", usage["amiiboUsage"][0]["Usage"],
                               usage["amiiboUsage"][0]["write"]))
            j += 1

        for usage in item["gamesWiiU"]:
            usage_data.append((j, item["name"], usage["gameName"], "3DS", usage["amiiboUsage"][0]["Usage"],
                               usage["amiiboUsage"][0]["write"]))
            j += 1

        for usage in item["gamesSwitch"]:
            usage_data.append((j, item["name"], usage["gameName"], "3DS", usage["amiiboUsage"][0]["Usage"],
                               usage["amiiboUsage"][0]["write"]))
            j += 1

        i += 1

    c.execute("DELETE FROM amiibos")
    c.execute("DELETE FROM usages")

    sql = "INSERT INTO amiibos (id, name, head, tail, characters, game_series, type) VALUES (?, ?, ?, ?, ?, ?, ?);"
    c.executemany(sql, amiibo_data)

    sql = "INSERT INTO usages (id, amiibo, game, platform, usage, write) VALUES (?, ?, ?, ?, ?, ?);"
    c.executemany(sql, usage_data)

    db.commit()

    print("Successfully constructed tables")


if __name__ == "__main__":
    c.execute(''' SELECT count(name) FROM sqlite_master WHERE type='table' AND name='usages' ''')

    if c.fetchone()[0] == 0:
        create_tables()

    construct_amiibos()

    db.close()

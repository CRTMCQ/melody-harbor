# Sample Flask application for a BSG database, snapshot of BSG_people

from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
import os

app = Flask(__name__)

# database connection
# Template:
# app.config["MYSQL_HOST"] = "classmysql.engr.oregonstate.edu"
# app.config["MYSQL_USER"] = "cs340_OSUusername"
# app.config["MYSQL_PASSWORD"] = "XXXX" | last 4 digits of OSU id
# app.config["MYSQL_DB"] = "cs340_OSUusername"
# app.config["MYSQL_CURSORCLASS"] = "DictCursor"

# database connection info
app.config["MYSQL_HOST"] = "classmysql.engr.oregonstate.edu"
app.config["MYSQL_USER"] = "cs340_nguyebr4"
app.config["MYSQL_PASSWORD"] = "4262"
app.config["MYSQL_DB"] = "cs340_nguyebr4"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)

# Routes

# route for people page
@app.route("/songs", methods=["POST", "GET"])
def songs():
    # Separate out the request methods, in this case this is for a POST
    # insert a person into the bsg_people entity
    if request.method == "POST":
        # fire off if user presses the Add Person button
        if request.form.get("Add_Song"):
            # grab user form inputs
            name = request.form["name"]
            album = request.form["album"]
            artists = request.form["artists"]
            streamCt = request.form["streamCt"]
            genre = request.form["genre"]
            keySignature = request.form["keySignature"]
            chordProgression = request.form["chordProgression"]
            lowRange = request.form["lowRange"]
            highRange = request.form["highRange"]
            lyrics = request.form["lyrics"]

            # no null inputs
            query = "INSERT INTO Songs (name,albumID,streamCt,genre,keySignature,chordProgression,lowRange,highRange,lyrics) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)"
            cur = mysql.connection.cursor()
            cur.execute(query, (name,album,streamCt,genre,keySignature,chordProgression,lowRange,highRange,lyrics))
            mysql.connection.commit()

            # redirect back to people page
            return redirect("/people")

    # Grab bsg_people data so we send it to our template to display
    if request.method == "GET":
        # mySQL query to grab all the people in bsg_people
        query = "SELECT Songs.songID, fname, lname, bsg_planets.name AS homeworld, age FROM bsg_people LEFT JOIN Albums ON homeworld = bsg_planets.id"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query to grab planet id/name data for our dropdown
        query2 = "SELECT albumID, title FROM Albums"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        album = cur.fetchall()

        # render edit_people page passing our query data and homeworld data to the edit_people template
        return render_template("songs.j2", data=data, albums=album_data)


# route for delete functionality, deleting a person from bsg_people,
# we want to pass the 'id' value of that person on button click (see HTML) via the route
@app.route("/delete_songs/<int:id>")
def delete_songs(id):
    # mySQL query to delete the person with our passed id
    query = "DELETE FROM Songs WHERE id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (id,))
    mysql.connection.commit()

    # redirect back to songs page
    return redirect("/songs")


# route for edit functionality, updating the attributes of a person in bsg_people
# similar to our delete route, we want to the pass the 'id' value of that person on button click (see HTML) via the route
@app.route("/edit_songs/<int:id>", methods=["POST", "GET"])
def edit_people(id):
    if request.method == "GET":
        # mySQL query to grab the info of the person with our passed id
        query = "SELECT * FROM Songs WHERE id = %s" % (id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query to grab planet id/name data for our dropdown
        query2 = "SELECT albumID, name FROM Albums"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        albums_data = cur.fetchall()

        # render edit_people page passing our query data and homeworld data to the edit_people template
        return render_template("edit_songss.j2", data=data, albums=albums_data)

    # meat and potatoes of our update functionality
    if request.method == "POST":
        # fire off if user clicks the 'Edit Person' button
        if request.form.get("Edit_Song"):
            # grab user form inputs
            id = request.form["songID"]
            name = request.form["name"]
            album = request.form["album"]
            artists = request.form["artists"]
            streamCt = request.form["streamCt"]
            genre = request.form["genre"]
            keySignature = request.form["keySignature"]
            chordProgression = request.form["chordProgression"]
            lowRange = request.form["lowRange"]
            highRange = request.form["highRange"]
            lyrics = request.form["lyrics"]

#            # account for null age AND homeworld
#            if (age == "" or age == "None") and homeworld == "0":
#                # mySQL query to update the attributes of person with our passed id value
#                query = "UPDATE bsg_people SET bsg_people.fname = %s, bsg_people.lname = %s, bsg_people.homeworld = NULL, bsg_people.age = NULL WHERE bsg_people.id = %s"
#                cur = mysql.connection.cursor()
#                cur.execute(query, (fname, lname, id))
#                mysql.connection.commit()
#
#            # account for null homeworld
#            elif homeworld == "0":
#                query = "UPDATE bsg_people SET bsg_people.fname = %s, bsg_people.lname = %s, bsg_people.homeworld = NULL, bsg_people.age = %s WHERE bsg_people.id = %s"
#                cur = mysql.connection.cursor()
#                cur.execute(query, (fname, lname, age, id))
#                mysql.connection.commit()
#
#            # account for null age
#            elif age == "" or age == "None":
#                query = "UPDATE bsg_people SET bsg_people.fname = %s, bsg_people.lname = %s, bsg_people.homeworld = %s, bsg_people.age = NULL WHERE bsg_people.id = %s"
#                cur = mysql.connection.cursor()
#                cur.execute(query, (fname, lname, homeworld, id))
#                mysql.connection.commit()

            # no null inputs
            else:
                query = "UPDATE Songs SET Songs.name = %s, Songs.albumID = %s, Songs.streamCt = %s, Songs.genre = %s, Songs.keySignature = %s, Songs.chordProgression = %s, Songs.lowRange = %s, Songs.highRange = %s, Songs.lyrics = %s WHERE Songs.songID = %s"
                cur = mysql.connection.cursor()
                cur.execute(query, (name,album,streamCt,genre,keySignature,chordProgression,lowRange,highRange,lyrics,id))
                mysql.connection.commit()

            # redirect back to songs page after we execute the update query
            return redirect("/songs")


# Listener
# change the port number if deploying on the flip servers
if __name__ == "__main__":
    app.run(port=6234, debug=True)
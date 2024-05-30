// Citation for the following code: app.js, db-connector.js, views/, public/js/
// Date: 5/23/2024
// Adapted from: CS340 nodejs-starter-app 
// The starter app code was used as a basis for development, and adapted to better fit the melody-harbor database
// Source URL: https://github.com/osu-cs340-ecampus/nodejs-starter-app


/*
    SETUP
*/
var express = require('express');   // We are using the express library for the web server
var app     = express();            // We need to instantiate an express object to interact with the server in our code
PORT        = 62305;                 // Set a port number at the top so it's easy to change in the future

app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.use(express.static('public'))

var db = require('./database/db-connector')    // Database

const { engine } = require('express-handlebars');
var exphbs = require('express-handlebars');     // Import express-handlebars
app.engine('.hbs', engine({extname: ".hbs"}));  // Create an instance of the handlebars engine to process templates
app.set('view engine', '.hbs');                 // Tell express to use the handlebars engine whenever it encounters a *.hbs file.


/*
    INDEX ROUTES
*/
app.get('/', function(req, res)
    {
        res.render('index');                    // Note the call to render() and not send(). Using render() ensures the templating engine
    });                                         // will process this file, before sending the finished HTML to the client.


/*
    LABEL ROUTES
*/
app.get('/labels', function(req, res)
    {  
        let query1 = "SELECT * FROM RecordLabels;";

        db.pool.query(query1, (error, rows, fields) => {
            let labels = rows; 
            return res.render('labels', {data: labels});
        })
    });                                                         

app.post('/add-label-form', function(req, res)
    {
        // Capture the incoming data and parse it back to a JS object
        let data = req.body;

        if (data['input-name'] && data['input-location'])
            // Create the query and run it on the database
            query1 = `INSERT INTO RecordLabels (name, address) VALUES ('${data['input-name']}','${data['input-location']}')`;
            db.pool.query(query1, function(error, rows, fields){

                // Check to see if there was an error
                if (error) {

                    // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                    console.log(error)
                    res.sendStatus(400);
                }
                // If there was no error, we redirect back to our root route, which automatically runs the SELECT * FROM RecordLabels and
                // presents it on the screen
                else
                {
                    res.redirect('/labels');
                }
            })
    })

app.delete('/delete-label-ajax/', function(req,res,next){
    let data = req.body;
    let labelID = parseInt(data.labelID);
    let deleteLabels= `DELETE FROM RecordLabels WHERE labelID = ?`;
       
        // Run the 1st query
        db.pool.query(deleteLabels, [labelID], function(error, rows, fields) {
            if (error) {
                console.log(error);
                res.sendStatus(400);
            } else {
                res.sendStatus(204);
            }
        })});


/*
    ARTIST ROUTES
*/
app.get('/artists', function(req, res)
    {  
        // Declare Query 1
        let query1 = "SELECT * FROM Artists;";

        // Query 2 is the same in both cases
        let query2 = "SELECT * FROM RecordLabels;";

        // Run the 1st query
        db.pool.query(query1, function(error, rows, fields){
        
            let artists = rows;
            
            // Run the second query
            db.pool.query(query2, (error, rows, fields) => {
                
                let labels = rows; 

                let labelmap = {}
                labels.map(label => {
                    let id = parseInt(label.labelID, 10);
                    labelmap[id] = label["name"];
                })

                // Overwrite the labelID with the name of the label in the artists object
                artists = artists.map(artist => {
                    return Object.assign(artist, {labelID: labelmap[artist.labelID]})
                })
                
                return res.render('artists', {data: artists, labels: labels});
            })
        })
    });                                                             

app.post('/add-artist-form', function(req, res)
    {
        // Capture the incoming data and parse it back to a JS object
        let data = req.body;

        // Capture NULL values
        let location = parseInt(data['input-location']);
        if (isNaN(location))
        {
            location = 'NULL'
        }

        // Create the query and run it on the database
        query1 = `INSERT INTO Artists (name, listenerCt, cityOfOrigin, labelID) VALUES ('${data['input-name']}', '${data['input-listenerCt']}', '${data['input-cityOfOrigin']}', '${data['input-label']}')`;
        db.pool.query(query1, function(error, rows, fields){

            // Check to see if there was an error
            if (error) {

                // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                console.log(error)
                res.sendStatus(400);
            }

            // If there was no error, we redirect back to our root route, which automatically runs the SELECT * FROM bsg_people and
            // presents it on the screen
            else
            {
                res.redirect('/artists');
            }
        })
    })

app.delete('/delete-artist-ajax/', function(req,res,next){
    let data = req.body;
    let artistID = parseInt(data.artistID);
    let deleteArtists= `DELETE FROM Artists WHERE artistID = ?`;
       
        // Run the 1st query
        db.pool.query(deleteArtists, [artistID], function(error, rows, fields) {
            if (error) {
                console.log(error);
                res.sendStatus(400);
            } else {
                res.sendStatus(204);
            }
        })});


/*
    ALBUM ROUTES
*/
app.get('/albums', function(req, res)
{  
    // Declare Query 1
    let query1 = "SELECT * FROM Albums;";

    // Query 2 is the same in both cases
    let query2 = "SELECT * FROM Artists;";

    // Run the 1st query
    db.pool.query(query1, function(error, rows, fields){
    
        // Save the people
        let albums = rows;
        
        // Run the second query
        db.pool.query(query2, (error, rows, fields) => {

            let artists = rows; 

            let artistmap = {}
            artists.map(artist => {
                let id = parseInt(artist.artistID, 10);
                artistmap[id] = artist["name"];
            })

            albums = albums.map(album => {
                return Object.assign(album, {artistID: artistmap[album.artistID]})
            })

            return res.render('albums', {data: albums, artists: artists});
        })
    })
});                                                                       

app.post('/add-album-form', function(req, res)
    {
        // Capture the incoming data and parse it back to a JS object
        let data = req.body;



        // Create the query and run it on the database
        query1 = `INSERT INTO Albums (title, genre, artistID) VALUES ('${data['input-title']}', '${data['input-genre']}', '${data['input-artist']}')`;
        db.pool.query(query1, function(error, rows, fields){

            // Check to see if there was an error
            if (error) {

                // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                console.log(error)
                res.sendStatus(400);
            }

            // If there was no error, we redirect back to our root route, which automatically runs the SELECT * FROM bsg_people and
            // presents it on the screen
            else
            {
                res.redirect('/albums');
            }
        })
    })

app.delete('/delete-album-ajax/', function(req,res,next){
    let data = req.body;
    let albumID = parseInt(data.albumID);
    let deleteAlbums= `DELETE FROM Albums WHERE albumID = ?`;
       
        // Run the 1st query
        db.pool.query(deleteAlbums, [albumID], function(error, rows, fields) {
            if (error) {
                console.log(error);
                res.sendStatus(400);
            } else {
                res.sendStatus(204);
            }
        })});


/*
    SONG ROUTES
*/
app.get('/songs', function(req, res)
    {  
        let query1 = "SELECT * FROM Songs;";
        let query2 = "SELECT * FROM Albums;";
        let query3 = "SELECT * FROM Artists;";
        let query4 = "SELECT * FROM SongArtists;";

        // Run the 1st query
        db.pool.query(query1, function(error, rows, fields){
        
            let songs = rows;
            
            // Run the second query
            db.pool.query(query2, (error, rows, fields) => {
                
                let albums = rows; 

                let albummap = {}
                albums.map(album => {
                    let id = parseInt(album.albumID, 10);
                    albummap[id] = album["title"];
                })

                songs = songs.map(song => {
                    return Object.assign(song, {albumID: albummap[song.albumID]});
                })

                db.pool.query(query3, (error, rows, fields) => {

                    let artists = rows;

                    db.pool.query(query4, (error, rows, fields) => {

                        let songartists = rows;
    
                        return res.render('songs', {data: songs, albums: albums, artists: artists});
                    })
                })
            })
        })
    });                                                         


app.post('/add-song-form', function(req, res)
    {
        // Capture the incoming data and parse it back to a JS object
        let data = req.body;

        // Capture NULL values

        // Create the query and run it on the database
        query1 = `INSERT INTO Songs (name, albumID, streamCt, genre, keySignature, chordProgression, lowRange, highRange, lyrics) VALUES ('${data['input-name']}', '${data['input-album']}', ${data['input-streamCt']}, '${data['input-genre']}', '${data['input-keySignature']}', '${data['input-chordProgression']}', ${data['input-lowRange']}, ${data['input-highRange']}, '${data['input-lyrics']}')`;
        query2 = `INSERT INTO SongArtists (songID, artistID) VALUES ((SELECT MAX(songID) FROM Songs), '${data['input-artist']}')`;

        db.pool.query(query1, function(error, rows, fields){

            // Check to see if there was an error
            if (error) {

                // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                console.log(error)
                res.sendStatus(400);
            }

            else
            {
                db.pool.query(query2, function(error, rows, fields){

                    // Check to see if there was an error
                    if (error) {
        
                        // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                        console.log(error)
                        res.sendStatus(400);
                    }
        
                    else
                    {
                        res.redirect('/songs');
                    }
                })
            }
        })
    })


app.delete('/delete-song-ajax/', function(req,res,next){
    let data = req.body;
    let songID = parseInt(data.songID);
    let deleteSongArtists = `DELETE FROM SongArtists WHERE songID = ?`;
    let deleteSongs= `DELETE FROM Songs WHERE songID = ?`;
       
        db.pool.query(deleteSongArtists, [songID], function(error, rows, fields){
            if (error) {
                // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
                console.log(error);
                res.sendStatus(400);
            }

            else
            {
                // Run the second query
                db.pool.query(deleteSongs, [songID], function(error, rows, fields) {

                    if (error) {
                        console.log(error);
                        res.sendStatus(400);
                    } else {
                        res.sendStatus(204);
                    }
                })
            }
        })
    }
);

app.put('/put-song-ajax', function(req,res,next){
    let data = req.body;
    
    let queryUpdateSong = `UPDATE Songs SET name = ?, streamCt = ?, genre = ?, keySignature = ?, chordProgression = ?, lowRange = ?, highRange = ?, albumID = ?, lyrics = ? WHERE songID = ?`;
    let selectAlbums = "SELECT title FROM Albums WHERE albumID = ?;";

    // Run the 1st query
    db.pool.query(queryUpdateSong, [data.name, data.streamCt, data.genre, data.keySignature, data.chordProgression, data.lowRange, data.highRange, data.albumID, data.lyrics, data.songID], function(error, rows, fields){
        
        if (error) {
            // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
            console.log(error);
            res.sendStatus(400);
        }

        // If there was no error, we run our second query and return that data so we can use it to update the people's
        // table on the front-end
        else
        {
            // Run the second query
            db.pool.query(selectAlbums, [data.albumID], function(error, rows, fields) {
                
                album = rows[0].title;
                data.albumID = album;

                if (error) {
                    console.log(error);
                    res.sendStatus(400);
                } else {
                    res.send(data);
                }
            })
        }
    })
});


/*
    SONGARTISTS ROUTES
*/
app.get('/songartists', function(req, res)
    {  
        let query1 = "SELECT * FROM SongArtists;";
        let query2 = "SELECT * FROM Songs;";
        let query3 = "SELECT * FROM Artists;";

        db.pool.query(query1, (error, rows, fields) => {

            let songartists = rows; 
                    
            db.pool.query(query2, (error, rows, fields) => {

                let songs = rows; 

                let songmap = {}
                songs.map(song => {
                    let id = parseInt(song.songID, 10);
                    songmap[id] = song["name"];
                })

                songartists = songartists.map(songartist => {
                    return Object.assign(songartist, {songID: songmap[songartist.songID]})
                })

                db.pool.query(query3, (error, rows, fields) => {

                    let artists = rows; 
    
                    let artistmap = {}
                    artists.map(artist => {
                        let id = parseInt(artist.artistID, 10);
                        artistmap[id] = artist["name"];
                    })
    
                    songartists = songartists.map(songartist => {
                        return Object.assign(songartist, {artistID: artistmap[songartist.artistID]})
                    })
    
                    return res.render('songartists', {data: songartists});
                })
            })
        })
    });                                                         


/*
    LISTENER
*/
app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});
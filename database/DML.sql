-- Group 111
-- Team members: Carter McQuigg, Brandon Nguyen
-- Project: MelodyHarbor


---------------------------------------------------
--  Record Labels page
---------------------------------------------------

-- Select all table info for Record Labels page
SELECT * FROM RecordLabels;

-- Add RecordLabel
INSERT INTO RecordLabels (name, location)
VALUES (:labelNameInput, :locationInput);

-- Delete RecordLabel
DELETE FROM RecordLabels WHERE labelID = :labelID_to_delete;



---------------------------------------------------
--  Artists page
---------------------------------------------------

-- Select all table info for Artists page
-- Table Join completed in app.js by mapping RecordLabels.name onto Artists.labelID
SELECT * FROM Artists;
SELECT * FROM RecordLabels;

-- Fill Label dropdown list
SELECT labelID, name FROM RecordLabels;

-- Add Artist
INSERT INTO Artists (name, listenerCt, cityOfOrigin, labelID)
VALUES (:artistNameInput, :listenerCtInput, :cityOfOriginInput, :labelID_Dropdown);

-- Delete Artist
DELETE FROM Artists WHERE artistID = :artistID_to_delete;



---------------------------------------------------
--  Albums page
---------------------------------------------------

-- Select all table info for Albums page
-- Table JOIN completed in app.js by mapping Artists.name onto Albums.artistID
SELECT * FROM Albums;
SELECT * FROM Artists;

-- Fill Artists dropdown list
SELECT artistID, name FROM Artists;

-- Add Album
INSERT INTO Albums (title, genre, artistID)
VALUES (:albumTitleInput, :albumGenreInput, :artistID_Dropdown);

-- Delete Album
DELETE FROM Albums WHERE albumID = :albumID_to_delete;



---------------------------------------------------
--  Songs page
---------------------------------------------------

-- Select all table info for Songs page
-- Table JOIN completed in app.js by mapping Albums.title onto Songs.albumID
SELECT * FROM Songs;
SELECT * FROM Albums;
SELECT * FROM Artists;

-- Fill Artists dropdown for Add Song (duplicate line from Albums)
SELECT artistID, name FROM Artists;

-- Add Song
-- Inserts into Songs table and SongArtists table with two queries.
INSERT INTO Songs (name, albumID, streamCt, genre, keySignature, chordProgression, lowRange, highRange, lyrics)
VALUES (:songName, :albumID_selected, :streamCtInput, :genreInput, :keySigInput, :chordInput, :lowInput, :highInput, :lyricsInput);
INSERT INTO SongArtists (songID, artistID)
VALUES ((SELECT MAX(songID) FROM Songs), :artistID_dropdown);

-- Delete Song
-- Deletes from Songs and SongArtists tables with two queries
DELETE FROM Songs WHERE songID = :songID_to_delete;
DELETE FROM SongArtists WHERE songID = :songID_to_delete;

-- Fill Update Song form 
-- Table JOIN completed in app.js by mapping Albums.title onto Songs.albumID
SELECT * FROM Songs WHERE songID = :songID;
SELECT * FROM Albums;
SELECT * FROM Artists;
SELECT * FROM SongArtists;

-- Update Song
UPDATE Songs
SET name = :songName, albumID = :albumID_selected, streamCt = :streamCtInput, genre = :genreInput, keySignature = :keySigInput,
chordProgression = :chordInput, lowRange = :lowInput, highRange = :highInput, lyrics = :lyricsInput
WHERE songID = :selected_songID;

-- Update entry for SongArtists intersection table
UPDATE SongArtists
SET artistID = :artistID_dropdown
WHERE songID = :selected_songID;



---------------------------------------------------
--  SongArtists page
---------------------------------------------------

-- Select all table info for SongArtists page
-- Table JOIN completed in app.js by mapping Songs.name onto SongArtists.songID, and Artists.name onto SongArtists.artistID
SELECT * FROM SongArtists;
SELECT * FROM Songs;
SELECT * FROM Artists;

-- Add SongArtists relationship
INSERT INTO SongArtists (songID, artistID)
VALUES (:song_input, :artistID_dropdown);

-- Delete SongArtists relationship
DELETE FROM SongArtists WHERE songArtistsID = :selected_ID;






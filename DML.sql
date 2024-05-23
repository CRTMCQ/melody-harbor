-- Group 111
-- Team members: Carter McQuigg, Brandon Nguyen
-- Project: MelodyHarbor


---------------------------------------------------
--  Record Labels page
---------------------------------------------------

-- Select all table info for Record Labels page
SELECT labelID AS ID, name AS "Label Name", location AS Location FROM RecordLabels;

-- Add RecordLabel
INSERT INTO RecordLabels (name, location)
VALUES (:labelNameInput, :locationInput);

-- Delete RecordLabel
DELETE FROM RecordLabels WHERE labelID = :labelID_to_delete;



---------------------------------------------------
--  Artists page
---------------------------------------------------

-- Select all table info for Artists page
SELECT Artists.artistID AS ID, Artists.name AS Name, listenerCt AS `Monthly Listeners`, cityOfOrigin AS `City of Origin`, RecordLabels.name AS Label
FROM Artists 
JOIN RecordLabels ON Artists.labelID = RecordLabels.labelID;

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
SELECT albumID AS ID, title AS Title, genre AS Genre, Artists.name AS Artist 
FROM Albums
JOIN Artists ON Albums.artistID = Artists.artistID;

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
SELECT Songs.songID AS ID, Songs.name AS Title, Albums.title AS Album, GROUP_CONCAT(Artists.name SEPARATOR '\n') AS "Artist(s)",
streamCt AS "Stream Count", Songs.genre AS Genre, keySignature AS "Key Signature", chordProgression AS "Chord Progression(s)",
CONCAT(lowRange, '--', highRange) AS "Vocal Range", lyrics AS Lyrics
FROM Songs
JOIN Albums ON Songs.albumID = Albums.albumID 
JOIN SongArtists ON Songs.songID = SongArtists.songID 
JOIN Artists ON Artists.artistID = SongArtists.artistID
GROUP BY Songs.songID;

-- Fill Artists dropdown for Add Song (duplicate line from Albums)
SELECT artistID, name FROM Artists;

-- Add Song
INSERT INTO Songs (name, albumID, streamCt, genre, keySignature, chordProgression, lowRange, highRange, lyrics)
VALUES (:songName, :albumID_selected, :streamCtInput, :genreInput, :keySigInput, :chordInput, :lowInput, :highInput, :lyricsInput);

-- Add new entry for SongArtists intersection table
INSERT INTO SongArtists (songID, artistID)
VALUES ((SELECT songID FROM Songs WHERE name=(:songName)), :artistID_dropdown);

-- Fill Select Song dropdown for Update Song
SELECT songID, name FROM Songs;

-- Fill Update Song form when Song selected
SELECT Songs.name, albumID, GROUP_CONCAT(Artists.name SEPARATOR '\n') AS "Artist(s)", streamCt, genre, keySignature, chordProgression, lowRange, highRange, lyrics
FROM Songs
JOIN SongArtists ON Songs.songID = SongArtists.songID
JOIN Artists ON Artists.artistID = SongArtists.artistID
WHERE songID = :selected_songID;

-- Update Song
UPDATE Songs
SET name = :songName, albumID = :albumID_selected, streamCt = :streamCtInput, genre = :genreInput, keySignature = :keySigInput,
chordProgression = :chordInput, lowRange = :lowInput, highRange = :highInput, lyrics = :lyricsInput
WHERE songID = :selected_songID;

-- Update entry for SongArtists intersection table
UPDATE SongArtists
SET artistID = :artistID_dropdown
WHERE songID = :selected_songID;

-- Delete Song
DELETE FROM Songs WHERE songID = :songID_to_delete;

-- Delete SongArtists record
DELETE FROM SongArtists WHERE songID = :songID_to_delete AND artistID = :artistID_to_delete;
// Get the objects we need to modify
let updateSongForm = document.getElementById('update-song-form-ajax');

// Modify the objects we need
updateSongForm.addEventListener("submit", function (e) {
   
    // Prevent the form from submitting
    e.preventDefault();

    // Get form fields we need to get data from
    let inputSong = document.getElementById("songSelect");
    let inputTitle = document.getElementById("update-title");
    let inputAlbum = document.getElementById("update-albumSelect");
    let inputArtist = document.getElementById("update-artistSelect");
    let inputStreamCt = document.getElementById("update-streamCt");
    let inputGenre = document.getElementById("update-genre");
    let inputKeySig = document.getElementById("update-keySig");
    let inputChord = document.getElementById("update-chord");
    let inputLow = document.getElementById("update-low");
    let inputHigh = document.getElementById("update-high");
    let inputLyrics = document.getElementById("update-lyrics");


    // Get the values from the form fields
    let songVal = inputSong.value;
    let titleVal = inputTitle.value;
    let albumVal = inputAlbum.value;
    let artistVal = inputArtist.value;
    let streamVal = inputStreamCt.value;
    let genreVal = inputGenre.value;
    let keyVal = inputKeySig.value;
    let chordVal = inputChord.value;
    let lowVal = inputLow.value;
    let highVal = inputHigh.value;
    let lyricsVal = inputLyrics.value;


    // Put our data we want to send in a javascript object
    let data = {
        name: titleVal,
        streamCt: streamVal,
        genre: genreVal,
        keySignature: keyVal,
        chordProgression: chordVal,
        lowRange: lowVal,
        highRange: highVal,
        albumID: albumVal,
        lyrics: lyricsVal
    }
    
    // Setup our AJAX request
    var xhttp = new XMLHttpRequest();
    xhttp.open("PUT", "/put-song-ajax", true);
    xhttp.setRequestHeader("Content-type", "application/json");

    // Tell our AJAX request how to resolve
    xhttp.onreadystatechange = () => {
        if (xhttp.readyState == 4 && xhttp.status == 200) {

            // Add the new data to the table
            updateRow(xhttp.response, songVal);

        }
        else if (xhttp.readyState == 4 && xhttp.status != 200) {
            console.log("There was an error with the input.")
        }
    }

    // Send the request and wait for the response
    xhttp.send(JSON.stringify(data));

})


function updateRow(data, songID){
    let parsedData = JSON.parse(data);
    
    let table = document.getElementById("song-table");

    for (let i = 0, row; row = table.rows[i]; i++) {
       //iterate through rows
       //rows would be accessed using the "row" variable assigned in the for loop
       if (table.rows[i].getAttribute("data-value") == songID) {

            // Get the location of the row where we found the matching songID
            let updateRowIndex = table.getElementsByTagName("tr")[i];

            // Get all respective tds
            let td_title = updateRowIndex.getElementsByTagName("td")[1];
            let td_album = updateRowIndex.getElementsByTagName("td")[2];
            let td_streams = updateRowIndex.getElementsByTagName("td")[4];
            let td_genre = updateRowIndex.getElementsByTagName("td")[5];
            let td_key = updateRowIndex.getElementsByTagName("td")[6];
            let td_chord = updateRowIndex.getElementsByTagName("td")[7];
            let td_range = updateRowIndex.getElementsByTagName("td")[8];
            let td_lyrics = updateRowIndex.getElementsByTagName("td")[9];

            // Update the values
            td_title.innerHTML = parsedData[0].name; 
            td_album.innerHTML = parsedData[0].albumID; 
            td_streams.innerHTML = parsedData[0].streamCt;
            td_genre.innerHTML = parsedData[0].genre;
            td_key.innerHTML = parsedData[0].keySignature;
            td_chord.innerHTML = parsedData[0].chordProgression;
            td_range.innerHTML = parsedData[0].lowRange + "-" + parsedData[0].highRange;
            td_lyrics.innerHTML = parsedData[0].lyrics;
       }
    }
}
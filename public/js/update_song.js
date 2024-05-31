// Get the objects we need to modify
let updateSongForm = document.getElementById('update-song-form-ajax');

// Modify the objects we need
updateSongForm.addEventListener("submit", function (e) {
   
    // Prevent the form from submitting
    e.preventDefault();

    // Get form fields we need to get data from

    let inputSong = document.getElementById("update-song");
    let inputTitle = document.getElementById("update-title");
    let inputAlbum = document.getElementById("update-album");
    let inputStreamCt = document.getElementById("update-streamCt");
    let inputGenre = document.getElementById("update-genre");
    let inputKeySig = document.getElementById("update-keySignature");
    let inputChord = document.getElementById("update-chordProgression");
    let inputLow = document.getElementById("update-lowRange");
    let inputHigh = document.getElementById("update-highRange");
    let inputLyrics = document.getElementById("update-lyrics");


    // Get the values from the form fields
    let songVal = inputSong.value;
    let titleVal = inputTitle.value;
    let albumVal = inputAlbum.value;
    let streamVal = inputStreamCt.value;
    let genreVal = inputGenre.value;
    let keyVal = inputKeySig.value;
    let chordVal = inputChord.value;
    let lowVal = inputLow.value;
    let highVal = inputHigh.value;
    let lyricsVal = inputLyrics.value;


    // Put our data we want to send in a javascript object
    let data = {
        songID: songVal,
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
            window.location.href = "/songs";
        }
        else if (xhttp.readyState == 4 && xhttp.status != 200) {
            console.log("There was an error with the input.")
        }
    }

    // Send the request and wait for the response
    xhttp.send(JSON.stringify(data));

})

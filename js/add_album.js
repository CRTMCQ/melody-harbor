// Get the objects we need to modify
let addAlbumForm = document.getElementById('add-album-form-ajax');

// Modify the objects we need
addAlbumForm.addEventListener("submit", function (e) {
    
    // Prevent the form from submitting
    e.preventDefault();

    // Get form fields we need to get data from
    let inputTitle = document.getElementById("input-title")
    let inputGenre = document.getElementById("input-genre")
    let inputArtist = document.getElementById("input-artist")

    // Get the values from the form fields
    let titleVal = inputTitle.value;
    let genreVal = inputGenre.value;
    let artistVal = inputArtist.value;

    // Put our data we want to send in a javascript object
    let data = {
        title: titleVal,
        genre: genreVal,
        artistID: artistVal
    }
    
    // Setup our AJAX request
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "/add-album-ajax", true);
    xhttp.setRequestHeader("Content-type", "application/json");

    // Tell our AJAX request how to resolve
    xhttp.onreadystatechange = () => {
        if (xhttp.readyState == 4 && xhttp.status == 200) {

            // Add the new data to the table
            addRowToTable(xhttp.response);

            // Clear the input fields for another transaction
            inputTitle.value = '';
            inputGenre.value = '';
            inputArtist.value = '';
        }
        else if (xhttp.readyState == 4 && xhttp.status != 200) {
            console.log("There was an error with the input.")
        }
    }

    // Send the request and wait for the response
    xhttp.send(JSON.stringify(data));

})


addRowToTable = (data) => {

    // Get a reference to the current table on the page and clear it out.
    let currentTable = document.getElementById("album-table");

    // Get the location where we should insert the new row (end of table)
    let newRowIndex = currentTable.rows.length;

    // Get a reference to the new row from the database query (last object)
    let parsedData = JSON.parse(data);
    let newRow = parsedData[parsedData.length - 1]

    // Create a row and 4 cells
    let row = document.createElement("TR");
    let idCell = document.createElement("TD");
    let titleCell = document.createElement("TD");
    let genreCell = document.createElement("TD");
    let artistCell = document.createElement("TD");

    let deleteCell = document.createElement("TD");

    // Fill the cells with correct data
    idCell.innerText = newRow.albumID;
    titleCell.innerText = newRow.title;
    genreCell.innerText = newRow.genre;
    artistCell.innerText = newRow.artistID;

    deleteCell = document.createElement("button");
    deleteCell.innerHTML = "Delete";
    deleteCell.onclick = function(){
        deletePerson(newRow.albumID);
    };

    // Add the cells to the row 
    row.appendChild(idCell);
    row.appendChild(titleCell);
    row.appendChild(genreCell);
    row.appendChild(artistCell);
    row.appendChild(deleteCell);
    
    // Add a custom row attribute so the deleteRow function can find a newly added row
    row.setAttribute('data-value', newRow.albumID);

    // Add the row to the table
    currentTable.appendChild(row);


}
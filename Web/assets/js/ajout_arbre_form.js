'use strict';

const API = '../assets/php/request.php';

function trim_value(id) {
    const el = document.getElementById(id);
    return el ? el.value.trim() : '';
}

document.getElementById("tree-form").addEventListener("submit", function(e) {
    e.preventDefault();

    const form = e.target;
    const formData = new FormData(form);

    fetch(form.action, {
        method: "POST",
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log("Success:", data);

        alert("Arbre ajouté !");
        form.reset();
    })
    .catch(error => {
        console.error("Error:", error);
    });
});

// Données temporaires pour tester l'affichage
// Plus tard, elles seront remplacées par les données venant de PHP/MySQL
const arbres = [
    {
        espece: "Chêne",
        hauteur_totale: 12.5,
        hauteur_tronc: 4.2,
        diametre: 30,
        remarquable: "Non",
        latitude: 49.848,
        longitude: 3.287,
        etat: "En place",
        stade: "Adulte",
        port: "Libre",
        pied: "Terre"
    },
    {
        espece: "Érable",
        hauteur_totale: 8.3,
        hauteur_tronc: 3.1,
        diametre: 22,
        remarquable: "Oui",
        latitude: 49.846,
        longitude: 3.290,
        etat: "En place",
        stade: "Jeune",
        port: "Semi-libre",
        pied: "Gazon"
    }
];

afficherTableau(arbres);
afficherCarte(arbres);

function afficherTableau(arbres) {
    const tbody = document.getElementById("table-arbres");

    arbres.forEach(arbre => {
        const ligne = document.createElement("tr");

        ligne.innerHTML = `
            <td>${arbre.espece}</td>
            <td>${arbre.hauteur_totale}</td>
            <td>${arbre.hauteur_tronc}</td>
            <td>${arbre.diametre}</td>
            <td>${arbre.remarquable}</td>
            <td>${arbre.latitude}</td>
            <td>${arbre.longitude}</td>
            <td>${arbre.etat}</td>
            <td>${arbre.stade}</td>
            <td>${arbre.port}</td>
            <td>${arbre.pied}</td>
        `;

        tbody.appendChild(ligne);
    });
}

function afficherCarte(arbres) {
    const trace = {
        type: "scattermapbox",
        mode: "markers",
        lat: arbres.map(arbre => arbre.latitude),
        lon: arbres.map(arbre => arbre.longitude),
        text: arbres.map(arbre =>
            `${arbre.espece}<br>
            Hauteur : ${arbre.hauteur_totale} m<br>
            Diamètre : ${arbre.diametre} cm<br>
            État : ${arbre.etat}`
        ),
        marker: {
            size: 12
        }
    };

    const layout = {
        mapbox: {
            style: "open-street-map",
            center: {
                lat: 49.848,
                lon: 3.287
            },
            zoom: 12
        },
        margin: {
            t: 0,
            b: 0,
            l: 0,
            r: 0
        }
    };

    Plotly.newPlot("map", [trace], layout);
}
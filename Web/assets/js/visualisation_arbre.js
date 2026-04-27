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
    },
    {
        espece: "Chêne",
        hauteur_totale: 20.2,
        hauteur_tronc: 5.5,
        diametre: 28,
        remarquable: "Non",
        latitude: 49.847,
        longitude: 3.288,
        etat: "En place",
        stade: "Adulte",
        port: "Libre",
        pied: "Terre"
    }
];

let pageActuelle = 1;
let lignesParPage = 25;

initialiserPagination();
afficherTableauPagination();
afficherCarte(arbres);
initialiserPredictionClusters();

function afficherTableauPagination() {
    const tbody = document.getElementById("table-arbres");
    tbody.innerHTML = "";

    const debut = (pageActuelle - 1) * lignesParPage;
    const fin = debut + lignesParPage;
    const arbresPage = arbres.slice(debut, fin);

    arbresPage.forEach(arbre => {
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

    mettreAJourPagination();
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

function initialiserPagination() {
    const selectLimite = document.getElementById("limite-lignes");
    const btnPrecedent = document.getElementById("btn-precedent");
    const btnSuivant = document.getElementById("btn-suivant");

    selectLimite.addEventListener("change", function () {
        lignesParPage = Number(this.value);
        pageActuelle = 1;
        afficherTableauPagination();
    });

    btnPrecedent.addEventListener("click", function () {
        if (pageActuelle > 1) {
            pageActuelle--;
            afficherTableauPagination();
        }
    });

    btnSuivant.addEventListener("click", function () {
        const nombrePages = Math.ceil(arbres.length / lignesParPage);

        if (pageActuelle < nombrePages) {
            pageActuelle++;
            afficherTableauPagination();
        }
    });
}

function mettreAJourPagination() {
    const nombrePages = Math.ceil(arbres.length / lignesParPage);
    const pageInfo = document.getElementById("page-info");
    const btnPrecedent = document.getElementById("btn-precedent");
    const btnSuivant = document.getElementById("btn-suivant");

    pageInfo.textContent = `Page ${pageActuelle} / ${nombrePages}`;

    btnPrecedent.disabled = pageActuelle === 1;
    btnSuivant.disabled = pageActuelle === nombrePages;
}

function initialiserPredictionClusters() {
    const bouton = document.getElementById("btn-predire-clusters");
    const selectNbClusters = document.getElementById("nb-clusters");

    if (!bouton) return;

    bouton.addEventListener("click", function () {
        const nbClusters = selectNbClusters.value;

        fetch(`./script.php?action=predict_clusters&nb_clusters=${nbClusters}`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(arbres)
        })
        .then(response => response.json())
        .then(resultat => {
            if (!resultat.success) {
                alert("Erreur : " + resultat.error);
                return;
            }

            // Stockage temporaire
            sessionStorage.setItem("arbresAvecClusters", JSON.stringify(resultat.data));

            // Redirection vers la page de résultats
            window.location.href = "prediction_clusters.html";
        })
        .catch(error => {
            console.error(error);
            alert("Erreur serveur");
        });
    });
}
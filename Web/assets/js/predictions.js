
async function getClusters() {
    const nbClusters = document.getElementById("nb-clusters").value;

    console.log(nbClusters + " " + arbresData);

    const resultat = await fetch(`./script.php?action=predict_clusters&nb_clusters=${nbClusters}`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            data: arbresData
        })
    })
    .then(response => response.json())
    .then(resultat => {
        if (!resultat.success) {
            alert("Erreur : " + resultat.error);
            return;
        }
        
        console.log(resultat.data);
        
        return resultat.data;
    })
    .catch(error => {
        console.error(error);
        alert("Erreur serveur");
    });

    return resultat;
}



async function afficherCarteClusters() {

    const trt_info = document.getElementById('trt-info');

    trt_info.textContent = 'Traitement en cours...';

    const mapDiv = document.getElementById('map-clusters');

    if (!mapDiv || typeof Plotly === 'undefined') return;

    const arbres = await getClusters();

    const clusters = [...new Set(arbres.map(arbre => arbre.cluster))];
    
    const traces = clusters.map(cluster => {
        const arbresCluster = arbres.filter(arbre => arbre.cluster === cluster);
        
        return {
            type: "scattermapbox",
            mode: "markers",
            name: "Cluster " + cluster,
            lat: arbresCluster.map(arbre => cc49ToWgs84(arbre.latitude, arbre.longitude).lat),
            lon: arbresCluster.map(arbre => cc49ToWgs84(arbre.latitude, arbre.longitude).lon),
            text: arbresCluster.map(arbre =>
                `Cluster : ${arbre.cluster}<br><br>` +
                `ID : ${arbre.id_arbre}<br>` +
                `Hauteur : ${arbre.hauteur_totale} m<br>` +
                `Diamètre : ${arbre.diametre_tronc} cm`
            ),
            marker: {
                size: 12
            }
        };
    });
    
    const layout = {
        mapbox: {
            style: "open-street-map",
            center: cc49ToWgs84(arbres[0].latitude, arbres[0].longitude),
            zoom: 12
        },
        margin: {
            t: 0,
            b: 0,
            l: 0,
            r: 0
        }
    };

    console.log(traces);
    
    Plotly.newPlot("map-clusters", traces, layout);

    trt_info.textContent = '';
}

function getArbreSelect(id) {
    const arbre = arbresData.find(arbre => arbre.id_arbre === id);
    return arbre;
}

function predictAge() {
    const arbre = [getArbreSelect(document.querySelectorAll('.selection-arbre:checked')[0].value)];
    
    if(!arbre[0]) {
        alert("Aucun arbre selectionné");
        return;
    }

    fetch(`./script.php?action=predict_age`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            data: arbre
        })
    })
    .then(response => response.json())
    .then(resultat => {
        if (!resultat.success) {
            alert("Erreur : " + resultat.error);
            return;
        }
        
        alert("Age estimé : " + resultat.data[0].age_estim);
        
        return resultat.data;
    })
    .catch(error => {
        console.error(error);
        alert("Erreur serveur");
    });
}

function predictRisque() {
    const arbre = [getArbreSelect(document.querySelectorAll('.selection-arbre:checked')[0].value)];
    
    if(!arbre[0]) {
        alert("Aucun arbre selectionné");
        return;
    }

    fetch(`./script.php?action=predict_risque`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            data: arbre
        })
    })
    .then(response => response.json())
    .then(resultat => {
        if (!resultat.success) {
            alert("Erreur : " + resultat.error);
            return;
        }
        
        alert("Risque de déracinement : " + resultat.data[0].risque);
        
        return resultat.data;
    })
    .catch(error => {
        console.error(error);
        alert("Erreur serveur");
    });
}
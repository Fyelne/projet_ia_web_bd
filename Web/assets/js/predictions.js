
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
            lat: arbresCluster.map(arbre => arbre.latitude),
            lon: arbresCluster.map(arbre => arbre.longitude),
            text: arbresCluster.map(arbre =>
                `Cluster : ${arbre.cluster}<br><br>` +
                `${arbre.espece}<br>` +
                `Hauteur : ${arbre.hauteur_totale} m<br>` +
                `Diamètre : ${arbre.diametre} cm`
            ),
            marker: {
                size: 12
            }
        };
    });
    
    const layout = {
        mapbox: {
            style: "open-street-map",
            center: {
                lat: arbres[0].latitude,
                lon: arbres[0].longitude
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
    
    Plotly.newPlot("map-clusters", traces, layout);

    trt_info.textContent = '';
}

function predictAge() {
    const arbres = document.getElementById("arbres").value;
    
    fetch(`./script.php?action=predict_age&arbres=${arbres}`)
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
}
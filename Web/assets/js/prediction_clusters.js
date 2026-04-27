const arbresAvecClusters = JSON.parse(sessionStorage.getItem("arbresAvecClusters")) || [];

if (arbresAvecClusters.length === 0) {
    document.getElementById("map-clusters").innerHTML =
        "Aucune donnée disponible. Retournez sur la page Visualisation et cliquez sur Prédire les clusters.";
} else {
    afficherCarteClusters(arbresAvecClusters);
}

function afficherCarteClusters(arbres) {
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
                `${arbre.espece}<br>
                Cluster : ${arbre.cluster}<br>
                Hauteur : ${arbre.hauteur_totale} m<br>
                Diamètre : ${arbre.diametre} cm`
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
}
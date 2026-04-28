'use strict';

const API = '../assets/php/request.php';

let arbresData    = [];
let pageActuelle  = 1;
let lignesParPage = 25;

document.addEventListener('DOMContentLoaded', () => {
    initialiserPagination();
    fetch(API + '/arbres')
        .then(r => r.json())
        .then(data => {
            arbresData = data;
            afficherTableau();
            afficherCarte(arbresData);
        })
        .catch(err => console.error('Erreur:', err));
});



function cc49ToWgs84(lat_bdd, lon_bdd) {
    const x = lon_bdd;  // X easting  (colonne longitude en BDD)
    const y = lat_bdd;  // Y northing (colonne latitude  en BDD)

    const e  = 0.08181919104281579;
    const n  = 0.7569201448804344;
    const c  = 11595521.7127;
    const Xs = 1700000.0;
    const Ys = 13727767.5487;

    const dx = x - Xs;
    const dy = Ys - y;
    const r  = Math.sqrt(dx * dx + dy * dy);
    const g  = Math.atan2(dx, dy);

    const lon = 3.0 + (g / n) * (180 / Math.PI);

    let phi = 2 * Math.atan(Math.pow(c / r, 1 / n)) - Math.PI / 2;
    for (let i = 0; i < 20; i++) {
        const s    = e * Math.sin(phi);
        const next = 2 * Math.atan(Math.pow(c / r, 1 / n) * Math.pow((1 + s) / (1 - s), e / 2)) - Math.PI / 2;
        if (Math.abs(next - phi) < 1e-11) { phi = next; break; }
        phi = next;
    }

    return { lat: phi * 180 / Math.PI, lon };
}


function afficherCarte(arbres) {
    const mapDiv = document.getElementById('map');
    if (!mapDiv || typeof Plotly === 'undefined' || !arbres.length) return;

    const lats = [], lons = [], texts = [];

    arbres.forEach(a => {
        const lat_bdd = parseFloat(a.latitude);
        const lon_bdd = parseFloat(a.longitude);
        if (isNaN(lat_bdd) || isNaN(lon_bdd)) return;
        const wgs = cc49ToWgs84(lat_bdd, lon_bdd);
        lats.push(wgs.lat);
        lons.push(wgs.lon);
        texts.push(
            (a.nom_commun || '-') + '<br>' +
            'Hauteur : ' + (a.hauteur_totale || '-') + ' m<br>' +
            'Diametre : ' + (a.diametre_tronc || '-') + ' cm<br>' +
            'Etat : ' + (a.libelle_etat || '-')
        );
    });

    Plotly.newPlot('map', [{
        type: 'scattermapbox',
        mode: 'markers',
        lat: lats,
        lon: lons,
        text: texts,
        hovertemplate: '%{text}<extra></extra>',
        marker: { size: 12, color: '#3a8c52' }
    }], {
        mapbox: {
            style: 'open-street-map',
            center: { lat: 49.848, lon: 3.287 },
            zoom: 12
        },
        margin: { t: 0, b: 0, l: 0, r: 0 }
    });
}


function afficherTableau() {
    const tbody = document.getElementById('table-arbres');
    if (!tbody) return;

    if (!arbresData.length) {
        tbody.innerHTML = '<tr><td colspan="11" style="text-align:center;color:#999">Aucun arbre.</td></tr>';
        mettreAJourPagination();
        return;
    }

    const debut = (pageActuelle - 1) * lignesParPage;
    const page  = arbresData.slice(debut, debut + lignesParPage);

    tbody.innerHTML = page.map(a =>
        '<tr>' +
        '<td>' + (a.nom_commun || '') + '</td>' +
        '<td>' + (a.hauteur_totale  != null ? a.hauteur_totale  : '') + '</td>' +
        '<td>' + (a.hauteur_tronc   != null ? a.hauteur_tronc   : '') + '</td>' +
        '<td>' + (a.diametre_tronc  != null ? a.diametre_tronc  : '') + '</td>' +
        '<td>' + (a.est_remarquable == 1 ? '<span class="badge badge--gold">Oui</span>' : '') + '</td>' +
        '<td>' + (a.latitude  || '') + '</td>' +
        '<td>' + (a.longitude || '') + '</td>' +
        '<td><span class="badge">' + (a.libelle_etat  || '') + '</span></td>' +
        '<td>' + (a.libelle_stade || '') + '</td>' +
        '<td>' + (a.libelle_port  || '') + '</td>' +
        '<td>' + (a.libelle_pied  || '') + '</td>' +
        '</tr>'
    ).join('');

    mettreAJourPagination();
}


function initialiserPagination() {
    document.getElementById('limite-lignes')?.addEventListener('change', function () {
        lignesParPage = Number(this.value);
        pageActuelle  = 1;
        afficherTableau();
    });
    document.getElementById('btn-precedent')?.addEventListener('click', () => {
        if (pageActuelle > 1) { pageActuelle--; afficherTableau(); }
    });
    document.getElementById('btn-suivant')?.addEventListener('click', () => {
        if (pageActuelle < Math.ceil(arbresData.length / lignesParPage)) { pageActuelle++; afficherTableau(); }
    });
}

function mettreAJourPagination() {
    const total = Math.max(1, Math.ceil(arbresData.length / lignesParPage));
    if (document.getElementById('page-info'))     document.getElementById('page-info').textContent = 'Page ' + pageActuelle + ' / ' + total;
    if (document.getElementById('btn-precedent')) document.getElementById('btn-precedent').disabled = pageActuelle === 1;
    if (document.getElementById('btn-suivant'))   document.getElementById('btn-suivant').disabled   = pageActuelle === total;
}
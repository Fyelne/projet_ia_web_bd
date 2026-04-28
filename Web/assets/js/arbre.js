'use strict';

const API = '../assets/php/request.php';

document.addEventListener('DOMContentLoaded', () => {

  if (document.getElementById('form-arbre')) {
    bindForm();
  }

  if (document.getElementById('table-arbres')) {
    loadArbres();
  }

});

let refs = {
  espece: [],
  etat: [],
  stade: [],
  port: [],
  pied: []
};

function loadArbres() {
  fetch(API + '/arbres')
      .then(r => r.json())
      .then(displayArbres)
      .catch(err => console.error('GET error:', err));
}



function val(id)
{
  const el = document.getElementById(id);
  return el ? el.value.trim() : '';
}



function displayArbres(arbres)
{
  const tbody = document.getElementById('table-arbres');

  if (!tbody) {
    console.error('tbody #table-arbres introuvable');
    return;
  }

  if (!Array.isArray(arbres) || arbres.length === 0)
  {
    tbody.innerHTML = `
      <tr>
        <td colspan="11" style="text-align:center;color:#999">
          Aucun arbre enregistré.
        </td>
      </tr>
    `;
    return;
  }

  tbody.innerHTML = arbres.map(a => `
    <tr>
      <td>${a.nom_commun || a.nom_francais || '—'}</td>

      <td>${a.hauteur_totale ?? '—'}</td>
      <td>${a.hauteur_tronc ?? '—'}</td>
      <td>${a.diametre_tronc ?? '—'}</td>

      <td>
        ${a.est_remarquable == 1
      ? '<span class="badge badge--gold">Oui</span>'
      : '—'}
      </td>

      <td>${a.latitude ? Number(a.latitude).toFixed(4) : '—'}</td>
      <td>${a.longitude ? Number(a.longitude).toFixed(4) : '—'}</td>

      <td><span class="badge">${a.libelle_etat || '—'}</span></td>
      <td>${a.libelle_stade || '—'}</td>
      <td>${a.libelle_port || '—'}</td>
      <td>${a.libelle_pied || '—'}</td>
    </tr>
  `).join('');
}




function bindForm() {
  document.getElementById('form-arbre').addEventListener('submit', (e) =>
  {
    e.preventDefault();

    const data = new URLSearchParams();

    data.append('id_espece', val('f-espece'));
    data.append('latitude', val('f-lat'));
    data.append('longitude', val('f-lon'));

    data.append('libelle_etat', val('f-etat'));
    data.append('libelle_stade', val('f-stade'));
    data.append('libelle_port', val('f-port'));
    data.append('libelle_pied', val('f-pied'));

    data.append('hauteur_totale', val('f-haut-tot'));
    data.append('hauteur_tronc', val('f-haut-tronc'));
    data.append('diametre_tronc', val('f-diam'));

    data.append('est_remarquable',
        document.getElementById('f-remarquable').checked ? 1 : 0
    );

    fetch('../assets/php/request.php/arbres', {
      method: 'POST',
      body: data
    })
        .then(async r =>
        {
          const text = await r.text();
          console.log("RAW RESPONSE:", text);

          return JSON.parse(text);
        })
        .then(res =>
        {
          console.log('OK INSERT:', res);
          e.target.reset();
          //loadArbres();
        })
        .catch(err => console.error(err));
  });
}
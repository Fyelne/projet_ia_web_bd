'use strict';

const API = '../assets/php/request.php';

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('form-arbre'))
      addTree();
});

function trim_value(id) {
    const el = document.getElementById(id);
    return el ? el.value.trim() : '';
}

function addTree() {
  document.getElementById('form-arbre').addEventListener('submit', (e) => {
    e.preventDefault();

    const data = new URLSearchParams();
    data.append('latitude',       trim_value('f-lat'));
    data.append('longitude',      trim_value('f-lon'));
    data.append('id_espece',      val('f-nom-commun'));
    data.append('libelle_etat',   trim_value('f-etat'));
    data.append('libelle_stade',  trim_value('f-stade'));
    data.append('libelle_port',   trim_value('f-port'));
    data.append('libelle_pied',   trim_value('f-pied'));
    data.append('hauteur_totale', trim_value('f-haut-tot'));
    data.append('hauteur_tronc',  trim_value('f-haut-tronc'));
    data.append('diametre_tronc', trim_value('f-diam'));
    data.append('est_remarquable',
        document.getElementById('f-remarquable').checked ? 1 : 0
    );

    fetch(API + '/arbres', { method: 'POST', body: data })
        .then(async r => {
          const text = await r.text();
          console.log('RAW RESPONSE:', text);
          return JSON.parse(text);
        })
        .then(res => {
          console.log('OK INSERT:', res);
          e.target.reset();
        })
        .catch(err => console.error(err));
  });
}

'use strict';

const API = '../assets/php/request.php';

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('form-arbre'))
    bindForm();
});

function val(id) {
  const el = document.getElementById(id);
  return el ? el.value.trim() : '';
}

function bindForm() {
  document.getElementById('form-arbre').addEventListener('submit', (e) => {
    e.preventDefault();

    const data = new URLSearchParams();
    data.append('latitude',       val('f-lat'));
    data.append('longitude',      val('f-lon'));
    data.append('id_espece',      val('f-nom-commun'));   // PHP attend id_espece
    data.append('libelle_etat',   val('f-etat'));         // PHP attend le libelle
    data.append('libelle_stade',  val('f-stade'));
    data.append('libelle_port',   val('f-port'));
    data.append('libelle_pied',   val('f-pied'));
    data.append('hauteur_totale', val('f-haut-tot'));
    data.append('hauteur_tronc',  val('f-haut-tronc'));
    data.append('diametre_tronc', val('f-diam'));
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

<?php
require_once('constants.php');

//------------------------------------------------------------------------------
//--- dbConnect ----------------------------------------------------------------
//------------------------------------------------------------------------------
function dbConnect()
{
  try
  {
    $db = new PDO(
      'mysql:host=' . DB_SERVER . ';dbname=' . DB_NAME . ';charset=utf8',
      DB_USER,
      DB_PASSWORD
    );

    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  }
  catch (PDOException $e)
  {
    error_log('Connection error: '.$e->getMessage());
    return false;
  }
  return $db;
}


function dbGetArbres($db)
{
  try
  {
    $stmt = $db->query('
        SELECT
          a.id_arbre,
          a.hauteur_totale,
          a.hauteur_tronc,
          a.diametre_tronc,
          a.est_remarquable,
          a.latitude,
          a.longitude,
          a.date_derniere_mesure,

          et.libelle_etat,
          st.libelle_stade,
          po.libelle_port,
          pi.libelle_pied,
          e.nom_commun,
          e.nom_latin

        FROM arbre a

        LEFT JOIN espece e ON e.id_espece = a.id_espece
        LEFT JOIN etat_arbre et ON et.id_etat = a.id_etat
        LEFT JOIN stade_developpement st ON st.id_stade = a.id_stade
        LEFT JOIN type_port po ON po.id_port = a.id_port
        LEFT JOIN type_pied pi ON pi.id_pied = a.id_pied

        ORDER BY a.id_arbre DESC;
    ');
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }
  catch (PDOException $e)
  {
    error_log('GetArbres error: '.$e->getMessage());
    return false;
  }
}


function dbAddArbre($db, $data)
{

  $id_espece = getOrCreateEspeceId($db, $data['id_espece']);


  $id_etat  = getIdFromLibelle($db, 'etat_arbre', 'id_etat', 'libelle_etat', $data['libelle_etat']);
  $id_stade = getIdFromLibelle($db, 'stade_developpement', 'id_stade', 'libelle_stade', $data['libelle_stade']);
  $id_port  = getIdFromLibelle($db, 'type_port', 'id_port', 'libelle_port', $data['libelle_port']);
  $id_pied  = getIdFromLibelle($db, 'type_pied', 'id_pied', 'libelle_pied', $data['libelle_pied']);

  try
  {
    $stmt = $db->prepare('
       INSERT INTO arbre
       (hauteur_totale, hauteur_tronc, diametre_tronc, est_remarquable,
        latitude, longitude, date_derniere_mesure,
        id_espece, id_etat, id_stade, id_port, id_pied)
       VALUES
       (:hauteur_totale, :hauteur_tronc, :diametre_tronc, :est_remarquable,
        :latitude, :longitude, :date_derniere_mesure,
        :id_espece, :id_etat, :id_stade, :id_port, :id_pied)
    ');

    $ok = $stmt->execute([
        ':hauteur_totale' => $data['hauteur_totale'] !== '' ? $data['hauteur_totale'] : null,
        ':hauteur_tronc'  => $data['hauteur_tronc'] !== '' ? $data['hauteur_tronc'] : null,
        ':diametre_tronc' => $data['diametre_tronc'] !== '' ? $data['diametre_tronc'] : null,

        ':est_remarquable' => !empty($data['est_remarquable']) ? 1 : 0,

        ':latitude'  => $data['latitude'],
        ':longitude' => $data['longitude'],

        ':date_derniere_mesure' => null,

        ':id_espece' => $id_espece,
        ':id_etat'   => $id_etat,
        ':id_stade'  => $id_stade,
        ':id_port'   => $id_port,
        ':id_pied'   => $id_pied,
    ]);

    if (!$ok)
    {
        error_log(print_r($stmt->errorInfo(), true));
        return false;
    }

    return true;
  }
  catch (PDOException $e)
  {
    error_log($e->getMessage());
    return false;
  }
}


// link table espèce-arbre
function getOrCreateEspeceId($db, $nom)
{
  $nom = ucfirst(strtolower(trim($nom)));

  $stmt = $db->prepare("SELECT id_espece FROM espece WHERE nom_commun = ?");
  $stmt->execute([$nom]);

  $id = $stmt->fetchColumn();

  if ($id) return $id;

  $stmt = $db->prepare("INSERT INTO espece (nom_commun) VALUES (?)");
  $stmt->execute([$nom]);

  return $db->lastInsertId();
}

function getIdFromLibelle($db, $table, $colId, $colLibelle, $value)
{
    $stmt = $db->prepare("
        SELECT $colId
        FROM $table
        WHERE LOWER($colLibelle) = LOWER(:val)
        LIMIT 1
    ");

    $stmt->execute([':val' => $value]);
    $id = $stmt->fetchColumn();

    if ($id === false) {
        error_log("Valeur introuvable dans $table: $value");
        return null;
    }

    return (int)$id;
}

?>

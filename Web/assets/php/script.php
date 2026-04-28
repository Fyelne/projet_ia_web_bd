<?php

/**
 * Fonction pour exécuter un script Python
 * @param string $scriptName Nom du fichier dans le dossier py_scripts
 * @param array $args Tableau associatif des arguments (--key => value)
 * @return string Résultat du script
 */
function runPythonScript($scriptName, $args = []) {
    $scriptPath = __DIR__ . "/../assets/py_scripts/" . $scriptName;
    $pythonPath = "/usr/bin/python";

    $command = escapeshellarg($pythonPath) . " " . escapeshellarg($scriptPath);

    foreach ($args as $key => $value) {
        $command .= " " . escapeshellarg($key) . " " . escapeshellarg($value);
    }

    return shell_exec($command . " 2>&1");
}

/**
 * Envoie une réponse JSON au front
 * @param bool $success Résultat de l'opération
 * @param mixed $data Données
 * @param mixed $error Message d'erreur
 */
function sendJsonResponse($success, $data = null, $error = null) {
    header("Content-Type: application/json; charset=utf-8");

    echo json_encode([
        "success" => $success,
        "data" => $data,
        "error" => $error
    ]);

    exit;
}

/**
 * Prédiction des clusters
 */
if (isset($_GET["action"])) {
    $rawInput = file_get_contents("php://input");
    $arbres = json_decode($rawInput, true);
    if (!is_array($arbres)) {
        sendJsonResponse(false, null, "Les données envoyées ne sont pas valides.");
    }

    if($_GET["action"] === "predict_clusters"){
        $nbClusters = isset($_GET["nb_clusters"]) ? $_GET["nb_clusters"] : "3";
        $resultats = [];

        foreach ($arbres as $arbre) {
            if (!isset($arbre["hauteur_totale"])) {
                $arbre["cluster"] = "Non calculé";
                $resultats[] = $arbre;
                continue;
            }

            $sortiePython = runPythonScript("client1.py", [
                "--haut_tot" => $arbre["hauteur_totale"],
                "--nb_clusters" => $nbClusters
            ]);

            $arbre["cluster"] = trim($sortiePython);
            $resultats[] = $arbre;
        }

        sendJsonResponse(true, $resultats, null);
    } else if ($_GET["action"] === "predict_age") {
        $arbre = $arbres[0];
        $resultats = [];

        $sortiePython = runPythonScript("client2.py", [
            "--haut_tot" => $arbre["hauteur_totale"],
            "--haut_tronc" => $arbre["hauteur_tronc"],
            "--tronc_diam" => $arbre["diametre_tronc"],
            "--fk_stadedev" => $arbre["libelle_stade"],
            "--nomlatin" => $arbre["nom_commun"]
        ]);

        $arbre["age_estim"] = trim($sortiePython);
        $resultats[] = $arbre;
        sendJsonResponse(true, $resultats, null);
    } else if ($_GET["action"] === "predict_risque") {
        $arbre = $arbres[0];
        $resultats = [];
        $sortiePython = runPythonScript("client3.py", [
                "--haut_tot" => $arbre["hauteur_totale"],
                "--haut_tronc" => $arbre["hauteur_tronc"],
                "--tronc_diam" => $arbre["diametre_tronc"], // Assuming the diameter is also provided
                "--age_estim" => $arbre["age_estim"],
                "--fk_port" => $arbre["libelle_port"],
                "--fk_pied" => $arbre["libelle_pied"],
                "--nomfrancais" => $arbre["nom_commun"],
                "--clc_quartier" => "Quartier Remicourt",
                "--clc_secteur" => "Parc des Champs-Elysées",
                "--x" => $arbre["latitude"],
                "--y" => $arbre["longitude"],
                "--seuil" => "0.2" 
        ]);

        $arbre["risque"] = trim($sortiePython);
        $resultats[] = $arbre;
        sendJsonResponse(true, $resultats, null);
    }
}

echo "API running...";

?>
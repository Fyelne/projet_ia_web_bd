<?php

/**
 * Fonction pour exécuter un script Python
 * @param string $scriptName Nom du fichier dans le dossier py_scripts
 * @param array $args Tableau associatif des arguments (--key => value)
 * @return string Résultat du script
 */
function runPythonScript($scriptName, $args = []) {
    $scriptPath = __DIR__ . "/../assets/py_scripts/" . $scriptName;
    $pythonPath = __DIR__ . "/../../venv/bin/python";

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
if (isset($_GET["action"]) && $_GET["action"] === "predict_clusters") {
    $rawInput = file_get_contents("php://input");
    $arbres = json_decode($rawInput, true);

    if (!is_array($arbres)) {
        sendJsonResponse(false, null, "Les données envoyées ne sont pas valides.");
    }

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
}

echo "API running...";

?>

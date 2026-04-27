<?php

/**
 * Fonction pour exécuter un script Python.
 * Le script Python doit se trouver dans Web/assets/py_scripts/.
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
 * Envoie une réponse JSON au JavaScript.
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
 * Fonctionnalité 4 : prédiction des clusters.
 * Le front-end envoie les arbres en JSON.
 * PHP appelle client1.py pour chaque arbre.
 * PHP renvoie les arbres avec un champ cluster.
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

// Message simple si le fichier est ouvert directement dans le navigateur.
echo "script.php fonctionne. Utilisez script.php?action=predict_clusters pour lancer la prédiction des clusters.";

?>

<?php

/**
 * Fonction pour exécuter un script Python
 * @param string $scriptName Nom du fichier dans le dossier py_scripts
 * @param array $args Tableau associatif des arguments (--key => value)
 * @return string Résultat du script
 */
function runPythonScript($scriptName, $args = []) {
    $scriptPath = __DIR__ . "/../assets/py_scripts/" . $scriptName;
    
    // Construction de la commande
    $command = __DIR__ . "/../../venv/bin/python " . escapeshellarg($scriptPath);
    
    foreach ($args as $key => $value) {
        $command .= " " . escapeshellarg($key) . " " . escapeshellarg($value);
    }

    // Exécution de la commande
    $output = shell_exec($command . " 2>&1");
    return $output;
}

echo "--- EXEMPLES D'UTILISATION ---<br>";

$res1 = runPythonScript("client1.py", [
    "--haut_tot" => "12.0",
    "--nb_clusters" => "3"
]);
echo "Résultat Client 1 : " . $res1 . "<br>";

$res2 = runPythonScript("client2.py", [
    "--haut_tot" => "12.0",
    "--haut_tronc" => "2.5",
    "--tronc_diam" => "150",
    "--fk_stadedev" => "adulte"
]);
echo "Résultat Script 2 : " . $res2 . "<br>";

$res3 = runPythonScript("client3.py", [
    "--haut_tot" => "2.3",
    "--haut_tronc" => "1.1",
    "--tronc_diam" => "4.6",
    "--age_estim" => "3.4",
    "--fk_port" => "semi libre",
    "--fk_pied" => "gazon",
    "--nomfrancais" => "POPALB",
    "--clc_quartier" => "HARLY",
    "--clc_secteur" => "Rue Laplace"
]);
echo "Résultat Script 3 : " . $res3;

?>
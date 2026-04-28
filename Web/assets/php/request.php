<?php

require_once('database.php');

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

$db = dbConnect();
if (!$db) { http_response_code(503); exit; }

$path     = isset($_SERVER['PATH_INFO']) ? trim($_SERVER['PATH_INFO'], '/') : '';
$method   = $_SERVER['REQUEST_METHOD'];

if ($path === 'arbres') {
  if ($method === 'GET'){
    sendJson(dbGetArbres($db));
  } elseif ($method === 'POST') {
      header('Content-Type: application/json; charset=utf-8');

      $ok = dbAddArbre($db, $_POST);

      if (!$ok)
      {
          http_response_code(400);
          echo json_encode(['error' => 'Insert failed']);
          exit;
      }

      http_response_code(201);
      echo json_encode(['success' => true]);
      exit;
  }
}

http_response_code(404);
exit;

function sendJson($data) {
  header('Content-Type: application/json; charset=utf-8');
  echo json_encode($data);
  exit;
}
?>

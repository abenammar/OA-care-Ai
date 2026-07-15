<?php

declare(strict_types=1);

require dirname(__DIR__) . '/bootstrap.php';

use OACare\Config;
use OACare\Router;

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: ' . Config::get('CORS_ALLOWED_ORIGIN', '*'));
header('Access-Control-Allow-Headers: Content-Type, X-Ingest-Key');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$router = new Router();
require dirname(__DIR__) . '/routes.php';

try {
    $router->dispatch($_SERVER['REQUEST_METHOD'], parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?: '/');
} catch (Throwable $e) {
    $debug = filter_var(Config::get('APP_DEBUG', 'false'), FILTER_VALIDATE_BOOLEAN);
    error_log($e->__toString());
    http_response_code(500);
    echo json_encode([
        'error' => 'Internal server error',
        'detail' => $debug ? $e->getMessage() : null,
    ], JSON_UNESCAPED_SLASHES);
}

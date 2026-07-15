<?php

declare(strict_types=1);

spl_autoload_register(function (string $class): void {
    $prefix = 'OACare\\';
    if (!str_starts_with($class, $prefix)) {
        return;
    }

    $relative = substr($class, strlen($prefix));
    $path = __DIR__ . '/src/' . str_replace('\\', '/', $relative) . '.php';
    if (is_file($path)) {
        require $path;
    }
});

use OACare\Config;
use OACare\Database;

Config::load(dirname(__DIR__) . '/.env');
Database::configure([
    'host' => Config::get('DB_HOST', '127.0.0.1'),
    'port' => Config::get('DB_PORT', '3306'),
    'name' => Config::get('DB_NAME', 'oa_care'),
    'user' => Config::get('DB_USER', 'oa_user'),
    'password' => Config::get('DB_PASSWORD', 'oa_password'),
]);

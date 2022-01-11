#!/usr/bin/env php
<?php

declare(strict_types=1);

use Swoole\Http\Request;
use Swoole\Http\Response;
use Swoole\Http\Server;
use OpenSwoole\Examples\HelloWorld;

require_once(__DIR__ . DIRECTORY_SEPARATOR . "vendor" . DIRECTORY_SEPARATOR . "autoload.php");

$http = new Server("0.0.0.0", 9501);

$http->on(
    "start",
    function (Server $http) {
        echo "Swoole HTTP server is started.\n";
    }
);
$http->on(
    "request",
    function (Request $request, Response $response) {

        $helloWorld = new HelloWorld();

        $stringToRespond = "Hello, World!\n" .
            $helloWorld->firstEverString() . "\n";

        $response->end($stringToRespond);
    }
);

$http->start();

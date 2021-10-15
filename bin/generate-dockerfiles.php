#!/usr/bin/env php
<?php

/**
 * How to use the script:
 *    ./bin/generate-dockerfiles.php [swoole-version|swoole-branch]
 *    e.g.,
 *    ./bin/generate-dockerfiles.php 4.7.1
 *    ./bin/generate-dockerfiles.php latest
 * Above command will have dockerfiles created for Open Swoole 4.7.1 under folder images/dockerfiles/.
 */

declare(strict_types=1);

use Swoole\Docker\Dockerfile;

require_once dirname(__DIR__) . '/vendor/autoload.php';

(new Dockerfile($argv[1]))->render();

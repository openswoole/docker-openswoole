For this example, we have following Swoole extensions installed in the image created:

* [async](https://github.com/openswoole/ext-async)
* [orm](https://github.com/openswoole/ext-orm)
* [postgresql](https://github.com/openswoole/ext-postgresql)
* [serialize](https://github.com/openswoole/ext-serialize)

You can run following command to create the image and see which Swoole extensions are enabled:

```bash
docker run --rm -t $(docker build -q .) bash -c "php -m" | grep openswoole
```

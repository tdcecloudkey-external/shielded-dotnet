# Prepare image to run

## Prequisites
* Docker
* Git
* Ubuntu 22.04 (WSL can be used)

## Prepare raw image
```console
docker build -f ./dotnetapp-8-runtime.containerfile . -t dotnetapp-8-runtime:1.0.0
```


## GSC

There's been prepared 2 flavors of gsc templates, with or without Gramine trace logs.

```console
git clone --branch v1.8 https://github.com/gramineproject/gsc.git
cd gsc
pip3 install docker jinja2 tomli tomli-w pyyaml
./gsc build -c ./config.yaml.template dotnetapp-8-runtime:1.0.0 ../dotnetapp-8-runtime.gsc.notrace.template

./gsc sign-image -c ./config.yaml.template dotnetapp-8-runtime:1.0.0 ../enclave-key.pem
```
## Tag and push (only with package write acess)

docker tag gsc-dotnetapp-8-runtime:1.0.0 ghcr.io/tdcecloudkey-external/shielded-dotnet/dotnetapp-8-runtime-confidential-notrace:1.0.0

docker push ghcr.io/tdcecloudkey-external/shielded-dotnet/dotnetapp-8-runtime-confidential-notrace:1.0.0
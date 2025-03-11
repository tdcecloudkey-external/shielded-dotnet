# Prepare image to run

## Prequisites
* Docker
* Git
* Ubuntu 22.04 (WSL can be used)

## Prepare raw image
```console
docker build --pull -f Dockerfile.ubuntu -t dotnetapp-9-ubuntu:1.0.0 'https://github.com/dotnet/dotnet-docker.git#:samples/dotnetapp'
docker run --rm dotnetapp
```


## GSC

There's been prepared 2 flavors of gsc templates, with or without Gramine trace logs.

```console
git clone --branch v1.8 https://github.com/gramineproject/gsc.git
cd gsc
pip3 install docker jinja2 tomli tomli-w pyyaml
./gsc build -c ./config.yaml.template dotnetapp-9-ubuntu:1.0.0 ../dotnet9/dotnetapp-9-runtime.gsc.notrace.template

./gsc sign-image -c ./config.yaml.template dotnetapp-9-runtime:1.0.0 ../enclave-key.pem
```
## Tag and push (only with package write acess)

docker tag gsc-dotnetapp-9-ubuntu:1.0.0 ghcr.io/tdcecloudkey-external/shielded-dotnet/dotnetapp-9-ubuntu-confidential-notrace:1.0.0

docker push ghcr.io/tdcecloudkey-external/shielded-dotnet/dotnetapp-9-ubuntu-confidential-notrace:1.0.0
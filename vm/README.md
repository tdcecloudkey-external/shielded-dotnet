
ssh to AZ VM with EPC


```console
docker run --device=/dev/sgx_enclave \
   -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
   ghcr.io/nmwael/shielded-dotnet/dotnetapp-8-runtime-confidential:1.0.0 2>&1 | tee -a dotnetapp-8-runtime-confidential.log
```

check for expected application output
```console
grep 'TotalAvailableMemoryBytes' dotnetapp-8-runtime-confidential.log
```

if above prints "TotalAvailableMemoryBytes: 209715200 (200.00 MiB)", execution was sucessfull.

As issue only shows itself sporadicly copy the loopwait.sh (remember chmod +x) to the vm and execute it by doing so
```console
./loopwait.sh 0 50 ghcr.io/nmwael/shielded-dotnet/dotnetapp-8-runtime-confidential:1.0.0
```
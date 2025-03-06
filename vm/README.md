## Pre requsites
* Azure VM (Standard DC2ds v3)
* shell access
* Docker installed

Detail snippets from ArmExplorerBlade

```json
"hardwareProfile": {
            "vmSize": "Standard_DC2ds_v3"
        }
```
```json        
"imageReference": {
        "publisher": "canonical",
        "offer": "0001-com-ubuntu-server-jammy",
        "sku": "22_04-lts-gen2",
        "version": "latest",
        "exactVersion": "22.04.202501080"
    }
```



## Enable THIM
https://learn.microsoft.com/en-us/azure/security/fundamentals/trusted-hardware-identity-management#on-linux
https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/qcnl/linux/sgx_default_qcnl_azure.conf'



# Reproducing steps

## Validate configuration

Run below
```console
docker run --device=/dev/sgx_enclave \
   -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
   ghcr.io/tdcecloudkey-external/shielded-dotnet/dotnetapp-8-runtime-confidential-notrace:1.0.0 2>&1 | tee -a dotnetapp-8-runtime-confidential.log
```

check for expected application output
```console
grep 'TotalAvailableMemoryBytes' dotnetapp-8-runtime-confidential.log
```
if above prints "TotalAvailableMemoryBytes: 209715200 (200.00 MiB)", execution was sucessfull.

## Reproduce memory allocation issue

As issue only shows itself sporadicly simultanious executions and multiple iterations are needed. copy the loopwait.sh (remember chmod +x) to the vm.

In 3 seperate sessions run
```console
./loopwait.sh 0 50 ghcr.io/tdcecloudkey-external/shielded-dotnet/dotnetapp-8-runtime-confidential-notrace:1.0.0
```

When all sessions are finished

check for expected application output
```console
grep 'TotalAvailableMemoryBytes' loop_log_*.log | wc -l
```

As we've run 3 sessions the expected word count is 150 as it should match number of loop log files times number of iterations.

check for each loop log file for errors and sucesses, if number deviate from above formula.

```console
grep 'GC heap initialization' loop_log_20250305_105652.log | wc -l
grep 'TotalAvailableMemoryBytes' loop_log_20250305_105652.log | wc -l
```
Total count should match number of iterations, if not you've encountered a potential issue variance.

## Notes

As the Standard_DC2ds_v3 are capable of running a little more than 8Gb of enclaves and the small sample application only requires 2Gb enclave sizes. Running 3 simulatinous loops should be well below the limit.
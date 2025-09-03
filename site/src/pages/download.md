---
permalink: /download
sidebar: false
---
# Download

The followings are Apache Incubator releases for Teaclave projects - Teaclave,
Teaclave SGX SDK, Teaclave TrustZone SDK, and Teaclave Java TEE SDK. These
source archives are generated from tagged releases. You can verify your download
by following these
[procedures](https://www.apache.org/info/verification.html) and using these
[KEYS](https://downloads.apache.org/teaclave/KEYS).

## Apache Teaclave™ Ecosystem Releases

The Apache Teaclave™ ecosystem consists of several independently released SDKs and components, 
with each sub-project targeting a specific trusted execution environment (TEE).
Each SDK evolves independently to best support its respective platform and use cases.

### Teaclave TrustZone SDK

| Latest Version | Source Code               | PGP/SHA | Release Notes |
|:-------:|:-------------------------:|:----:|:-------:|
| 0.5.0   | [apache-teaclave-trustzone-sdk-0.5.0-incubating.tar.gz](https://www.apache.org/dyn/closer.lua/incubator/teaclave/trustzone-sdk-0.5.0/apache-teaclave-trustzone-sdk-0.5.0-incubating.tar.gz?action=download) | [asc](https://downloads.apache.org/incubator/teaclave/trustzone-sdk-0.5.0/apache-teaclave-trustzone-sdk-0.5.0-incubating.tar.gz.asc), [sha512](https://downloads.apache.org/incubator/teaclave/trustzone-sdk-0.5.0/apache-teaclave-trustzone-sdk-0.5.0-incubating.tar.gz.sha512) | [notes](https://github.com/apache/teaclave-trustzone-sdk/releases/tag/v0.5.0) |

### Teaclave SGX SDK

| Latest Version | Source Code               | PGP/SHA | Release Notes |
|:-------:|:-------------------------:|:----:|:-------:|
| - | - | - | - |

*Note: Teaclave SGX SDK releases are currently in development. Please check the [GitHub repository](https://github.com/apache/teaclave-sgx-sdk) for the latest updates.*

### Teaclave Java TEE SDK

| Latest Version | Source Code               | PGP/SHA | Release Notes |
|:-------:|:-------------------------:|:----:|:-------:|
| 0.1.0 | [apache-teaclave-java-tee-sdk-0.1.0-incubating.tar.gz](https://www.apache.org/dyn/closer.lua/incubator/teaclave/java-tee-sdk-v0.1.0/apache-teaclave-java-tee-sdk-0.1.0-incubating.tar.gz?action=download) | [asc](https://downloads.apache.org/incubator/teaclave/java-tee-sdk-v0.1.0/apache-teaclave-java-tee-sdk-0.1.0-incubating.tar.gz.asc), [sha512](https://downloads.apache.org/incubator/teaclave/java-tee-sdk-v0.1.0/apache-teaclave-java-tee-sdk-0.1.0-incubating.tar.gz.sha512) | [notes](https://github.com/apache/teaclave-java-tee-sdk/releases/tag/v0.1.0) |

## Teaclave FaaS (legacy)

| Latest Version | Source Code               | PGP/SHA | Release Notes |
|:-------:|:-------------------------:|:-------:|:-------------:|
| 0.5.1   | [apache-teaclave-0.5.1-incubating.tar.gz](https://www.apache.org/dyn/closer.lua/incubator/teaclave/0.5.1/apache-teaclave-0.5.1-incubating.tar.gz?action=download)| [asc](https://downloads.apache.org/incubator/teaclave/0.5.1/apache-teaclave-0.5.1-incubating.tar.gz.asc), [sha512](https://downloads.apache.org/incubator/teaclave/0.5.1/apache-teaclave-0.5.1-incubating.tar.gz.sha512) | [notes](https://github.com/apache/teaclave/releases/tag/v0.5.1) |

## Verify the Integrity of the Files

::: tip NOTE
It is essential that you verify the integrity of the downloaded file using the
PGP signature (`.asc` file) or a hash (`.md5` or `.sha*` file). Please read
[Verifying Apache Software Foundation Releases](https://www.apache.org/info/verification.html)
for more information on why you should verify our releases.
:::

The PGP signature can be verified using PGP or GPG. First download the
[KEYS](https://downloads.apache.org/teaclave/KEYS) as
well as the asc signature file for the relevant distribution. Make sure you get
these files from the main distribution site, rather than from a mirror. Then
verify the signatures using

```
$ gpg --import KEYS
$ gpg --verify downloaded_file.asc downloaded_file
```
or
```
$ pgpk -a KEYS
$ pgpv downloaded_file.asc
```
or
```
$ pgp -ka KEYS
$ pgp downloaded_file.asc
```
Alternatively, you can verify the hash on the file.

Hashes can be calculated using GPG:

```
$ gpg --print-md SHA256 downloaded_file
```

The output should be compared with the contents of the SHA256 file. Similarly
for other hashes (SHA512, SHA1, MD5 etc) which may be provided.

Windows 7 and later systems should all now have `certUtil`:

```
$ certUtil -hashfile pathToFileToCheck
```

HashAlgorithm choices: `MD2`, `MD4`, `MD5`, `SHA1`, `SHA256`, `SHA384`, `SHA512`

Unix-like systems (and macOS) will have a utility called `md5`, `md5sum` or `shasum`

---
title: Announcing Apache Teaclave™ TrustZone SDK 0.10.0
date: 2026-10-29
author: Zehui Chen
---

On behalf of the Teaclave community, I am happy to announce the release of
Teaclave TrustZone SDK 0.10.0.

Teaclave empowers developers to build memory-safe Trusted Applications across
diverse confidential computing platforms, including Intel SGX and Arm TrustZone.
Apache Teaclave TrustZone SDK, a subproject of Apache Teaclave, is based on the
OP-TEE project, a widely used open-source TrustZone OS.

This release tracks OP-TEE 4.11.0 and focuses on safer, more ergonomic APIs:
typed TA parameters, copy-based memory references, consolidated error handling,
and an improved `cargo-optee` build experience.

Highlights in 0.10.0:

- Synced with OP-TEE 4.11.0, including its security fixes for this cycle.
- Exposed PBKDF2-HMAC key derivation and the password object type.
- Introduced a typed parameter API and copy-based memref access, with migration
  guides under `docs/`.
- Improved `cargo-optee`: UUIDs are parsed from the unsigned ELF, and standard
  OP-TEE environment paths and cross-compilation settings are supported.
- Added a security model description and an AI development guide.

Some of these changes are breaking; please read the upgrade notes before
migrating existing TA/CA code.

For more details, please refer to our release notes:
https://github.com/apache/teaclave-trustzone-sdk/releases/tag/v0.10.0

## Download

You can download the release from the
[download](https://teaclave.apache.org/download/) page. Also, please checkout
our [repository](https://github.com/apache/teaclave-trustzone-sdk) hosted on
GitHub.

## Contributing

Teaclave TrustZone SDK is under the Apache License v2 and open source in The
Apache Way. We aim to create a project that is maintained and owned by the
community. All kinds of contributions are welcome. Thanks to our contributors.

---
permalink: /overview
---

# Apache Teaclave™ : Empowering Memory-Safe Development for TEEs

Welcome to the official website of Teaclave, an open-source initiative under the [Apache Software Foundation](https://www.apache.org/). Teaclave empowers developers to build memory-safe Trusted Applications across diverse confidential computing platforms, including Intel SGX and Arm TrustZone.

Originally designed as a general-purpose secure computing framework, Teaclave has naturally evolved into a growing ecosystem of developer-friendly SDKs, enabling direct development of custom Trusted Applications. This evolution is driven by strong community adoption and contributions.

This page serves as an overview and entry point to the entire Teaclave ecosystem. Use it as a guide to explore SDKs, documentation, and useful developer resources for building secure and efficient TEE-based applications.

---

## 🔧 The Apache Teaclave™ Ecosystem

The Teaclave ecosystem consists of several independently maintained repositories, each targeting a specific Trusted Execution Environment (TEE). These SDKs and supporting libraries provide essential tooling for building secure applications in constrained environments using modern memory-safe languages like Rust.

---

### 🔐 [Teaclave TrustZone SDK](https://github.com/apache/teaclave-trustzone-sdk/)

The Teaclave TrustZone SDK is a Rust-based development toolkit for building Trusted Applications (TAs) on Arm platforms using the open-source [OP-TEE](https://optee.readthedocs.io/) ecosystem. As the [**officially recommended Rust SDK for OP-TEE**](https://optee.readthedocs.io/en/latest/building/optee_with_rust.html), it enables developers to leverage the Rust standard library (`std`) in the secure world—something rarely possible in embedded TEE development.

This SDK adheres to the GlobalPlatform TEE specifications, ensuring broad compatibility. It provides ergonomic, memory-safe APIs for both the normal world and the secure world, significantly reducing the risk of low-level memory vulnerabilities. A ready-to-use QEMU-based emulator environment is also included, allowing developers to rapidly prototype and test Trusted Applications entirely in Docker containers.

**📄 Quick Navigation Links**
- [📘 Teaclave TrustZone Docs](/trustzone-sdk-docs)
- [📚 API Doc For (Normal World) Host Application](https://teaclave.apache.org/api-docs/trustzone-sdk/optee_teec/)
- [📚 API Doc For (Secure World) Trust Application](https://teaclave.apache.org/api-docs/trustzone-sdk/optee_utee/)
- [🚀 Quick Start: TA Development on QEMU](/trustzone-sdk-docs/emulate-and-dev-in-docker.md)
- [🚀 Overview of OP-TEE Rust Examples](/trustzone-sdk-docs/overview-of-optee-rust-examples)
- [🔗 OP-TEE with Rust (using Teaclave TrustZone SDK)](https://optee.readthedocs.io/en/latest/building/optee_with_rust.html)

---

### 🔐 [Teaclave SGX SDK](https://github.com/apache/teaclave-sgx-sdk/)

The Teaclave SGX SDK brings memory-safe Rust programming to Intel SGX, enabling the development of secure enclave applications that benefit from Rust’s strong safety guarantees. It supports writing both enclaves and untrusted host applications in Rust, encouraging consistent use of modern Rust idioms across the entire trusted-untrusted boundary.

The SDK offers a complete SGX-compatible runtime and tooling suite, bridging the gap between native SGX support and idiomatic Rust development. It allows developers to adopt Rust’s ownership model, type system, and concurrency safety even within the limitations of SGX.

**📄 Quick Navigation Links**

- [📘 Teaclave SGX Docs](/sgx-sdk-docs/)
- [📚 SGX Enclave API Doc](https://teaclave.apache.org/api-docs/sgx-sdk/)
- [🚀 Setting up your SGX Development Environment](/sgx-sdk-docs/environment-setup)

---

### 🔐 [Teaclave](https://github.com/apache/teaclave/)

The main Teaclave repository serves as the central landing page and coordination hub for the entire Teaclave ecosystem. Originally hosting the Teaclave FaaS framework, this repository has evolved to focus on SDK showcases, project coordination, and ecosystem guidance as the community shifted toward direct SDK usage.

This repository now provides project overview for the entire Teaclave ecosystem and showcases demonstrating real-world applications built with Teaclave SDKs in different scenarios.

The repository maintains separate directories for TrustZone, SGX, and Crates ecosystems, each containing showcases and examples that demonstrate the capabilities of the respective SDKs. This structure makes it easy for developers to explore practical implementations across different TEE platforms.

**📄 Quick Navigation Links**

- [🚀 Teaclave TrustZone Ecosystem Showcase](/teaclave-docs/trustzone/)
- [🚀 Teaclave SGX Ecosystem Showcase](/teaclave-docs/sgx/)

---

### 🔐 [Teaclave FaaS (legacy)](https://github.com/apache/teaclave/tree/legacy)

The original **Teaclave Function-as-a-Service (FaaS)** platform was designed as a **general-purpose secure computing framework** that enables users to execute private computations on confidential data using Intel SGX.

As the field of confidential computing evolved, the Teaclave community naturally shifted its focus. Developers increasingly preferred building their own custom Trusted Applications directly using SDKs, rather than relying on a general-purpose FaaS framework. This shift was reflected in contributor activity, with most development and community engagement moving toward the Rust-based TrustZone and SGX SDKs. As a result, the FaaS framework is no longer actively maintained and has been archived.

Although now considered **legacy**, the FaaS platform remains a valuable milestone in Teaclave’s evolution into an SDK-focused ecosystem. Its architecture demonstrates how to build a high-level, privacy-preserving compute service on top of hardware-enforced TEEs.  We preserve its documentation and codebase history so that developers can continue to learn from its design and implementation.

**📄 Quick Navigation Links**

- [📘 Teaclave FaaS (legacy) Docs](/docs/)
- [📘 Papers, Talks, and Related Articles](/docs/papers-talks)

---

### ☕ [Teaclave Java TEE SDK *(Experimental)*](https://github.com/apache/teaclave-java-tee-sdk/)

The Teaclave Java TEE SDK is an **experimental toolkit** for building Java-based Trusted Applications on Intel SGX. It follows a familiar host/enclave partitioning model, similar to Intel's official SGX SDK, and aims to make confidential computing more accessible to Java developers.

By supporting a modular structure with clear separation between host-side and enclave-side components, this SDK helps bring the benefits of hardware-based trusted execution to Java ecosystems. It also adopts a provider interface inspired by the Java SPI (Service Provider Interface) model to facilitate pluggability and flexibility in enclave logic.

> ⚠️ Note: This SDK is still in an experimental stage.

**📄 Quick Navigation Links**

- [📘 Java TEE SDK Proposal](/blog/2022/10/08/accepting-java-enclave-proposal)

---

### 📦 [Teaclave Dependency Crates](https://github.com/apache/teaclave-crates)

The Teaclave Dependency Crates repository hosts a curated set of Rust libraries that have been adapted for use within Trusted Execution Environments. Due to the limitations of TEEs—such as the absence of standard OS support, restricted I/O, and incomplete standard library coverage—many third-party crates require modification or isolation to ensure safety and compatibility.

This repository serves as a security-reviewed foundation for TEE application development, offering vetted versions of widely-used crates like `rustls` and `ring`, reworked for secure enclave execution. It significantly simplifies the dependency management process for developers building within these constrained environments.

---

## 👥 Community Management

We welcome all contributors to help grow the Apache Teaclave™ project and ecosystem. Whether you're new to trusted computing or an experienced contributor, your involvement is highly valued.

Please visit the [**Community**](/community) page for more details on how to participate and contribute.

**📄 Quick Navigation Links**

- [🚀 How to Contribute to Apache Teaclave™](/contributing)
- [🚀 How to Become a Member of Apache Teaclave™](/becoming-a-member)
- [🚀 How to Make a Release](/release-guide)

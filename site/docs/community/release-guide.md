---
permalink: /release-guide
---

# Release Guide

For the release manager, the primary goal of a release is to upload the release
artifacts to the
[Apache Distribution SVN](https://dist.apache.org/repos/dist/release/incubator/teaclave/)
repositories. The artifacts must be **signed by the release manager** and
**approved through two stages of community votes**. This documentation outlines
the complete workflow and necessary operations to achieve that goal.

## For New Release Managers

### 0. Become a member of the Apache Teaclave™  community

The release manager must be a member of the Apache Teaclave™ project. This
ensures they have the necessary permissions, including access to the Apache
email system, SVN, GitHub write access, and other required infrastructure.

If you’re interested in this, please feel free to send email to
`dev@teaclave.apache.org` or contact any other member in Teaclave. We appreciate
all contributions!

### 1. Prepare the GPG Signing Key

The GPG key is used to sign the release artifacts. The public key is uploaded so
others can verify the release signatures.

GPG signing key should be added to the Apache release dist sever
(<https://dist.apache.org/repos/dist/release/incubator/teaclave/KEYS>) which is
automatically synced to
(<https://downloads.apache.org/incubator/teaclave/KEYS >)

Please follow this instruction to generate and upload keys:

**1.1. Generate an RSA4096 code signing key**

Please refer to <https://infra.apache.org/openpgp.html#key-gen-generate-key> for
generation guide. For safe practice of using the GPG key, please refer to:
<https://infra.apache.org/release-signing.html#safe-practice>.

**1.2. Append your public key to the KEYS file**

Steps:

```bash
$ SVN_RELEASE="https://dist.apache.org/repos/dist/release/incubator/teaclave"
$ svn co --depth=files "$SVN_RELEASE" svn-release-teaclave
# edit the svn-release-teaclave/KEYS file
# upload:
$ svn ci --username "$ASF_USERNAME" --password "$ASF_PASSWORD" -m "Update KEYS"
```

### 2. Optional: Request Other Permissions

Additional permissions may be needed depending on the repository. Contact the
project maintainers for specific access requirements.

## Release Stages

### Timeline of release stages

- **Prepare the release** (Week 1)
- **Pre-release on GitHub** (Week 2)
- **Voting** (Week 3–4)
- **Post-release** (within one week after all votes pass)

## Stage-by-Stage Operations Guide

### 1. Prepare the release

During this phase:

- Optional: Bump the dependencies version. e.g. for trustzone-sdk: bump OP-TEE
  version to the latest (including build scripts and test image)
- Review and follow the
  [Apache Incubator Release Checklist](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist).

  By default, no additional work is needed if you follow our release guide.
  However, please double-check the checklist in the following cases:

  - For the first release of a new year, ensure the year in the NOTICE file is
    updated to: 2019–[Current Year].
  - If there are any changes to DISCLAIMER, NOTICE, or LICENSE files, make sure
    they comply with the items in the checklist.
  - If any new examples include third-party code, refer to how this is handled
    in <https://github.com/apache/teaclave-trustzone-sdk/issues/196>

### 2. Pre-release on GitHub

Once all items in Stage 1 are completed, it's time to publish the release
candidate.

#### 2.1 Draft the release notes

You can manually draft the release notes or use tools to generate them
automatically. For example, on the GitHub Releases page, you can select the
previous release tag and click “Generate Release Notes” to create a basic draft.

Alternatively, you can use a GitHub Action to produce more detailed and
structured release notes.

For trustzone-sdk, we already have a GitHub Action set up for this purpose,
please refer to the
[Release Tips](https://github.com/apache/teaclave-trustzone-sdk/tree/main/docs/release-tips.md)
in the trustzone sdk repository for more details.

#### 2.2 Create the pre-release

1. Choose a tag: create a tag from current main, e.g. 0.5.0-rc.1
2. Fill in the release notes.
3. Select "This is a pre-release".
4. Click "Publish release".

Once successful, the release page will appear with the release notes and two
assets: **Source code (zip)** and **Source code (tar.gz)**.

### 3. Voting

After the pre-release on GitHub, you can start the voting process. To prepare
the voting email, we need to test building from source and prepare the
artifacts.

#### 3.1 Test building from source

Typically, we provide a Docker command to test the build in the voting email,
but the command varies between repositories. For example, in the case of
trustzone-sdk:

```bash
$ docker run --rm -it -v$(pwd):/teaclave-trustzone-sdk -w \
/teaclave-trustzone-sdk yuanz0/teaclave-trustzone-sdk:ubuntu-24.04 \
bash -c "./setup.sh && (./build_optee_libraries.sh optee) && source \
environment && make && (cd ci && ./ci.sh)"
```

The check process is as follows:

```bash
$ TAG=0.5.0-rc.1
## download tar
$ wget https://github.com/apache/teaclave-trustzone-sdk/archive/refs/tags/v0.5.0-rc.1.tar.gz
$ tar xzvf 0.5.0-rc.1.tar.gz
$ cd teaclave-trustzone-sdk-0.5.0.rc.1
$ docker run --rm -it -v$(pwd):/teaclave-trustzone-sdk -w \
/teaclave-trustzone-sdk yuanz0/teaclave-trustzone-sdk:ubuntu-24.04 \
bash -c "./setup.sh && (./build_optee_libraries.sh optee) && source \
environment && make && (cd ci && ./ci.sh)"
```

You can adjust this based on the repository you're working on.

#### 3.2 Prepare artifacts for voting

We provide a script
[`make_release_artifacts.sh`](https://github.com/apache/teaclave-trustzone-sdk/tree/main/scripts/release/make_release_artifacts.sh)
to pack the artifacts, sign and upload to SVN. It has been tested with
trustzone-sdk, and we believe it should work for other repositories as well.
Feel free to test it with other teaclave repositories, and open a PR if you
encounter any compatibility issues.

Be sure to update the variables in the script to set the release version and use
your ASF username/password and GPG key id.

```bash
## Get the key id of your signing key
gpg --list-secret-keys
GPG_KEY_UID=????
```

```bash
# Download source tarball from Github, sign, and verify release artifacts
./make_release_artifacts.sh prepare

# Verify existing artifacts and upload to Apache dist/dev SVN
./make_release_artifacts.sh upload
```

#### 3.2 Start voting process

**Voting Process**

Two votes are required:

- First, vote on the Apache Teaclave™ developers mailing list
  (`dev@teaclave.apache.org`).
- After it passes, call the second vote on the Apache Incubator general mailing
  list (`general@incubator.apache.org`).

Each vote requires **two email threads**:

- `[VOTE]` – to initiate the vote
- `[RESULT][VOTE]` – to announce the result

For example, if `rc1` is successfully released, you should send a total of
**four emails**:

- Two for the **community vote**
- Two for the **IPMC vote**

If additional release candidates (e.g., `rc2`, `rc3`, etc.) are needed, you’ll
need to repeat the voting process and send additional vote/result emails
accordingly.

Here are some important details:

- Each vote needs at least 3 _binding_ +1 votes and more +1 votes than -1 votes
  to pass.
- _Binding_ votes mean:
  - On `dev@teaclave.apache.org`, votes from PPMC members
  - On `general@incubator.apache.org`, votes from IPMC members
- Votes must stay open for at least 72 hours (3 days). If there aren’t enough
  binding votes by then, extend the voting period.
- If a vote fails, update the release accordingly, create a new release
  candidate, and restart the voting process.
- If the vote does not receive enough responses within 3 days, follow up by
  requesting votes—send a reminder email to the project's mentor. You can find
  the mentors’ email on our website.

**Voting Email**

For `trustzone-sdk`, we provide an email template in
[Release Tips](https://github.com/apache/teaclave-trustzone-sdk/tree/main/docs/release-tips.md)
, which follows a structure commonly used across all Teaclave repositories. You
can refer to this template or look at past email examples for guidance.

If you create a corresponding template for another Teaclave repository, we’d
greatly appreciate it — feel free to open a PR to contribute it.

Here are some examples:

**Vote / Result in the dev@teaclave list**:

- subject: [VOTE] Release Apache Teaclave TrustZone SDK  v0.4.0-rc.2
- to: dev@teaclave.apache.org
- link: <https://lists.apache.org/thread/o60wpscnq8mp6lhbd8h654ybxd6wzhk7>

- subject: [RESULT][VOTE] Release Apache Teaclave TrustZone SDK 
  v0.4.0-rc.2
- to: dev@teaclave.apache.org
- link: <https://lists.apache.org/thread/oo2r4xh731bqbn9b0659jjl7f4cym9g6>

**Vote / Result in the general@incubator list**:

- subject: [VOTE] Release Apache Teaclave TrustZone SDK  v0.4.0-rc.2
- to: general@incubator.apache.org
- link: <https://lists.apache.org/thread/8mstnqpoo0hy1sy8f96dyrkyrmcdwz2z>

- subject: [RESULT][VOTE] Release Apache Teaclave TrustZone SDK 
  v0.4.0-rc.2
- to: general@incubator.apache.org
- link: <https://lists.apache.org/thread/y2m99kt8tbpkp4fs9pw4kxvwc4pvx2so>

### 4. Post-release

Once the vote in the Incubator passes, the final step is to complete the
release.

#### 4.1 Upload the Final Release Artifacts to SVN

At this stage, you should:

- Move the release candidate (RC) artifacts to the final directory in `dev`.
- Delete all RC artifacts from the `dev`.
- Upload the finalized artifacts to the `release`.

For example, if the release version is `0.4.0`:

- **In `dev`**: Ensure the final directory with artifacts exists at:
  <https://dist.apache.org/repos/dist/dev/incubator/teaclave/trustzone-sdk-0.4.0/>
  Also, delete all previous `0.4.0-rc` artifacts.

- **In `release`**: Copy the finalized artifacts from `dev` to:
  <https://dist.apache.org/repos/dist/release/incubator/teaclave/trustzone-sdk-0.4.0/>

You can refer to the script
[`make_release_artifacts.sh`](https://github.com/apache/teaclave-trustzone-sdk/tree/main/scripts/release/make_release_artifacts.sh)
to perform these operations:

```bash
./make_release_artifacts.sh finalize
```

#### 4.2 Final release on Github

Add the tag for 0.[X].0

```
git tag v0.[X].0
git push origin v0.[X].0
```

On the release edit page, use the tag “0.[X].0”, unmark “Set as a pre-release”,
and submit.

#### 4.3 Optional: Other Publishing (e.g., on crates.io)

Repository-specific publishing may be required. For example, for trustzone-sdk,
publishing to crates.io is needed. Refer to the TrustZone documentation
[Release Tips](https://github.com/apache/teaclave-trustzone-sdk/tree/main/docs/release-tips.md)
for details.

#### 4.4 Post the announcement

**4.4.1 to the Apache mailing list**

**Mailing list example**:

- subject: [ANNOUNCE] Apache Teaclave TrustZone SDK  0.4.0 Released
- to: announce@apache.org, dev@teaclave.apache.org
- link: <https://lists.apache.org/thread/7zn019gsmd65xsbgw2tbv2c3jdvc44hb>

**4.4.2 to Teaclave website**

The website src is in: <https://github.com/apache/teaclave-website>,
open a PR to update.

Add an announcement in <https://teaclave.incubator.apache.org/blog/> and update
the download page: <https://teaclave.incubator.apache.org/download/>

**Blog example**:

- title: Announcing Apache Teaclave  0.3.0
- link: <https://teaclave.apache.org/blog/2021-10-01-announcing-teaclave-0-3-0/>

**Update Download Page Example**:

<https://github.com/apache/teaclave-website/commit/94d33df6c1540d0490a0728d0fd0be67915f1ca9>

After completing the steps above, the release process is finished.

## 5. Other considerations

### 5.1 About branch cut and feature freeze

- After tag the release, new feature development is frozen for the release, but
  the main(dev) branch remains active for ongoing development.
- If there’re bug fixes for this release, cut the release branch from the tag,
  e.g. `release-v0.5.0`. In the release branch, you can cherry-pick important
  bug fixes from main as needed. All changes should be committed to main first,
  and then optionally cherry-picked into the release branch. For example, if rc1
  requires changes based on voting feedback (e.g. feedback-fix-1): Suppose the
  `main` branch already has the following commits: `MAIN: feature (commit1)` →
  `fix (commit2)` → `feature (commit3)`. Assume the release branch was cut at
  `commit1`, so currently it only contains: `RELEASE: feature (commit1)`.
  - First, apply `feedback-fix-1` to the `main` branch. Now `main` looks like:  
    `MAIN: feature (commit1)` → `fix (commit2)` → `feature (commit3)` →
    `feedback-fix-1 (commit4)`
  - Then, cherry-pick `fix (commit2)` and `feedback-fix-1 (commit4)` into the
    release branch. The release branch becomes:  
    `RELEASE: feature (commit1)` → `fix (commit2)` → `feedback-fix-1 (commit4)`
- If the fix for release isn’t compatible with the main branch, it’s acceptable
  to apply the fix directly to the release branch and please mark at the commit
  message like: "Fix specific to release-1.x; not applicable to main due to
  architectural differences."

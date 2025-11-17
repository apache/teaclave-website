---
permalink: /release-guide
---

# Release Guide

For the release manager, the primary goal of a release is to upload the release
artifacts to the
[Apache Distribution SVN](https://dist.apache.org/repos/dist/release/teaclave/)
repositories.

The artifacts include three files, following the same naming convention:
- apache-teaclave-xxx-sdk-$version.tar.gz
- apache-teaclave-xxx-sdk-$version.tar.gz.asc
- apache-teaclave-xxx-sdk-$version.tar.gz.sha512

The `.tar.gz` contains the archived source code, which is reviewed against the
release checklist during the vote process by the Teaclave PMC.
The `.asc` file is a signature **created with the release manager's GPG key**.
The `.sha512` file contains a checksum for integrity verification.

## Prerequisites for new release managers

The release manager must be a committer of the Apache Teaclave™ project. This
ensures they have the necessary permissions, including access to the Apache
email system, SVN, GitHub write access, and other required infrastructure.

### 1. Prepare the GPG signing key

The release manager must maintain a personal GPG key to sign release artifacts.
Refer to <https://infra.apache.org/openpgp.html#key-gen-generate-key> for the
generation guide. For safe practices for using a GPG key, see:
<https://infra.apache.org/release-signing.html#safe-practice>.

Add the GPG public key to the Teaclave distribution `KEYS` file at
<https://dist.apache.org/repos/dist/release/teaclave/KEYS>. It will be
automatically synced to <https://downloads.apache.org/teaclave/KEYS>.

Users verify release signatures against this published `KEYS` file.

### 2. Add the release manager's GPG key to KEYS

The dist server uses SVN. Check it out locally, update the `KEYS` file, and commit the change.

```bash
$ svn co --depth=files "https://dist.apache.org/repos/dist/release/teaclave" release-teaclave 
# edit the release-teaclave/KEYS file
# upload:
$ svn ci --username "$ASF_USERNAME" -m "Update KEYS"
```

## Release stages

The release involves working with GitHub and the Teaclave mailing list.
1. Make a pre-release on GitHub to produce `$release-rc1.tar.gz`.
2. Prepare artifacts on the Apache dist/dev server.
3. Vote for the release candidate.
4. Move the approved release candidate to the Apache dist/release server.

### 1. Make a pre-release on GitHub

- Ensure the source code is ready for a new release, including bumping versions and upgrading dependencies.
- Review and follow the checklist in these cases:
  - For the first release of a new year, ensure the year in the NOTICE file is
    updated to: 2019–[Current Year].
  - If there are any changes to NOTICE, or LICENSE files, make sure
    they comply with the items in the checklist.
  - If any new examples include third-party code, refer to how this is handled
    in <https://github.com/apache/teaclave-trustzone-sdk/issues/196>.

#### 1.1 Draft the release notes

You can manually draft the release notes or use tools to generate them
automatically. For example, on the GitHub Releases page, you can select the
previous release tag and click “Generate Release Notes” to create a basic draft.

#### 1.2 Create the pre-release

1. Choose a tag: create a tag from the current `main`, e.g. `v0.5.0-rc.1`.
2. Fill in the release notes.
3. Select "This is a pre-release".
4. Click "Publish release".

Once successful, the release page will appear with the release notes and two
assets: **Source code (zip)** and **Source code (tar.gz)**.

### 2. Prepare artifacts on the Apache dist/dev server

After the pre-release on GitHub, prepare for the voting process.
The prerequisites include:
- Instructions for building and testing from source so others can validate the release source.
- Preparing the three artifact files (`.tar.gz`, `.asc`, `.sha512`) and uploading them to dist/dev.

#### 2.1 Instructions: test building from source

For example, in the case of trustzone-sdk:
```bash
$ TAG=v0.5.0-rc.1
$ wget https://github.com/apache/teaclave-trustzone-sdk/archive/refs/tags/$TAG.tar.gz -O $TAG.tar.gz
$ tar xzvf $TAG.tar.gz
$ cd teaclave-trustzone-sdk-0.5.0-rc.1
$ docker run --rm -it -v"$(pwd)":/teaclave-trustzone-sdk -w /teaclave-trustzone-sdk \
yuanz0/teaclave-trustzone-sdk:ubuntu-24.04 bash -c "./setup.sh && ./build_optee_libraries.sh optee && source environment && make && (cd ci && ./ci.sh)"
```
Please adjust this based on the repository you're working on.

#### 2.2 Prepare artifacts: sign, verify, and upload

We provide a script,
[`make_release_artifacts.sh`](https://github.com/apache/teaclave-trustzone-sdk/tree/main/scripts/release/make_release_artifacts.sh),
to package the artifacts, sign them, and upload to SVN.

Check out the directory, make the necessary updates, and upload.
Be sure to update the variables in the script to set the release version and use
your ASF username/password and GPG key ID.

```bash
## Get the key ID of your signing key
gpg --list-secret-keys
GPG_KEY_UID=????
# Download source tarball from GitHub, sign, and verify release artifacts
./make_release_artifacts.sh prepare

# Verify existing artifacts and upload to Apache dist/dev SVN
./make_release_artifacts.sh upload
```

Tip: After generating the `.sha512` and `.asc` files, verify the checksum and signature locally before uploading:

```bash
shasum -a 512 apache-teaclave-xxx-sdk-$version.tar.gz | diff - apache-teaclave-xxx-sdk-$version.tar.gz.sha512
gpg --verify apache-teaclave-xxx-sdk-$version.tar.gz.asc apache-teaclave-xxx-sdk-$version.tar.gz
```

### 3. Vote for release candidates

Vote on the Apache Teaclave™ developers mailing list (`dev@teaclave.apache.org`).

The vote requires **two email threads**:

- `[VOTE]` – to initiate the vote
- `[RESULT][VOTE]` – to announce the result if vote passes

Important details:
- Each vote needs at least three binding +1 votes and more +1 votes than -1 votes to pass.
- On `dev@teaclave.apache.org`, only votes from PMC members are binding.
- Votes must remain open for at least 72 hours (3 days). If there aren’t enough binding votes by then, extend the voting period.
- If a vote fails, update the release accordingly, create a new release candidate (with an increased rc number), and restart the voting process.

Voting email samples:

- subject: [VOTE] Release Apache Teaclave TrustZone SDK v0.6.0-rc.1
- to: dev@teaclave.apache.org
- link: <https://lists.apache.org/thread/sgmqw0fwvz8bcpcytfrl9f1hk0yzr8xb>

- subject: [RESULT][VOTE] Release Apache Teaclave TrustZone SDK v0.6.0-rc.1
- to: dev@teaclave.apache.org
- link: <https://lists.apache.org/thread/sj0tfcm6wk92dn6hl79gtnlf0yw3owgk>

### 4. Move the approved release candidate to the Apache dist/release server

Once the vote passes, move the voted release files to the dist/release SVN server.

#### 4.1 Upload the Final Release Artifacts to SVN

At this stage, you should:

- Move the release candidate (RC) artifacts to the final directory in `dev`.
- Delete all RC artifacts from `dev`.
- Upload the finalized artifacts to `release`.

For example, if the release version is `0.4.0`:

- **In `dev`**: Ensure the final directory with artifacts exists at:
  <https://dist.apache.org/repos/dist/dev/teaclave/trustzone-sdk-0.4.0/>
  Also, delete all previous `0.4.0-rc` artifacts.

- **In `release`**: Copy the finalized artifacts from `dev` to:
  <https://dist.apache.org/repos/dist/release/teaclave/trustzone-sdk-0.4.0/>

You can refer to the script
[`make_release_artifacts.sh`](https://github.com/apache/teaclave-trustzone-sdk/tree/main/scripts/release/make_release_artifacts.sh)
to perform these operations:

```bash
./make_release_artifacts.sh finalize
```

### 5. Convert pre-release to release on GitHub

Add the tag for `0.[X].0`:

```
git tag v0.[X].0
git push origin v0.[X].0
```

On the release edit page, use the tag `0.[X].0`, uncheck “Set as a pre-release”, and submit.

#### Optional: other publishing (e.g., crates.io)

Repository-specific publishing may be required. For example, for trustzone-sdk,
publishing to crates.io is needed. Refer to the TrustZone documentation
[Release Tips](https://github.com/apache/teaclave-trustzone-sdk/tree/main/docs/release-tips.md)
for details.

## Post the release

**Announce on the Apache mailing list**

Mailing list example:

- subject: [ANNOUNCE] Apache Teaclave™ TrustZone SDK 0.6.0 Released
- to: announce@apache.org, dev@teaclave.apache.org
- link: <https://lists.apache.org/thread/npxxtxxxolozjn15l5ff9nx6tltyt4o8>

**Update the Teaclave website**

The website source is at <https://github.com/apache/teaclave-website>. Open a PR to update.

Add an announcement to <https://teaclave.apache.org/blog/> and update
the download page: <https://teaclave.apache.org/download/>.

Blog example:

- title: Announcing Apache Teaclave™ TrustZone SDK 0.6.0
- link: <https://teaclave.apache.org/blog/2025/09/12/announcing-teaclave-trustzone-sdk-0.6.0/>

After completing the steps above, the release process is finished.

## Other considerations

### About branch cut and feature freeze

- After tagging the release, new feature development is frozen for that release, but
  the `main` (development) branch remains active for ongoing work.
- If there are bug fixes for this release, cut the release branch from the tag,
  e.g., `release-v0.5.0`. In the release branch, you can cherry-pick important
  bug fixes from `main` as needed. All changes should land in `main` first,
  and then optionally be cherry-picked into the release branch. For example, if rc1
  requires changes based on voting feedback (e.g., `feedback-fix-1`): Suppose the
  `main` branch already has the following commits: `MAIN: feature (commit1)` →
  `fix (commit2)` → `feature (commit3)`. Assume the release branch was cut at
  `commit1`, so currently it only contains: `RELEASE: feature (commit1)`.
  - First, apply `feedback-fix-1` to the `main` branch. Now `main` looks like:
    `MAIN: feature (commit1)` → `fix (commit2)` → `feature (commit3)` →
    `feedback-fix-1 (commit4)`.
  - Then, cherry-pick `fix (commit2)` and `feedback-fix-1 (commit4)` into the
    release branch. The release branch becomes:
    `RELEASE: feature (commit1)` → `fix (commit2)` → `feedback-fix-1 (commit4)`.
- If a fix for the release isn’t compatible with `main`, it’s acceptable
  to apply the fix directly to the release branch. Please mark the commit
  message, e.g., "Fix specific to release-1.x; not applicable to main due to
  architectural differences."

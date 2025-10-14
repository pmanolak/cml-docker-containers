# Verifying Release Signatures

## Overview

These steps show how to verify that release artifacts were signed by the project key and haven't been
tampered with. You should verify both the signer's public key fingerprint and the detached signature for each
artifact.

## Where to find the public key and fingerprint

- The project public key is distributed with releases or stored in this repository (look for project-public.
gpg or *.asc).
- The authoritative fingerprint is published in the repository README or release notes. Always compare the
fingerprint you import with the published fingerprint before trusting signatures.

## Import the public key

- From a file shipped in the repo or release:

      gpg --import ./project-public.gpg

- From a keyserver:

      gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>

## Confirm the key fingerprint

- List the imported keys and inspect the fingerprint:

      gpg --fingerprint <KEYID>

- Compare the printed fingerprint to the one published in this repository or release notes. Do not proceed if
they do not match.

## Verify a detached ASCII signature

For a file artifact.ext with signature artifact.ext.asc:

    gpg --verify artifact.ext.asc artifact.ext

Expected output: a "Good signature" message naming the signing key. Confirm the key shown matches the
expected key/fingerprint.

## Verify inline or clearsigned files

- If a file is clearsigned (signature inline), e.g. changesfile.changes:

      gpg --verify changesfile.changes

## Verify multiple artifacts in a release

- Example: verify all .deb files and their .asc signatures in ./artifacts:

      cd artifacts
      for f in *.deb; do [ -f "$f" ] || continue; gpg --verify "${f}.asc" "$f"; done

## Verify checksums (recommended)

- If release includes SHA256SUMS and SHA256SUMS.sig:

      gpg --verify SHA256SUMS.sig SHA256SUMS

  - `sha256sum -c SHA256SUMS` (verifies file integrity using the signed checksums)
- Verifying the signed checksum file first ensures the checksum list itself is authentic.

## Debian package notes

- Signature verification (`gpg --verify`) confirms signer identity, not package install safety.
- Inspect .deb contents if desired:

      dpkg-deb -I package.deb (metadata)
      dpkg-deb -c package.deb (list contents)

## Troubleshooting

- `gpg: Signature made ... using RSA key ID XXXXXXXX`
- If you get gpg: `Can't check signature: No public key`, the signer's public key is missing - import it from
 an authoritative source (repo/release notes) and re-run verification.
- If fingerprint doesn't match the published fingerprint: Treat the artifact as untrusted. Obtain the key/fingerprint from an independent authoritative channel before proceeding.
- If gpg reports a bad signature: Do not use the artifact. Re-download from the release page and re-check, then contact the maintainers.

## Automation / CI suggestions

- Add a CI job that:
  - Imports the public key from a trusted path,
  - Verifies SHA256SUMS.sig and SHA256SUMS,
  - Verifies signatures for each release artifact.
- Store the expected fingerprint (or key) in the repository for CI to validate against.

## Quick checklist

[ ] Download artifact and matching .asc (or .changes / signed checksum).
[ ] Import and verify the project public key fingerprint.
[ ] Run `gpg --verify` and confirm "Good signature" from the expected key.
[ ] Optionally verify checksums (sha256sum -c) and inspect package contents.

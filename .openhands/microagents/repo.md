# DBC_DXFS – Quick Repository Overview

DB/C DX is a compiler and runtime for the PL/B (formerly DATABUS) family of business programming languages. DB/C FS is the companion file server that exposes DB/C data files to other languages and interfaces (e.g., via ODBC). This repo contains the sources for DX, FS, and a set of file utilities, primarily in C (C99 + POSIX), along with some Java components. Prebuilt binaries and end‑user docs are available from https://www.dbcsoftware.org.

Project layout (high level):
- common – shared code and utilities (utils and support live here)
- dx – DB/C DX compiler (compiler) and runtime/VM (runtime), plus 3rd‑party code (jpeg, png, zlib, res)
- fs – DB/C FS server (server) and client/ODBC pieces (client)
- jdbc – Java JDBC client for FS (builds a jar)
- SmartClient_Java – Java Smart Client sources and jar packaging
- openssl – pre‑generated OpenSSL sources/outputs used in builds; libcups.a provides Linux CUPS support
- Makefile.* – platform‑specific build entry points used by CI

Build and test (local):
- Utilities (Linux): make -f Makefile.common.linux all; then ./TestUtilities.sh to run basic sanity tests (produces ju.xml). Utilities build outputs (e.g., aimdex, copy, list, etc.) appear in the repo root and are git‑ignored.
- DX (Linux): make -f Makefile.dx.linux all. FS (Linux): make -f Makefile.fs.linux all. On Windows, use the corresponding *.windows makefiles. Some targets require ODBC headers (unixodbc-dev on Linux) and use the provided OpenSSL tree.
- Java: JDBC jar – cd jdbc && javac org/ptsw/fs/jdbc/*.java && jar cf fsjdbc.jar org/ptsw/fs/jdbc/*.class org/ptsw/fs/jdbc/Messages.properties. Smart Client – see .github/workflows/build_SC_Java.yml for the reference commands.

CI reference: GitHub Actions under .github/workflows build DX, FS, utilities, JDBC, and the Smart Client, publishing artifacts on successful runs. If you are unsure of local prerequisites, mirror the commands in these workflows.

Tips for new contributors: read README.md for a narrative overview; start by building the utilities to validate your toolchain, then proceed to DX/FS. Most code assumes a POSIX environment; Windows builds use GNU make and toolchain equivalents. Binaries, large artifacts, and temporary test data (test_data/, ju.xml, *.exe, etc.) are already ignored via .gitignore.

# .dccapp Runner for DB/C DX

This runner reads a Windows-origin .dccapp file and invokes the DB/C DX runtime on Linux.

Sensitive data policy: All credentials/hostnames/ports are supplied by the .dccapp at runtime. None are stored in the repository or package.

Usage:
  dccapl-linux path/to/file.dccapp [--dxrun /path/to/dxrun] [--mount-root /mnt/wws]

After installing the .deb on Ubuntu, xdg-open will recognize .dccapp and open a terminal using this runner.

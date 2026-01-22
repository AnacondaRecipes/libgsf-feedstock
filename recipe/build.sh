#!/usr/bin/env bash
set -euo pipefail

# Get an updated config.sub and config.guess
cp "${BUILD_PREFIX}/share/gnuconfig/config.sub" .
cp "${BUILD_PREFIX}/share/gnuconfig/config.guess" .

# Fix perl shebangs in tests (avoid hardcoded /usr/bin/perl)
sed -i.bak '1 s|^.*$|#!/usr/bin/env perl|g' "${SRC_DIR}"/tests/t*.pl || true

# Configure
# - gdk-pixbuf is optional; explicitly disable to avoid accidental enablement
# - gtk-doc often pulls extra tooling; disable docs to keep build minimal
./configure \
  --prefix="${PREFIX}" \
  --disable-dependency-tracking \
  --disable-silent-rules \
  --without-gdk-pixbuf \
  --with-bz2 \
  --disable-gtk-doc

make -j"${CPU_COUNT}"

make install
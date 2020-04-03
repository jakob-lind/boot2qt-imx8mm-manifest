#!/bin/sh
# Copyright (C) 2019 The Qt Company Ltd.
#
# Turn manifest from meta-boot2qt into usable release manifest.
set -e

MANIFEST=$1

if [ ! -f "${MANIFEST}" ]; then
  echo "Manifest file not found: ${MANIFEST}"
  exit 1
fi

REV=$(git rev-parse HEAD)

# take out groups
sed -i -e '/path/N;/external/s/\"\n.*/\"\/>/' ${MANIFEST}
sed -i -e 's/,internal//' ${MANIFEST}

# add meta-boot2qt
if grep -q qtyocto ${MANIFEST}; then
    sed -i -e '/<project name="meta-qt/i\
\  <project name="meta-boot2qt"\
           remote="qtyocto"\
           revision="'${REV}'"\
           path="sources/meta-boot2qt">\
    <linkfile dest="setup-environment.sh" src="scripts/setup-environment.sh"/>\
  </project>' ${MANIFEST}
else
    sed -i -e '/<project name="meta-qt/i\
\  <project name="meta-boot2qt"\
           remote="qt"\
           revision="'${REV}'"\
           path="sources/meta-boot2qt">\
    <linkfile dest="setup-environment.sh" src="scripts/setup-environment.sh"/>\
    <linkfile dest="sources/templates" src="meta-boot2qt-distro/conf"/>\
  </project>' ${MANIFEST}
fi

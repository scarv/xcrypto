#!/bin/bash

# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

# =============================================================================

if [ -z "${DOCKER_USER}" ] ; then
  DOCKER_USER="scarv"
fi 
if [ -z "${DOCKER_UID}"  ] ; then
  DOCKER_UID="1000"
fi 
if [ -z "${DOCKER_GID}"  ] ; then
  DOCKER_GID="1000"
fi 

groupadd --gid ${DOCKER_GID} ${DOCKER_USER} ; useradd --gid ${DOCKER_GID} --uid ${DOCKER_UID} --no-user-group --create-home --shell /bin/bash ${DOCKER_USER}

# -----------------------------------------------------------------------------

exec /usr/sbin/gosu ${DOCKER_USER} bash --login -c "make --directory=/mnt/scarv/xcrypto ${*}"

# =============================================================================

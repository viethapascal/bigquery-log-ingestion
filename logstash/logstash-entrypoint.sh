#!/bin/sh

export LS_JAVA_OPTS="-Dls.cgroup.cpuacct.path.override=/ -Dls.cgroup.cpu.path.override=/ $LS_JAVA_OPTS"


if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
#  ./index_template/init_index.sh
  exec logstash "$@"
else
  exec "$@"
fi
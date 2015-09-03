#!/usr/bin/env bash -l

sudo /usr/local/bin/librarian-puppet update
export exitcode=$?
if [ $exitcode -eq 4 -o $exitcode -eq 6 ] 
  then exit 1
fi

sudo /usr/local/bin/librarian-puppet install
export exitcode=$?
if [ $exitcode -eq 4 -o $exitcode -eq 6 ] 
  then exit 1
fi

sudo FACTER_workspace=$WORKSPACE /bin/puppet apply \
  --verbose \
  --debug \
  --hiera_config=$WORKSPACE/hiera.integration.yaml \
  --modulepath=$WORKSPACE/site:$WORKSPACE/modules manifests/site.pp

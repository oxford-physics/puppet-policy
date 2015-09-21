#!/bin/bash
TESTDIR=/home/brisbane/wntests

if ! [[ $TMPDIR ]] ; then
  export TMPDIR=/tmp

fi
if ! [[ $PBS_JOBID ]];then
  export PBS_JOBID=local_job-`hostname`
fi

echo $TMPDIR 
echo  $PBS_JOBID 
echo "Running on `hostname` ... "
env
for i in `ls $TESTDIR`; do
     if echo $i | grep disabled ; then continue; fi
   . $TESTDIR/$i $i
done

#!/usr/bin/env bash

for dot_file in $(ls -d .*)
do
  cur_file=$(basename $dot_file)
  [[ $cur_file =~ ^(.git|^.$|^..$|.swp$) ]] && continue
  #echo "Comparing $dot_file..."
  cmp $cur_file ${HOME}/$cur_file
  if [[ $? != 0 ]]; then
    if [[ $cur_file -nt ${HOME}/$cur_file ]]; then
       echo "$cur_file is newer then ${HOME}/$cur_file"
    elif [[ $cur_file -ot ${HOME}/$cur_file ]]; then
       echo "$cur_file is older then ${HOME}/$cur_file"
    fi
    echo "diff $cur_file ${HOME}/$cur_file"
    diff $cur_file ${HOME}/$cur_file
  fi
done

cd utils

BIN_FOLDER='/usr/local/bin'
for file in $(ls)
do
  echo "diff $file ${BIN_FOLDER}/$file"
  diff $file ${BIN_FOLDER}/$file
done


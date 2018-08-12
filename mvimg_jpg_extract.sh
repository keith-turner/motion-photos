#!/bin/bash

function extract {
  local file=$1
  
  local newFile=${file/[.]jpg/.mp4}

  if [[ -f "$newFile" ]]; then
    echo "File $newFile exists, so ignoring $file"
  else
    # find the offset of the string 'ftypmp42' in the file
    local lines=( $(grep --only-matching --byte-offset --binary --text ftypmp42  $file| cut -f 1 -d:) )

    # check that it was only found once in the file.. if not, well script probably needs improvement
    if (( ${#lines[@]} == 1 )) ; then
      # the mp4 begins 3 byte before the string 'ftypmp42'
      local offset=$(( ${lines[0]} - 3))

      # extract everything beginning at offset to another file
      tail -c +$offset $file > $newFile
    else
      echo "Not processing $file because the string 'ftypmp42' did not occur exactly once in file"
    fi
  fi
}

for f in "$@"; do
  if [[ "$f" == MVIMG*jpg ]]; then
    extract $f
  else
    echo "Ignoring $f because its file name does not match MVIMG*jpg pattern"
  fi
done

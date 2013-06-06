#!/bin/zsh

if [ ! -d $1 ]; then
    echo "Enter a valide the directory"
else
   for link in $@*
do
       
   if [[ -x "$link" && ! -d "$link" ]]; then
       simbolic=${link:t}
       ln -s $link ~/bin/$simbolic
   fi
done
fi

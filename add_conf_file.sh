#! /bin/bash 

#Description : adds a file into managed files

rep="$(dirname $0)"

. "$rep/functions"


# must be used in home directory 
cd $rep

list="$(for fichier in $@ ; do
	if [ -d "$HOME/$fichier" ] ; then
		pushd . &>/dev/null
		cd "$HOME"
		find "$fichier" #-print0
		popd &>/dev/null
	elif [ -e "$HOME/$fichier" ] ; then
		echo "$fichier"
	fi
done)"
echo "$list" | for_all_input_files backup

cd "$CONF_FILES_DIR"

git commit -m "$(echo -e "$(date) : \n added files to config : \n $list")"
git push


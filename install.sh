#!/bin/bash 

#Description : backup & installs repos files into main directory


base="$(dirname $0)"
cd "$base"

source lib

# init


if [ -f "$default_config_path/conf/conf" ] ; then 
	source "$default_config_path/conf/conf"
else
	# repo must be inited
	echo "non initialized config"
	remote_repo="${default_conf_files_repo}"
	echo "default repo : ${remote_repo}"
	read "change it? (y/N)" -r 1 choice

	case "$choice" in 
  		y|Y ) read "enter new repo name" remote_repo ;;
  		* )   echo "using default" ;;
	esac
	
	mkdir -p "$default_config_path/conf/"
	mkdir -p "${default_config_file_store_dir}"
	
	echo 'remote_repo='\"${remote_repo}\" > $default_config_path/conf/conf
	echo 'CONF_FILES_DIR="'"${CONF_FILES_DIR}"'"' >> $default_config_path/conf/conf
fi

if [ -f "${CONF_FILES_DIR}/bin/commands" ] ; then 
	cp "${CONF_FILES_DIR}/bin/commands" ~/bin/commands
fi

# local functions

function link_conf {
	# f
	fic="$1"
	echo "treating $1 ..."
	rep="$(dirname "$fichier")"
	if [ ! -d "$HOME/$rep" ] ; then
		mkdir -p $HOME/"$rep"
	fi
	if [ -f "$fic" ]; then
		cp "$fic" "$HOME/$fic"
	fi
}

# getting filename that will be erased to backup them later

function backup_local_conf() {

	# copy current version of old backups file list
	git ls-files | for_all_input_files backup

	# copy current version of new file list
	echo -n "$new_conf_files" | for_all_input_files backup
}

exec_in_backup_branch backup_local_conf

##### init conf #####
function init_conf(){
	git commit -am "Backup commit : $(date)"

	git checkout master

	git submodule init
	git submodule update

	# install new files
	for_all_conffiles link_conf
}

exec_in_master_branch init_conf


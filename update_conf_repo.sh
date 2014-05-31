#! /bin/bash

#Description : moves conf files current version into repo

name="$0"
rep="$(dirname $0)"

. "$rep/functions"

# backup branch of local computer

cd "$CONF_FILES_DIR"

function backup_local_files() {

	cd "$rep"

	git merge master
	for_all_conffiles backup

	git push origin

	cd "$CONF_FILES_DIR"
	git commit -am "$m:updating repo after config scripts update into relevant machine branch"
}

exec_in_backup_branch backup_local_files

function master_update() {
	git merge "$(get_backup_branch_name)"
	git pull
	git push
}


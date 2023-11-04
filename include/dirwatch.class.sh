#!/bin/bash
# ======================================================================
#
# AXELS DIRECTORY WATCHER * CLASS
#
# ----------------------------------------------------------------------
# 2023-10-NN  v0.1  ah  first lines
# ======================================================================

# JQ_DIRSELF was set in "bjq"
. "$JQ_DIRSELF/vendor/color.class.sh" || exit

# ----------------------------------------------------------------------

. "$JQ_DIRSELF/vendor/color.class.sh"

DW_LOGFILE="$JQ_DIRSELF/log/watchdir.log"

DW_DIRBASE=
DW_DIR2WATCH=
DW_DIRDONE=
DW_DIRWORK=
DW_DIROUT=

DW_DIRPLUGINS="$JQ_DIRSELF/watchers/enabled"

# ----------------------------------------------------------------------
# PRIVATE FUNCTIONS
# ----------------------------------------------------------------------

# set a directory for incoming files
# the needed directory structure will be created
# param  string  optional: path of incoming directory; default: subdir ./files/incoming
function dw.setdir(){
  DW_DIRBASE="${1:-$JQ_DIRSELF/files}"
  DW_DIR2WATCH="${DW_DIRBASE}/incoming"
  DW_DIRDONE="${DW_DIR2WATCH}/done";     test -d "$DW_DIRDONE" || mkdir -p "$DW_DIRDONE"
  DW_DIRWORK="${DW_DIR2WATCH}/running";  test -d "$DW_DIRWORK" || mkdir -p "$DW_DIRWORK"
  DW_DIROUT="${DW_DIRBASE}/output";        test -d "$DW_DIROUT"  || mkdir -p "$DW_DIROUT"

}

function dw._log(){
  local _msg="$*"
  color.fg cyan
  echo -n ">>> "
  echo "$( date +"%Y-%m-%d %H:%M:%S" ) | $_msg" | tee -a "$DW_LOGFILE"
  color.reset

}

# ----------------------------------------------------------------------
# PUBLIC FUNCTIONS
# ----------------------------------------------------------------------

function dw.getDir(){
  echo "$DW_DIRBASE"
}

function dw._listhelper(){
  local _mydir="$1"
  local _iCount; typeset -i _iCount
  _iCount=$( find "$DW_DIR2WATCH" -maxdepth 0 -type f | wc -l )

  printf "%4s %s\n" $_iCount "files in $_mydir"
  find "$DW_DIR2WATCH" -maxdepth 0 -type f -exec ls -ld {} \;
}

# list current files
function dw.list(){
  echo -n "----- INCOMING .... "; dw._listhelper "$DW_DIR2WATCH"
  echo -n "----- PROCESSING .. "; dw._listhelper "$DW_DIRWORK" 
}

# detect a matching plugin
# each plugin config has a filematcher to define its files to handle 
# param  string  filename to analyze
function dw.getPlugin(){
  local _infile="$1"
  dw.plugins | while read -r _plugin; do
    _filter=$( jq  ".filter" "$_plugin" | tr -d '"')
    if echo "$_infile" | grep "$_filter" >/dev/null; then
      echo "$_plugin"
      return 0
    fi
  done
}


# get a list of plugin configuration files
function dw.plugins(){
  find "$DW_DIRPLUGINS" -type f -o -type l -name "*json"
}


function dw.processfile(){
  local filename="$1"
  workfile="${DW_DIRWORK}/$filename"
  donefile="${DW_DIRDONE}/$filename"
  outfile="${DW_DIROUT}/$filename"

  foundplugin=$( dw.getPlugin "$directory/$filename" )
  if [ -n "$foundplugin" ]; then
    dw._log "   > plugin: $foundplugin"
    _command=$( jq  ".command" "$foundplugin" | tr -d '"')
    mv "$directory/$filename" "$workfile"

    # bjq_command=$( echo "bjq -a $_command; mv \'$workfile\' \'$donefile\' | sed "s,%INFILE%,$workfile,g" | sed "s,%OUTFILE%,$outfile,g" )
    bjq_command=$( echo "bjq -a \"$_command; rc=\\\$?; mv '$workfile' '$donefile'; exit \\\$rc \"" | sed "s,%INFILE%,'$workfile',g" | sed "s,%OUTFILE%,'$outfile',g" )
    dw._log "   > $bjq_command"
    eval $bjq_command >/dev/null
  else
    dw._log "   SKIP: no plugin was found"
  fi

}

# start watching
# param  string  optional: path of incoming directory; default: subdir ./files/incoming
function dw.watch(){
  test -n "$1" && dw.setdir "$1"
  dw._log "---------- Start to watch $DW_DIR2WATCH ..."
  # dw._log $( dw.plugins )
  inotifywait -e close_write -m $DW_DIR2WATCH |
    while read -r directory events filename; do

      dw._log "Found '$directory/$filename' - $events"
      dw.processfile "$filename"

    done  
}


# ----------------------------------------------------------------------

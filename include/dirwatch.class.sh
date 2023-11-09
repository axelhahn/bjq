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
    if echo "$_infile" | grep -E "$_filter" >/dev/null; then
      echo "$_plugin"
      return 0
    fi
  done
}


# get a list of plugin configuration files
function dw.plugins(){
  (
    find "$DW_DIRPLUGINS" -type f -name "*.json"
    find "$DW_DIRPLUGINS" -type l -name "*.json"
  ) | sort
}


function dw.processfile(){
  local filename="$1"
  local _workfile="${DW_DIRWORK}/$filename"
  local _donefile="${DW_DIRDONE}/$filename"
  local _outfile="${DW_DIROUT}/$filename"
  local _command
  local _type
  local _typeval

  foundplugin=$( dw.getPlugin "$filename" )
  if [ -n "$foundplugin" ]; then
    dw._log "   > plugin: $foundplugin"
    _command=$( jq  ".command"       "$foundplugin" | tr -d '"')
    _typeval=$( jq  ".type"          "$foundplugin" | tr -d '"')
    _addpre=$(  jq  ".oufile_prefix" "$foundplugin" | tr -d '"')
    _addsuf=$(  jq  ".oufile_suffix" "$foundplugin" | tr -d '"')

    _outfile="${DW_DIROUT}/${_addpre}${filename}${_addsuf}"

    mv "$directory/$filename" "$_workfile"
    dw._log "   > command: $_command"

    case "$_typeval" in
      bjq|bg|now) _type=$_typeval;;
      *)         _type="bjq";;
    esac
    dw._log "   > type: $_type"


    # replace INFILE and OUTFILE
    _command="$( echo $_command | sed "s,%INFILE%,'$_workfile',g" | sed "s,%OUTFILE%,'$_outfile',g" )"

    # add actions around
    _command="
      $_command; 
      rc=\\\$?;
      mv '$_workfile' '$_donefile';
      exit \\\$rc
    "

    case "$_type" in
      bjq)
        _command="bjq -a \"$_command\""
        ;;
      bg)
        _command="nohup $_command & "
        ;;
    esac

    # no quotes -> transformed into single line
    eval "$_command"
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

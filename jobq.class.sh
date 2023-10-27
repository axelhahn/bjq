#!/bin/bash
# ======================================================================
#
# AXELS BASH JOB QUEUE * CLASS
#
# ----------------------------------------------------------------------
# 2023-10-NN  v0.1  ah  first lines
# ======================================================================

# JQ_DIRSELF was set in "bjq"
. "$JQ_DIRSELF/vendor/color.class.sh"

# ----------------------------------------------------------------------
# VARS
# ----------------------------------------------------------------------

JQ_LOGFILE=$JQ_DIRSELF/log/jobq.log

JQ_DIRBASE=$JQ_DIRSELF/jobs
JQ_DIRPENDING=$JQ_DIRBASE/pending
JQ_DIRRUNNING=$JQ_DIRBASE/running
JQ_DIRDONE=$JQ_DIRBASE/done


typeset -i JQ_JOBS_PENDING=0
typeset -i JQ_JOBS_RUNNING=0
typeset -i JQ_JOBS_OK=0
typeset -i JQ_JOBS_ERROR=0


# ----------------------------------------------------------------------
# PRIVATE
# ----------------------------------------------------------------------

# show an error message and quit with rc 1
# param  string  message to show
function jobq._error(){
    color.echo "red" "ERROR: $*"
    color.reset
    echo
    exit 1
}

# ----------------------------------------------------------------------
# get next pending job file
function jobq._getnextpending(){
    find "${JQ_DIRPENDING}/" -type f | grep -v "\.[a-z]*$" | sort | head -1
}

function jobq._h2(){
    color.echo "yellow" "---------- $*"
    # echo
}

# ----------------------------------------------------------------------
# add a line into the log; the timetamp will be added automatically
# param  string  line to log
function jobq._log(){
    echo "$( date +"%Y-%m-%d %H:%M:%S" ) $*" >> "$JQ_LOGFILE"
}

# ----------------------------------------------------------------------
# print a message with timestamp
# param  string  message to show
function jobq._msg(){
    color.echo "cyan" ">>>>> $( date +"%Y-%m-%d %H:%M:%S" ) | $*"
}


# ----------------------------------------------------------------------
# PUBLIC
# ----------------------------------------------------------------------

# add a job
# param  string  command to execute
# param  string  path where to set the working directory
function jobq.add(){
    local _command="$1"
    local _path="$2"

    local _jobid; _jobid=$( date +"%Y-%m-%d__%H%M%S__%N" )

    # detect a relative path and create a full path of it
    if pushd "$_path" 2>/dev/null; then
        _path=$( pwd )
        popd || exit 2
    fi

    (
        echo "#!/bin/bash"
        echo "# Date   : $( date )"
        echo "# user   : $USER"
        echo "# command: $_command"
        echo "# path   : $_path"
        echo "# --------------------------------------------------"
        test -n "$_path" && echo "cd '$_path' || exit 1"
        echo "$_command"

    ) >"${JQ_DIRPENDING}/$_jobid"
    echo -n "added "
    ls -l "${JQ_DIRPENDING}/$_jobid"
    cat "${JQ_DIRPENDING}/$_jobid"
    jobq._log "add - created job $_jobid: $_command"
}

# ----------------------------------------------------------------------
# get a list of current jobs
function jobq.list(){
    jobq.status
    local _iQueued; typeset -i _iQueued; _iQueued=$JQ_JOBS_PENDING+$JQ_JOBS_RUNNING
    if [ $_iQueued -eq 0 ]; then
        echo "Queue is empty: there is no pending or running job."
    else
        jobq._h2 "LIST QUEUE"
        test $JQ_JOBS_PENDING -gt 0 && (color.echo blue  "--- PENDING:"; find "${JQ_DIRPENDING}/" -type f | grep -v "\.[a-z]*$"; echo )
        test $JQ_JOBS_RUNNING -gt 0 && (color.echo green "--- RUNNING:"; find "${JQ_DIRRUNNING}/" -type f | grep -v "\.[a-z]*$"; echo )
    fi
}

function jobq._readinfo(){
    local _jobfile="$1"
    local _item="$2"
    grep "$_item.*:" $_jobfile | cut -f2- -d ':' | sed 's,^ ,,'
}

# ----------------------------------------------------------------------
# process a job file
# param  string  filename of the job file
function jobq.process(){
    local _nextjob="$1"
    local _jobid; _jobid="$( basename $1 )"
    local _runjob="${JQ_DIRRUNNING}/$_jobid"

    jobq._msg "START PROCESING JOB $_jobid"
    if [ ! -f "$_nextjob" ]; then
        jobq._log "process - $_jobid - ERROR: file [$_nextjob] does not exist."
        jobq._error "Job file does not exist"
    else
        jobq._log "process - $_jobid - START: $( grep -vE "^(#|cd)" $_nextjob )"

        # parse jobfile

        local _dorun=1
        local _runfile="/tmp/$_jobid.bash"
        local _commandline
        local _user
        local _command
        local _workingdir

        _user=$(       jobq._readinfo "$_nextjob" "user"    )
        _command=$(    jobq._readinfo "$_nextjob" "command" )
        _workingdir=$( jobq._readinfo "$_nextjob" "path"    )

    
        if [ "$_user" != "$USER" ]; then
            if [ "$USER" = "root" ]; then
                _commandline="sudo -u $_user -s "
            else
                _dorun=0
                echo "SKIP: user [$USER] is not allowed to execute a job for user [$_user]"
            fi
        fi

        if [ $_dorun = 1 ]; then

            mv -f "$_nextjob" "$_runjob" || jobq._error "ERROR: failed to move jobfile."

            # echo "#!/bin/bash" > "${_runfile}"
            # if [ -n "$_workingdir" ]; then
            #     echo "cd '$_workingdir' || exit -1; " >> "${_runfile}"
            # fi
            # echo "$_command" >> "${_runfile}"
            # echo "DEBUG: _runfile: ${_runfile}"
            # cat "${_runfile}"
            
            # _commandline+="/bin/bash -vx $command"
            # echo "$_commandline"; exit

            # test -n "$_path" && _commandline+="cd \"$_path\" || exit 1"

            echo "Use 'tail -f ${_runjob}.out' to follow ..."
            grep -vE "^(#|cd)" "$_runjob"

            echo "$( date ) START" > "${_runjob}.out"

            # TODO: create a command line to execute.
            # Lazy variant. execute the job file
            # if $_commandline >> "${_runjob}.out" 2>&1; then
            if bash -vx "${_runjob}" >> "${_runjob}.out" 2>&1; then
                echo "$( date ) END (OK)" >> "$_runjob.out"
                color.echo "green" "OK"
                mv -f "$_runjob.out" "$JQ_DIRDONE/${_jobid}.ok"
                jobq._log "process - $_jobid - OK"
            else
                local _rc=$?
                echo "$( date ) END - rc=$?" >> "$_runjob.out"
                color.echo "red" "ERROR"
                mv -f "$_runjob.out" "$JQ_DIRDONE/${_jobid}.error"
                jobq._log "process - $_jobid - FAILED"
            fi
            mv -f "$_runjob" "$JQ_DIRDONE"
            color.reset
        fi
    fi
}

# ----------------------------------------------------------------------
# run to process all pending jobs
function jobq.run(){
    jobq._log "run - START"
    jobq.list

    jobq._h2 "RUN"
    local _nextjob
    _nextjob="$( jobq._getnextpending )"

    if [ -z "$_nextjob" ]; then
        jobq._msg "No Job available."
        jobq._log "run - No Job available"
    else
        echo "Next job: $_nextjob"
        if [ $JQ_JOBS_RUNNING -gt 0 ]; then
            jobq._error "There seems to be a running job - see ${JQ_DIRRUNNING}."
        fi

        while [ -n "$_nextjob" ]; do
            jobq.process "$_nextjob"
            echo
            _nextjob="$( jobq._getnextpending )"
            jobq.status
            test $JQ_JOBS_PENDING -gt 0 && ( echo "sleeping ..."; sleep 3)
        done
        jobq._msg "ALL JOBS DONE"
    fi
    jobq._log "run - DONE"
}

# ----------------------------------------------------------------------
# get status of pending and running jobs
# it sets JQ_JOBS_RUNNING and JQ_JOBS_PENDING
# and shows a message line
function jobq.status(){
    jobq._log "status"
    JQ_JOBS_RUNNING=$( find "${JQ_DIRRUNNING}/" -type f | grep -v "\.[a-z]*$"; )
    JQ_JOBS_PENDING=$( find "${JQ_DIRPENDING}/" -type f | grep -v "\.[a-z]*$"; )
    JQ_JOBS_OK=$(      find "${JQ_DIRDONE}/" -type f | grep -c ".ok" )
    JQ_JOBS_ERROR=$(   find "${JQ_DIRDONE}/" -type f | grep -c ".error" )
    jobq._msg "STATUS: pending : $JQ_JOBS_PENDING ... running: $JQ_JOBS_RUNNING | DONE ok: $JQ_JOBS_OK ... error: $JQ_JOBS_ERROR"
    jobq._log "status - pending : $JQ_JOBS_PENDING ... running: $JQ_JOBS_RUNNING | DONE ok: $JQ_JOBS_OK ... error: $JQ_JOBS_ERROR"
}

# ----------------------------------------------------------------------

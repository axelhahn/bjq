## Description

This project was just initiated. It is in alpha stadium.

### Bjq

Job queue written in Bash. Execute a list of jobs sequentially.

### Dirwatcher

Watch a directory and wait for new files.
Plugins can define by a filefilter what to execute for a matching file.
The command will be added with bjp.

---

This is free software and Open Source 
GNU General Public License (GNU GPL) version 3

👤 Author: Axel Hahn\
🧾 Source: <https://github.com/axelhahn/bjq/>\
📜 License: GNU GPL 3.0\
📗 Docs: see <https://www.axel-hahn.de/docs/bjq/> (TODO)

## Help

```txt
______________________________________________________________________________
     
 BJQ  Axels Bash job queue
__________________________________________________________________________v0.1

  👤 Author:  Axel Hahn
  🧾 Source:  https://github.com/axelhahn/bjq/
  📜 License: GNU GPL 3.0
  📗 Docs:    TODO
______________________________________________________________________________


Job queue written in Bash. Execute a list of jobs sequentially.


You can add commands that will be dropped as job files into a "pending" queue.
  bjq -a <COMMAND> [<WORKDIR>]

When starting the runner (eg. as cronjob every 5 min) it executes all pending
jobs.
  bjq -r

Running jobs are held in the "running" folder.

Finished jobs are moved to the "done" folder. Their command output is in an
extra file with extension ".ok" or ".error" depending on the exit code.
______________________________________________________________________________

SYNTAX:

  bjq -a [<COMMAND> [<WORKDIR>]]
  bjq [option]

OPTIONS:

  -a | --add  [<COMMAND> [<WORKDIR>]]
                    Add a new job command and optional a working directory.
                    Default directory is the current directory.
                    If no command is given the interactive mode will start.
  -h | --help       Show this help and exit.
  -l | --list       List current jobs.
  -r | --run        Start run to process pending jobs.
  -s | --status     Show status.
  -v | --version    Show version and exit.
______________________________________________________________________________
```

```txt
______________________________________________________________________________
     
 DIR   W A T C H E R
__________________________________________________________________________v0.1

  👤 Author:  Axel Hahn
  🧾 Source:  https://github.com/axelhahn/bjq/
  📜 License: GNU GPL 3.0
  📗 Docs:    TODO
______________________________________________________________________________

Watch a directory and wait for new files.
Plugins can define by a filefilter what to execute for a matching file.
The command will be added with bjp.
______________________________________________________________________________

SYNTAX:

  dirwatcher -w [DIR]
  dirwatcher [option]

OPTIONS:

  -h | --help         Show this help and exit
  -d | --dir   [DIR]  set a directory to watch or to list
  -l | --list         list current files
  -w | --watch [DIR]  start run to process pending jobs
  -v | --version      Show version and exit

EXAMPLES:

  dirwatcher -l       List files to process below default dir
                      /home/axel/sources/bash/jobq/files
  dirwatcher -d /my/path/ -l
                      List files to process below /my/path/

  dirwatcher -w       Start watching incoming files below default dir
                      /home/axel/sources/bash/jobq/files/incoming
  dirwatcher -d /my/path/ -l
                      Start watching incoming files below /my/path/incoming
______________________________________________________________________________
```
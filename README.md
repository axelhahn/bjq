# BJQ

## Description

Job queue written in bash. Execute a list of jobs sequentially.

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

  👤 author:  Axel Hahn
  🧾 license: GNU GPL 3.0
  🌐 website: TODO
  📘 docs:    TODO


Job queue written in Bash. Execute a list of jobs sequentially.


You can add commands that will be dropped as job files into a "pending" queue.
  bjq -a <COMMAND> [<WORKDIR>]

When starting the runner (eg. as cronjob every 5 min) it executes all pending
jobs.
  bjq -r

Running jobs are held in the "running" folder.

Finished jobs are moved to the "done" folder. Their command output is in an
extra file with extension ".ok" or ".error" depending on the exit code.


SYNTAX:

  bjq -a [<COMMAND> [<WORKDIR>]]
  bjq [option]

OPTIONS:

  -a | -add        add a new job command
  -l | -list       list current jobs
  -r | -run        start run to process pending jobs
  -s | -status     show status

______________________________________________________________________________
```
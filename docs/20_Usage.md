## Usage

### Help

Use `bjq -h` to show the help page.

```txt
______________________________________________________________________________
     
 BJQ  Axels Bash job queue
__________________________________________________________________________v0.1

  👤 Author:  Axel Hahn
  🧾 Source:  https://github.com/axelhahn/bjq/
  📜 License: GNU GPL 3.0
  📗 Docs:    TODO


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

### Add a job

#### Interactive

`bjq -a`

You get two prompts to enter

* a command to execute
* optional: a working dir. It can be empty (just press return)

#### Using parameters

`bjq -a <COMMAND> [<WORKING-DIR>]`

The command is a quoted string.
The working dir is optional. If nothing was given it uses the currnt path. You can set a relative path. Any given path must exist.

**Remark**: Using the path extension `~` for a users HOME does not work (yet).

The created job is placed as a file into the ./pending/ directory

### List jobs

* To see a ahort status use `bjq -s`.
* To list the pending files `bjq -l`.

### Execute jobs

To start processing a queue start

`bjq -r`

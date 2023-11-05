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
  📗 Docs:    https://www.axel-hahn.de/docs/bjq/
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

* To see a short status as single line use `bjq -s`.
* To list the pending files `bjq -l`.

### Execute jobs

To start processing a queue start

`bjq -r`

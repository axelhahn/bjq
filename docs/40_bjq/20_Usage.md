## Usage

### Help

Use `bjq -h` to show the help page.

```txt
______________________________________________________________________________

 BJQ  Axels Bash job queue
__________________________________________________________________________v0.2

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
  -d | --done       List finished jobs with exit status
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

### List todo jobs

To see a short status as single line use `bjq -s`.

```txt
$ bjq -s
>>>>> 2023-11-05 22:16:16 | STATUS: pending : 1 ... running: 0 | DONE ok: 12 ... error: 2
```

To list the pending and running files files `bjq -l`. Yo see the command line of all pending/ processed jobs.

```txt
$ bjq -l
>>>>> 2023-11-05 22:17:16 | STATUS: pending : 1 ... running: 0 | DONE ok: 12 ... error: 2
---------- LIST QUEUE 
⏳ PENDING:
   🗒 (...)/jobs/pending//2023-11-04__225335__046583176
      💻 markdown-to-html --in '/home/axel/sources/bash/jobq/files/incoming/running/hello.md' --out '/home/axel/sources/bash/jobq/files/output/hello.md'.html; rc=$?; mv '/home/axel/sources/bash/jobq/files/incoming/running/hello.md' '/home/axel/sources/bash/jobq/files/incoming/done/hello.md'; exit $rc 
```

### Execute jobs

To start processing a queue start

`bjq -r`

### List finished jobs

To list finished jobs use `bjq -d`.

You get a list of job files and when they were finished with its exit status. Successful jobs (rc=0) are green; failed jobs (rc > 0) are marked in red.

### Cleanup finished jobs

Last but not least you need to remove the files (except .keep) in the `./jobs/done/` folder. To do so you can run this command in a cronjob:

`find [appdir]/jobs/done/ -type f -name "20*" -mtime +7 -print -delete`

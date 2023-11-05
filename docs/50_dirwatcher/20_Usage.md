## Usage

### Help

Use `dirwatcher -h` to show the help page.

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

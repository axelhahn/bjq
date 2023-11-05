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
  📗 Docs:    https://www.axel-hahn.de/docs/bjq/
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

### Watch a directory

You can start watching a directory for new files by
```txt
dirwatcher -w [DIR]
```

Without a directory it watches the subdir files/incoming/.

### Plugins

How to define what to do with an incoming file?

Have a look to the subdir "watchers".

* available - files here are inactive
* enabled - activated plugins

To activate a plugin put a file into "enabled" folder or create a softlink to an available file.

#### Plugin file (WIP)

A plugin file is a json file. The keys "filter" and "command" are mandantory.

Use the strings %INFILE% and %OUTFILE% will be replaced by dirwatcher when generating the command.

```json
{
    "label": "md to html",
    "description": "convert markdown to html",

    "filter": ".md",

    "command": "markdown-to-html --in %INFILE% --out %OUTFILE%.html"

}
```

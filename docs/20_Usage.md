## Usage

### Help

Use `-h` to show the help page.

```txt
     
 IML  JOBQ

Execute a list of jobs sequentially.

OPTIONS:

  -a | -add        add a new job command
  -l               list current jobs
  -r               start run to process pending jobs
  -s               show status

```

### Add a job

#### Interactive

`./jobq.sh -a`

You get two prompts to enter

* a command to execute
* optional: a working dir. It can be empty (just press return)

#### Parameters

`./jobq.sh -a <COMMAND> [<WORKING-DIR>]`

The command is a quoted string.
The working dir is optional. If you set one it must exist.

The created job is placed as a file into the ./pending/ directory

### List jobs

To see a ahort status use `./jobq.sh -s`.

To list the pending files `./jobq.sh -l`.


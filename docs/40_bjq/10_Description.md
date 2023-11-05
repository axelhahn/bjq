## How does it work?

### Add commands to the queue

You can create a command to execute what will be put into a queue.
This is what you do with 

```txt
bjq --add [<COMMAND> [<WORKINGDIR>]]
```

### Execute command list

If you start the runner parameter `bjq --run` all commands in the job queue will be executed one by one in the sequence if their addition.

If a job is finished it will watch for another job that could be added into the queue during processing existing jobs.

## Behind the scenes

The queue is handles with files.

```txt
jobs/
├── done
├── pending
└── running
```

A new command for the queue is a text file in the "pending" directory. The filename for this job file is a timestamp. The same command can be added multiple times - and will be executet in the given count.

If the runner handles a job file...

* it will be moved from "pending" to "running"
* the command will be executed
* the jobfile will be moved to the "done" directory. The output of the command is written into a file `[jobfile].ok` on exitcode 0 or `[jobfile].error` on non-zero exitcode

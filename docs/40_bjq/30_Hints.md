## Hints

### Follow the current job run

An executed job file is in the subdir ./running/
It has While it is running it writes its output into a `<JOBFILE>.out` file. 

If you start a run to process all pending jobs you can use an asterisk to follow the current job.

`tail -f ./running/*.out`

Remark: it does not follow when a new job starts. Repeat the command to see its output.

### Execute a job again

```bash
# move the job file from subdir "done" into "pending"
mv ./done/<JOBFILE> ./pending/

# optional: delete the last output
rm -f ./done/<JOBFILE>*
```

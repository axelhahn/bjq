## Installation

### Clone the repository

```txt
cd ~/scripts/
git clone https://github.com/axelhahn/bjq.git
```

### Files

```txt
.
├── bjq                      <<< a main script
├── dirwatcher               <<< a main script
├── docs
├── files
├── include                  <<< included bash files
│   ├── dirwatch.class.sh
│   └── jobq.class.sh
├── jobs
├── log
├── README.md
├── vendor                   <<< included bash files
│   └── color.class.sh
└── watchers                 <<< plugins for dirwatcher
```

### Create a softlink 

Have a look to your PATH variable. I have a users bin directory in it.
I place a softlink there:

```txt
> cd ~/bin/
> ln -s /home/axel/scrips/bjq/bjq 
```

Now in every path I can type `bjq` to acccess it.


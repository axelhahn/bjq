## Installation

### Clone the repository

```txt
cd ~/scripts/
git clone https://github.com/axelhahn/bjq.git
```

### Files

```txt
├── bjq                 <<< main script
├── docs
│   (...)
├── jobq.class.sh       <<< logic for all queuing stuff
├── jobs                <<< job files and output
│   ├── done
│   ├── pending
│   └── running
├── log                 <<< logs
│   └── jobq.log
└── vendor              <<< other included scripts
    └── color.class.sh
```

### Create a softlink 

Have a look to your PATH variable. I have a users bin directory in it.
I place a softlink there:

```txt
> cd ~/bin/
> ln -s /home/axel/scrips/bjq/bjq 
```

Now in every path I can type `bjq` to acccess it.


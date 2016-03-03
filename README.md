# docker-pwn

```sh
$ docker build -t pwn:latest .
```

```sh
$ alias pwn='docker run --privileged -ti --rm -u user -v ~/vmshare:/pwn -w /pwn -p 2323:2323 pwn bash'
$ cp pwnable ~/vmshare && pwn
user@pwn:/pwn$ socat TCP-LISTEN:2323,reuseaddr,fork EXEC:./pwnable
```

```sh
$ echo AAAA | nc $(docker-machine ip) 2323
```

*edit ~/.gdbinit for pwndbg vs. gef*

## Includes
* [Unicorn CPU emulator engine](https://github.com/unicorn-engine/unicorn.git)
* [Capstone 4](https://github.com/aquynh/capstone)
* [radare2](https://github.com/radare/radare2)
* [GDB gef](https://github.com/hugsy/gef)
* [GDB pwndbg](https://github.com/zachriggle/pwndbg)
* [rp++](https://github.com/0vercl0k/rp)
* [pwntools](https://github.com/Gallopsled/pwntools)
* tmux, vim

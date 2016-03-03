FROM ubuntu:latest
MAINTAINER capsl <c2h@c2h.se>

# setup user
RUN useradd -m user -s /bin/bash
RUN echo "user ALL=(ALL) NOPASSWD: ALL">>/etc/sudoers

# install deps
RUN apt-get update && apt-get install -y \
	socat tmux vim wget git \
	python2.7 python2.7-dev python-pip python3-pip \
	build-essential gdb binutils nasm \
	radare2 python-radare2 \
	libglib2.0-dev

# unicorn emulator
WORKDIR /tmp
RUN git clone https://github.com/unicorn-engine/unicorn.git
WORKDIR /tmp/unicorn
ENV UNICORN_ARCHS arm mips x86
RUN ./make.sh
RUN ./make.sh install
WORKDIR /tmp/unicorn/bindings/python
RUN make install3

# capstone 4
WORKDIR /tmp
RUN git clone https://github.com/aquynh/capstone
WORKDIR /tmp/capstone
RUN git checkout -t origin/next
RUN ./make.sh install
WORKDIR /tmp/capstone/bindings/python
RUN python3 setup.py install

# cleanup
WORKDIR /tmp
RUN rm -rf unicorn capstone

# pip3 install capstone is v3, fetched from git
RUN pip3 install ropgadget pycparser

# pwntools
RUN pip install pwntools

# setup user home with gdb and confs
WORKDIR /home/user

# gdb gef
RUN wget -q -O .gdbinit-gef.py https://github.com/hugsy/gef/raw/master/gef.py
RUN echo "#source ~/.gdbinit-gef.py" > .gdbinit

# pwndbg
RUN git clone https://github.com/zachriggle/pwndbg
RUN echo "source ~/pwndbg/gdbinit.py" >> .gdbinit

# perms
RUN chown -R user:user .gdb* pwndbg

# ropgadeget tool
RUN wget -q -O /usr/local/bin/rp-lin-x64 https://github.com/downloads/0vercl0k/rp/rp-lin-x64
RUN chmod 755 /usr/local/bin/rp-lin-x64

# copy conf files
COPY tmux.conf /home/user/.tmux.conf
RUN chown user:user /home/user/.tmux.conf

# Docker image of TRIQS+pomerol+pomerol2triqs


A docker image of [TRIQS](https://triqs.github.io/triqs) with [pomerol](https://github.com/aeantipov/pomerol) 
and [pomerol2triqs](https://github.com/krivenko/pomerol2triqs).

It can be used to run a Jupyter notebook environment yourself, or to run a shell for development:

* Jupyter notebook
```
docker run [--name <contailer name>] [-v <host dir>:<container dir>] -p 8888:8888 fulvwen/triqs_pomerol
```

* Command line
```
docker run [--name <contailer name>] [-v <host dir>:<container dir>] -ti fulvwen/triqs_pomerol bash
```

``pomerol2triqs.patch`` is needed for TRIQS v2.2.x.

FROM fulvwen/triqs:latest

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libeigen3-dev && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

ENV POMEROL_INSTALL_PREFIX=/opt/pomerol
ENV POMEROL2TRIQS_INSTALL_PREFIX=/opt/pomerol2triqs

ENV CPLUS_INCLUDE_PATH=/opt/pomerol/include:/opt/pomerol2triqs/include:$CPLUS_INCLUDE_PATH
ENV LIBRARY_PATH=/opt/pomerol/lib:/opt/pomerol2triqs/lib:$LIBRARY_PATH 
ENV LD_LIBRARY_PATH=/opt/pomerol/lib:/opt/pomerol2triqs/lib:$LD_LIBRARY_PATH 
ENV CMAKE_PREFIX_PATH=/opt/pomerol/share/pomerol:/opt/pomerol2triqs/share/cmake:$CMAKE_PREFIX_PATH
ENV PYTHONPATH=/opt/pomerol2triqs/lib/python2.7/site-packages:$PYTHONPATH


RUN mkdir -p $POMEROL_INSTALL_PREFIX
RUN mkdir -p $POMEROL2TRIQS_INSTALL_PREFIX

WORKDIR /tmp

COPY pomerol2triqs.patch /tmp/pomerol2triqs.patch

RUN git clone https://github.com/aeantipov/pomerol.git pomerol.src && \
    mkdir -p pomerol.build && cd pomerol.build && \
    cmake ../pomerol.src -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$POMEROL_INSTALL_PREFIX && \
    make && make install

RUN git clone https://github.com/krivenko/pomerol2triqs.git pomerol2triqs.src && \
    cd pomerol2triqs.src && patch -p1 < /tmp/pomerol2triqs.patch && cd .. &&\
    mkdir pomerol2triqs.build && cd pomerol2triqs.build && \
    cmake ../pomerol2triqs.src -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$POMEROL2TRIQS_INSTALL_PREFIX \
    -DPOMEROL_PATH=$POMEROL_INSTALL_PREFIX && \
    make && make install

ARG NB_USER=triqs
USER $NB_USER
WORKDIR /home/$NB_USER

RUN git clone https://github.com/aeantipov/pomerol.git
RUN git clone https://github.com/krivenko/pomerol2triqs.git

EXPOSE 8888
CMD ["jupyter","notebook","--ip","0.0.0.0"]

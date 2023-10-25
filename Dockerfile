FROM fulvwen/triqs:gcc-mpich

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
ENV PYTHONPATH=/opt/pomerol2triqs/lib/python3.10/site-packages:$PYTHONPATH


RUN mkdir -p $POMEROL_INSTALL_PREFIX
RUN mkdir -p $POMEROL2TRIQS_INSTALL_PREFIX

RUN git clone --depth 1 https://github.com/pomerol-ed/pomerol.git /tmp/pomerol.src && \
    mkdir -p /tmp/pomerol.build && cd /tmp/pomerol.build && \
    cmake /tmp/pomerol.src -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$POMEROL_INSTALL_PREFIX -DTESTS=OFF && \
    make && make install && \
    rm -rf /tmp/pomerol.src /tmp/pomerol.build

RUN git clone --depth 1 https://github.com/pomerol-ed/pomerol2triqs.git /tmp/pomerol2triqs.src && \
    mkdir /tmp/pomerol2triqs.build && cd /tmp/pomerol2triqs.build && \
    cmake /tmp/pomerol2triqs.src -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$POMEROL2TRIQS_INSTALL_PREFIX \
    -DPOMEROL_PATH=$POMEROL_INSTALL_PREFIX && \
    make && make install && \
    rm -rf /tmp/pomerol2triqs.src /tmp/pomerol2triqs.build

ARG NB_USER=triqs
USER $NB_USER
WORKDIR /home/$NB_USER

RUN git clone --depth 1 https://github.com/pomerol-ed/pomerol.git
RUN git clone --depth 1 https://github.com/pomerol-ed/pomerol2triqs.git

EXPOSE 8888
CMD ["jupyter","notebook","--ip","0.0.0.0"]

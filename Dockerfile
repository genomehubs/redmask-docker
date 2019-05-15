FROM debian:stretch
MAINTAINER Richard Challis rjchallis@gmail.com

RUN apt-get update && apt-get install -y \
    g++ \
    gcc \
    git \
    gzip \
    make \
    wget

WORKDIR /tmp

RUN wget http://toolsmith.ens.utulsa.edu/red/data/DataSet1Src.tar.gz && \
    tar xf DataSet1Src.tar.gz

RUN mkdir /RepeatDetector && \
    mv src /RepeatDetector 

WORKDIR /RepeatDetector/src

RUN make bin && \
    make

ENV PATH="/RepeatDetector/bin:${PATH}"

WORKDIR /

RUN git clone https://github.com/nextgenusfs/redmask

RUN sed -i 's/xrange/range/' redmask/redmask.py

ENV PATH="/redmask:${PATH}"

RUN mkdir /data && mkdir /out

RUN adduser --disabled-password --gecos '' dockeruser

RUN chown -R dockeruser /data

WORKDIR /data

RUN apt-get install -y python3 python3-pip

RUN pip3 install --upgrade biopython

RUN pip3 install natsort

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

COPY startup.sh /

USER dockeruser

CMD /startup.sh

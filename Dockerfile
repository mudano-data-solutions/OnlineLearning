# keep tags, never use latest else it will just keep changing.
FROM debian:buster

# build the container with this tag. use a different tag for your project.
#  docker build . -t mudano/anaconda3
#  docker run --rm --init -p 8888:8888 mudano/anaconda3

# mount with local folder files, in mac and linux
#  docker run --rm --init -p 8888:8888 -v "$(pwd)":/home/mudano/ mudano/anaconda3

# no idea how to do this in windows...i think this might work
#  docker run --rm --init -p 8888:8888 -v %cd%:/home/mudano/ mudano/anaconda3


# start container in background, mount this folder. 
# -d is detached mode. 
# -v mounts a volume of the local folder inside the container
# --rm cleanup, deletes all the files on the container. Good idea to not keep anything inside the container
# docker run --rm --init -d -p 8888:8888 -v "$(pwd)":/home/mudano/ mudano/anaconda3 /bin/bash ./my_startup.sh

# just start up with bash.
#  $ docker run --rm --init -it -p 8888:8888 mudano/anaconda3 /bin/bash


ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc


RUN apt install -y libboost-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev libboost-math-dev libboost-test-dev libboost-python-dev zlib1g-dev cmake python3 python3-pip
RUN pip install vowpalwabbit

RUN git clone https://github.com/VowpalWabbit/vowpal_wabbit.git
RUN cd vowpal_wabbit; make; make install
		
EXPOSE 8888

RUN useradd -ms /bin/bash mudano
USER mudano
WORKDIR /home/mudano
ENV SHELL=/bin/bash


#feel free to edit the base from here onwards.
#RUN jupyter notebook --ip=0.0.0.0 --port=8888 --NotebookApp.token=''
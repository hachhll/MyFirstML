FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive LANG=C TZ=UTC
ENV TERM linux

# for Apache Spark demos
ENV APACHE_SPARK_VERSION 3.2.1
ENV APACHE_SPARK_CUSTOM_NAME=hadoop3.2

# install some basic utilities
RUN set -xue ;\
    apt-get update ;\
    apt-get install -y --no-install-recommends \
        build-essential \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libglib2.0-0 \
        wget \
        vim \
        python3-dev \
        python3-pip \
    ;\
    rm -rf /var/lib/apt/lists/*


# install java 8
RUN apt-get install -y --no-install-recommends software-properties-common ;\
    add-apt-repository -y ppa:openjdk-r/ppa ;\
    apt-get update ;\
    apt-get install -y openjdk-8-jdk ;\
    apt-get install -y openjdk-8-jre ;\
    update-alternatives --config java ;\
    update-alternatives --config javac ;\
    rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install spark
RUN cd /tmp && \
    wget -q https://archive.apache.org/dist/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-${APACHE_SPARK_CUSTOM_NAME}.tgz && \
    tar xzf spark-${APACHE_SPARK_VERSION}-bin-${APACHE_SPARK_CUSTOM_NAME}.tgz -C /usr/local && \
    rm spark-${APACHE_SPARK_VERSION}-bin-${APACHE_SPARK_CUSTOM_NAME}.tgz

RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-${APACHE_SPARK_CUSTOM_NAME} spark
ENV SPARK_HOME /usr/local/spark


# install libs and frameworks
RUN pip3 install --upgrade pip ;\
    pip3 install setuptools ;\
    pip3 install numpy ;\
    pip3 install matplotlib ;\
    pip3 install opencv-python ;\
    pip3 install torch torchvision ;\
    pip3 install tensorflow ;\
    pip3 install nodejs ;\
    pip3 install toree ;\
    pip3 install jupyterlab

RUN jupyter toree install --spark_home=$SPARK_HOME

WORKDIR /playground

# run the command
#CMD ["/bin/bash"]
CMD ["jupyter", "lab", "--port=8789", "--no-browser", "--ip=0.0.0.0", "--allow-root"]

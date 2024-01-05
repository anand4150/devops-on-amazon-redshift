FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc && \
    apt-get install python3-setuptools -y && \
    apt-get install --no-install-recommends -y python3.7 python3-pip python3-dev && \
    apt-get install --no-install-recommends -y build-essential && \
    #apt-get install --no-install-recommends -y python3-devel &&\
    # apt-get install --no-install-recommends -y vim && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/\* /var/tmp/*

RUN pip3 install --upgrade pip setuptools


#RUN apt-get -y install build-essential
#RUN apt-get -y install python3
#RUN apt-get -y install python3-pip
#RUN pip3 install time

# Requirements, commented now
# RUN pip3 install cython # Cython==3.0.6
# RUN pip3 install numpy  # numpy==1.24.4
# RUN pip3 install pandas # pandas==2.0.3
# RUN pip3 install boto3  # boto3==1.33.12
# RUN pip3 install configparser # configparser==6.0.0
# RUN pip3 install dataclasses # dataclasses==0.6

# Install AWS CLI V2
RUN mkdir /src
RUN mkdir /src/output_data
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Removing Code files from image
# COPY src/RedshiftEphemeral.py /src/RedshiftEphemeral.py
# COPY src/__init__.py /src/__init__.py
# COPY src/python_client_redshift_ephemeral.py /src/python_client_redshift_ephemeral.py
# COPY src/dw_config.ini /src/dw_config.ini
# COPY src/query_redshift_api.ini /src/query_redshift_api.ini
COPY src/requirements.txt /src/requirements.txt
WORKDIR "/src"
RUN pip3 install -r requirements.txt
RUN pip3 freeze

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV PERL_MM_USE_DEFAULT 1
ENV TZ=Europe/London

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y cron libdbd-sqlite3-perl python-pip unzip wget ssh-client libnet-amazon-ec2-perl rsync libdata-dumper-simple-perl lame vorbis-tools clamav ssmtp mailutils git zip

RUN pip install --upgrade pip
RUN pip install --upgrade google-api-python-client progressbar2

RUN mkdir /install
RUN cd /install && wget https://github.com/tokland/youtube-upload/archive/master.zip && unzip master.zip && cd youtube-upload-master && python setup.py install
RUN rm -rf /install

RUN perl -MCPAN -e 'install WebService::Amazon::Route53'

RUN mkdir /data
RUN mkdir /data/cronjobs
RUN rm -rf /etc/cron.d && ln -s /data/cronjobs /etc/cron.d
RUN rm /etc/ssmtp/ssmtp.conf && touch /data/ssmtp.conf && ln -s /data/ssmtp.conf /etc/ssmtp/ssmtp.conf
RUN touch /data/id_rsa && touch /data/id_rsa.pub && mkdir /root/.ssh && ln -s /data/id_rsa /root/.ssh/id_rsa && ln -s /data/id_rsa.pub /root/.ssh/id_rsa.pub && touch /data/known_hosts && ln -s /data/known_hosts /root/.ssh/known_hosts


CMD ["cron", "-f"]

FROM quay.io/aptible/java:oracle-java7

RUN apt-get update && apt-get -y install nginx --no-install-recommends

#=== Install Mirth

WORKDIR /usr/local/mirthconnect

ADD templates/mirthconnect/mirthconnect-install-wrapper-3.3.1.sh \
     /usr/local/mirthconnect/mirthconnect-install-wrapper-3.3.1.sh

RUN wget http://downloads.mirthcorp.com/connect/3.3.1.7856.b91/mirthconnect-3.3.1.7856.b91-unix.sh \
  && chmod +x mirthconnect-3.3.1.7856.b91-unix.sh \
  && ./mirthconnect-install-wrapper-3.3.1.sh

ADD templates/etc /etc
ADD templates/mirthconnect /usr/local/mirthconnect

RUN chmod +x setup-config.sh

#=== Install DB certificate, pulling from .aptible.env

WORKDIR /tmp/certmunge

# Need to do this to get .aptible.env, without bombing when building somewhere
# besides aptible
ADD . /tmp/certmunge 
RUN chmod +x bin/setup-keystore.sh
RUN bin/setup-keystore.sh
WORKDIR /usr/local/mirthconnect
RUN rm -rf /tmp/certmunge

#=== Expose and run

EXPOSE 3000 9661

CMD ./setup-config.sh && ./mirthconnect-wrapper.sh

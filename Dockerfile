FROM ubuntu:14.04
ENV REALM_NAME TEST.ELASTIC.CO
ADD src /src
RUN echo kerberos.test.elastic.co > /etc/hostname && echo "127.0.0.1 kerberos.test.elastic.co" >> /etc/hosts
RUN bash /src/main/resources/provision/installkdc.sh

RUN \
kadmin.local -q "addprinc -pw changeme HTTP/ac7c8d9bfb8644c3875f827d816c8ed3.18.212.229.175.ip.es.io@$REALM_NAME" && \
kadmin.local -q "addprinc -pw changeme HTTP/localhost@$REALM_NAME" && \
kadmin.local -q "ktadd -k /root/es.keytab HTTP/ac7c8d9bfb8644c3875f827d816c8ed3.18.212.229.175.ip.es.io@$REALM_NAME" && \
kadmin.local -q "ktadd -k /root/es.keytab HTTP/localhost@$REALM_NAME" && \
kadmin.local -q "addprinc -pw changeme dev@$REALM_NAME" && \
kadmin.local -q "ktadd -k /root/dev.keytab dev@$REALM_NAME"

EXPOSE 88
EXPOSE 88/udp

CMD /usr/sbin/krb5kdc -n

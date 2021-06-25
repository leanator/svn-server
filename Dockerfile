FROM centos:7



ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

COPY files/* /

RUN yum install -y httpd net-tools subversion mod_dav_svn
RUN yum clean all
RUN sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf
RUN sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
RUN rm -f /etc/httpd/conf.modules.d/10-subversion.conf
RUN cp /10-subversion.conf /etc/httpd/conf.modules.d/10-subversion.conf
RUN mkdir -p /svn
RUN mkdir -p /etc/svn

RUN cd /svn &&  svnadmin create repo1

RUN chown -R apache:apache /svn/repo1


RUN htpasswd -cmb /etc/svn/svn-auth user001 password
RUN chmod 640 /etc/svn/svn-auth
RUN rm -f /svn/repo1/conf/authz /svn/authz
RUN cp /authz /svn/repo1/conf/authz
RUN cp /authz /svn/authz
RUN chown root:apache /etc/svn/svn-auth
RUN httpd

#RUN chmod 755 /install.sh && /install.sh

EXPOSE 80 8080

CMD ["/usr/sbin/init"]
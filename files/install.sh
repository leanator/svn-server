#https://www.vultr.com/docs/how-to-setup-an-apache-subversion-svn-server-on-centos-7

yum install -y httpd net-tools subversion mod_dav_svn
yum clean all
sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf
sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
rm -f /etc/httpd/conf.modules.d/10-subversion.conf
cp /10-subversion.conf /etc/httpd/conf.modules.d/10-subversion.conf
mkdir -p /svn
cd /svn
svnadmin create repo1
chown -R apache:apache /svn/repo1
mkdir -p /etc/svn
htpasswd -cmb /etc/svn/svn-auth user001 password
chown root:apache /etc/svn/svn-auth
chmod 640 /etc/svn/svn-auth
rm -f /svn/repo1/conf/authz /svn/authz
cp /authz /svn/repo1/conf/authz
cp /authz /svn/authz
httpd
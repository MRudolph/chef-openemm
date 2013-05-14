#
# Cookbook Name:: openemm
# Recipe:: default
#
# Copyright 2013
#
# All rights reserved - Do Not Redistribute
#
package "python-mysqldb" do
end
package "sendmail-cf" do
end
package "ia32-libs" do
end
package "sendmail" do
end
tomcat_file = "http://artfiles.org/apache.org/tomcat/tomcat-6/v6.0.36/bin/apache-tomcat-6.0.36.tar.gz"
tomcat_folder = tomcat_file.match(/[^\/]+(?=\.tar\.gz$)/)[0]     
script "install_tomcat" do
  interpreter "bash"
  user "root"
  code <<-EOH
    mkdir -p /opt/openemm &&
    cd /opt/openemm &&
    wget  #{tomcat_file} &&
    tar -xvzf  #{tomcat_folder}.tar.gz &&
    ln -s #{tomcat_folder} tomcat
    ln -s $JAVA_HOME java
  EOH
end



group node["openemm"]["sysgroup"] do
  action :create
end

user "openemm" do
  comment "OpenEMM User"
  gid node["openemm"]["sysgroup"]
  home '/home/openemm'
  supports :manage_home => true, :non_unique => false
end

group "adm" do
  action :modify
  members "openemm"
  append true
end

script "install_openemm" do
  not_if "ls /home/openemm/bin"
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  wget -O openemm.tar.gz #{node["openemm"]["bin_tarball_url"]}
  cd /home/openemm
  tar xzvf /tmp/openemm.tar.gz
  chown -R openemm:openemm .bash* *
  chown root:root bin/smctrl
  chown root:root conf/bav/bav.rc
  chmod 6755 bin/smctrl
  chmod 0600 conf/bav/bav.rc
  EOH
end




link "/var/log/maillog" do
  to "/var/log/mail.log"
end
db =    ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
mysql_database 'openemm_cms' do
  connection db
  action :create
end

mysql_database "openemm_cms" do
  connection db
  sql { ::File.open("/home/openemm/USR_SHARE/openemm_demo-cms-2013.sql").read }
  action :query
end
mysql_database 'openemm' do
  connection db
  action :create
end

mysql_database "openemm" do
  connection db
  sql { ::File.open("/home/openemm/USR_SHARE/openemm-2013.sql").read }
  action :query
end

#TODO Bounce Management

__END__
execute "set emm http adress" do
  command "sed \"s/^system.url=.*$/system.url=#{node["openemm"]["frontend_url"]}/g\" emm.properties > emm.properties"
  cwd "/home/openemm/webapps/openemm/WEB-INF/classes"
  action :run
end
execute "set cmd http adress" do
  command "sed \"s/^ cms.ccr.url=.*$/system.url=#{node["openemm"]["frontend_url"]}/g\" cms.properties > cms.properties"
  cwd "/home/openemm/webapps/openemm/WEB-INF/classes"
  action :run
end




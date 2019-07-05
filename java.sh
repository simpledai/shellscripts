mkdir -p /opt/java

tar zxvf jdk-8u51-linux-x64.tar.gz -C /opt/java  > /dev/null 2>&1

echo '# JAVA-8u51' >> /etc/profile
echo 'JAVA_HOME=/opt/java/jdk1.8.0_51' >> /etc/profile
echo 'JAVA_BIN=/opt/java/jdk1.8.0_51/bin' >> /etc/profile
echo 'PATH=$PATH:$JAVA_BIN' >> /etc/profile
echo 'CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> /etc/profile
echo 'export JAVA_HOME JAVA_BIN PATH CLASSPATH' >> /etc/profile

source  /etc/profile
echo "java is already installed,please open another session to test it " 

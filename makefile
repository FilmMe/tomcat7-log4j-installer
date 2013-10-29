#
# Installer make script
#

LOG4J_VER=1.2.17
TOMCAT_VER=v7.0.47
THIS=tomcat7-log4j

info:
	# how-to-use
	echo "use:"
	echo "make info       - this message"
	echo "make install    - installs $(THIS) on this computer"
	echo "make uninstall  - removes $(THIS) from this computer"
	echo "make build      - creates $(THIS).deb"

install: resources
	# call pre-install sript
	src/postinst
	# copy installable contents
	cp $(THIS)/usr/share/java/* /usr/share/java/
	cp $(THIS)/usr/share/tomcat7/lib/* /usr/share/tomcat7/lib/
	# call post-install sript
	src/postinst

uninstall:
	# call pre-remove sript
	src/prerm
	# remove installables
	rm /usr/share/java/tomcat-juli-log4j.jar
	rm /usr/share/java/tomcat-juli-adapters.jar
	rm /usr/share/tomcat7/lib/log4j.properties
	# call pre-remove sript
	src/postrm

build: resources controls
	# create deb file
	fakeroot dpkg-deb --build $(THIS)

clean:
	rm -R $(THIS)

resources:
	mkdir -p $(THIS)/usr/share/java/
	# get and prepare java files
	cd $(THIS)/usr/share/java/
	wget http://archive.apache.org/dist/logging/log4j/$(LOG4J_VER)/log4j-$(LOG4J_VER).jar
	mv -f log4j-$(LOG4J_VER).jar $(THIS)/usr/share/java/
	wget http://www.dsgnwrld.com/am/tomcat/tomcat-7/$(TOMCAT_VER)/bin/extras/tomcat-juli.jar
	mv -f tomcat-juli.jar $(THIS)/usr/share/java/tomcat-juli-log4j.jar
	wget http://www.dsgnwrld.com/am/tomcat/tomcat-7/$(TOMCAT_VER)/bin/extras/tomcat-juli-adapters.jar
	mv -f tomcat-juli-adapters.jar $(THIS)/usr/share/java/
	# prepare logging configuration
	mkdir -p $(THIS)/usr/share/tomcat7/lib/
	cp -f src/log4j.properties $(THIS)/usr/share/tomcat7/lib/

controls:
	mkdir -p $(THIS)/DEBIAN/
	cp -f src/control $(THIS)/DEBIAN/
	cp -f src/preinst $(THIS)/DEBIAN/
	cp -f src/postinst $(THIS)/DEBIAN/
	cp -f src/prerm $(THIS)/DEBIAN/
	cp -f src/postrm $(THIS)/DEBIAN/
	cp -f src/copyright $(THIS)/DEBIAN/




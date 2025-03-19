name    = bwreceive
version = 0.1.1
debpkg  = $(name)_$(version)_all.deb
prefix  = debian/usr


.PHONY: all clean
.SILENT: clean $(debpkg)

all: $(debpkg)

clean:
	echo Cleaning up debian dir
	rm -rf $(prefix) $(debpkg)

$(debpkg):
	echo Generating $(debpkg)
	pip --quiet install --isolated --ignore-installed --no-deps --prefix $(prefix) $(name)
	mv $(prefix)/lib/python3.* $(prefix)/lib/python3
	rename site dist $(prefix)/lib/python3/site-packages
	
	mkdir -p $(prefix)/share/doc
	bzip2 -kc README.md > $(prefix)/share/doc/README.bz2
	
	mkdir -p $(prefix)/share/applications
	cp bwreceive.desktop $(prefix)/share/applications
	
	dpkg-deb --root-owner-group --build debian $(debpkg) > /dev/null

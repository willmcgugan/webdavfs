all: install test 

release:
	mkrelease -p -d pypi

install:
	virtualenv .
	bin/pip install -U pip
	bin/pip install -U setuptools
	bin/python setup.py develop

test:
	bin/pip install nose
	/usr/bin/python -c "import os; os.system('docker rm -f existdb30')"
	docker run -d -p 127.0.0.1:10080:8080 --name existdb30 zopyx/existdb-30
	sleep 30
	FS_WEBDAV_URL=http://admin:admin@localhost:10080/exist/webdav/db bin/nosetests -v webdavfs

test-existdb-22:
	bin/pip install nose
	/usr/bin/python -c "import os; os.system('docker rm -f existdb22')"
	docker run -d -p 127.0.0.1:10082:8080 --name existdb22 zopyx/existdb-22
	sleep 30
	FS_WEBDAV_URL=http://admin:admin@localhost:10082/exist/webdav/db bin/nosetests -v webdavfs

test-basex:
	bin/pip install nose
	/usr/bin/python -c "import os; os.system('docker rm -f basex')"
	docker run -d -p 127.0.0.1:10081:8080 --name basex zopyx/basex-86
	sleep 10
	FS_WEBDAV_URL=http://admin:admin@localhost:10081/webdav/ bin/nosetests -v webdavfs


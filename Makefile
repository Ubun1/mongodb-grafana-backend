package = mongodb-backend-grafana
tarname = $(package)
version = 0.8.4
distdir = $(tarname)-$(version)

dist: $(tarname).tar.gz

$(tarname).tar.gz: $(distdir)
	tar chof - $(distdir) | gzip -9 -c > $@
	rm -rf $(distdir)

$(distdir): ; mkdir -p $(distdir)

all: grunt build dist

grunt: $(distdir) 
	mkdir -p ./dist/
	docker run -v $$(pwd):/root/proj node bash -c "cd /root/proj && npm install . && npm install -g -y grunt && grunt --force"
	cp -r ./dist/* $(distdir)
	sudo rm -rf ./dist

build: $(distdir)
	go build -o ./$(distdir)/mongodb-be-plugin_linux_amd64 ./pkg/

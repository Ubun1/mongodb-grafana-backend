package = mongodb-grafana-backend
tarname = $(package)
version = 0.8.4
distdir = $(tarname)-$(version)

all: grunt build dist
dist: $(tarname).zip

$(tarname).zip: $(distdir)
	zip -r $@ $(distdir)
	rm -rf $(distdir)

$(distdir): ; mkdir -p $(distdir)


grunt: $(distdir) 
	mkdir -p ./dist/
	docker run -v $$(pwd):/root/proj node bash -c "cd /root/proj && npm install . && npm install -g -y grunt && grunt --force"
	cp -r ./dist/* $(distdir)
	sudo rm -rf ./dist

build: $(distdir)
	go build -o ./$(distdir)/mongodb-be-plugin_linux_amd64 ./pkg/

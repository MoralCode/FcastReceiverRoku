setup:
	npm install brighterscript -g

build:
	bsc

clean:
	rm -r out/ dist/

deploy:
	. .env.sh
	bsc --deploy --host "${ROKU_HOST}" --password "${ROKU_PASSWORD}"
CSS=$(shell find assets/css -type f -name *.css -not -name *.min.css)
JS=$(shell find assets/js -type f -name *.js -not -name *.min.js)

all: $(CSS) $(JS)
	jekyll build

%.min.css: %.css
	cssmin $< > $@

%.min.js: %.js
	uglifyjs $< > $@

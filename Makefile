CSS=$(shell find assets/css -type f -name *.css -not -name *.min.css)
JS=$(shell find assets/js -type f -name *.js -not -name *.min.js)

minify: $(patsubst %.css,%.min.css,$(CSS)) $(patsubst %.js,%.min.js,$(JS))

%.min.css: %.css
	cssmin $< > $@

%.min.js: %.js
	uglifyjs $< > $@

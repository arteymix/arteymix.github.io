CSS_FILES = $(shell find assets/css -type f -name *.css -not -name *.min.css)
JS_FILES = $(shell find assets/js -type f -name *.js -not -name *.min.js)

all: minify
	jekyll build

minify: $(CSS_FILES) $(JS_FILES)

$(CSS_FILES):
	cssmin $@ > $(basename $@).min.css

$(JS_FILES):
	uglifyjs $@ > $(basename $@).min.js

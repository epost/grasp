grammar=jison/grasp.jison
parser=build/grasp.js
parse=node ${parser}
extension=grasp

all: ${parser}
	@echo "making all..."
	make build/graph1.png

parser: ${parser}

${parser}: ${grammar}
	mkdir -p build
	./node_modules/.bin/jison ${grammar} -o ${parser}

build/%.json: examples/%.grasp ${parser}
	${parse} $< > $@

%.dot: %.json
	node js/grasp2dot.js $< > $@

%.png: %.dot
	dot -Kdot -Tpng $< > $@

clean:
	rm build/*

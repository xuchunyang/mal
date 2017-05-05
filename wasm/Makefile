all: step0_repl.wasm

.SECONDARY:

%.wasm: %.wast
	wasm-as $< -o $@

.PHONY: clean

clean:
	rm -f *.wasm

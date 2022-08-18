const stream = require("stream");
const lzip = require("./lib/lzip");

// pipable lunzip utilizing lzip comiled with emscripten
const lunzip = module.exports = function lunzip(){
	if (!(this instanceof lunzip)) return new lunzip();
	
	// array of buffers received from steam
	let input = [];
	
	// create transform stream
	const t = new stream.Transform({
		transform: function(chunk, encoding, fn) {
			// collect buffers frim stream into array, concat them later
			// because the interface to lzip works synchronously :(
			input.push(chunk), fn();
		},
		flush: function(fn) {

			// collect output bytes
			let collect = [];
			
			let idx = 0;
			
			const data = new Uint8Array(Buffer.concat(input));

			try {
				lzip({
					arguments: ["-d","-q"],
					stdin: function(){
						// read input data
						return idx < data.length ? data[idx++] : null
					},
					stdout: function(chunk){
						collect.push(chunk);
					
						// emit in chunks of 4096 bytes
						// if collect
						if (collect.length === 4096) {
							t.emit("data", Buffer.from(collect));
							collect = [];
						}
					},
					postRun: function(){
						// emit leftovers
						t.emit("data", Buffer.from(collect));

						// end stream
						fn();
					}
				});
			
			} catch(err) {
				t.emti("error", err);
				fn();
			}

		}
	});

	// return stream
	return t;
};

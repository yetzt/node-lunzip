# lunzip

lunzip is a stream decompressor for data compressed with (GNU lzip)[https://www.nongnu.org/lzip/] vie emscripten.

## usage example

``` javascript

const fs = require("fs");
const lunzip = require("lunzip-stream");

fs.createReadStream("file.lz").pipe(lunzip()).pipe(fs.createWriteStream("file"));

```

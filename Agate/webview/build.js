var exec = require('child_process').exec

function build() {
  exec('tsc --out target/Webview.js Webview.ts',
    function (error, stdout, stderr) {
      console.log(stdout);
      if(stderr !== '')
        console.log('stderr: ' + stderr);
      if (error !== null)
        console.log('exec error: ' + error);
  });
}

build();

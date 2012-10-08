# see http://code.google.com/chrome/extensions/manifest.html
fs = require 'fs'
pkg = JSON.parse fs.readFileSync 'package.json'

name: pkg.name
version: pkg.version
manifest_version: 2
description: pkg.description
icons: {}
content_scripts: [
  matches: [ "<all_urls>" ]
  js: [ 'hook.js', 'main.js']
  run_at: "document_start"
]

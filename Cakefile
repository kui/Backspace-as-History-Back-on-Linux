# -*- coding:utf-8-unix; mode:coffee; -*-

USERSCRIPT = 'backspace_as_browser_back_on_linux.user.js'

##

SOURCE_DIR = 'src'
SOURCE_FILENAMES = ['hook', 'main']
OUTPUT_DIR = 'build'
TEST_DIR = 'test'
COFFEE = 'coffee'
MOCHA = "node_modules/.bin/mocha"
PACKAGE_JSON = 'package.json'

cp = require 'child_process'
util = require 'util'
path = require 'path'
fs = require 'fs'

eachLine = (str, cb) ->
  cb line for line in str.split /\r?\n/

logEachLine = (str) ->
  eachLine str, (line) -> util.log line

execCallback = (err, stdout, stderr) ->
  logEachLine stdout if stdout
  logEachLine stderr if stderr

  if err
    util.log '=> fail'
    process.exit 1
  else
    util.log '=> success'

mkdirUnlessExists = (dirName) ->
  fs.mkdirSync dirName unless path.existsSync dirName

# generate hte userscript header
generateUSHeader = ->
  pkg = JSON.parse fs.readFileSync PACKAGE_JSON
  propNames = ['name', 'description', 'homepage', 'version']

  unless (propNames.reduce (a, b) -> a and b)
    throw "provide props(#{prop_names.join ', '}) for #{PACKAGE_JSON}"

  """
  // ==UserScript==
  // @name #{pkg.name}
  // @description #{pkg.description} (WebPage: #{pkg.homepage})
  // @namespace #{pkg.homepage}
  // @version #{pkg.version}
  // @match <all_urls>
  // ==/UserScript==


  """

task 'build', "Build #{OUTPUT_DIR}/#{USERSCRIPT} from src/*.coffee", ->
  mkdirUnlessExists OUTPUT_DIR
  srcFiles = ("\"#{SOURCE_DIR}/#{f}.coffee\"" for f in SOURCE_FILENAMES).join ' '

  coffee = "#{COFFEE} --print --compile --join -- #{srcFiles}"
  echoHeader = 'cat -'
  cmd = "(#{echoHeader}; #{coffee}) > #{OUTPUT_DIR}/#{USERSCRIPT}"

  util.log '$ '+cmd
  proc = cp.exec cmd, (err, stdout, stderr) ->
    execCallback err, stdout, stderr

  proc.stdin.end generateUSHeader()

task 'clean', "Remove all generated files", ->
  cmd = "rm -fr #{OUTPUT_DIR} #{TEST_DIR}/*.js"
  util.log '$ '+cmd
  cp.exec cmd, execCallback

task 'test:unit', "Run all unit tests on #{TEST_DIR}", ->
  for testFile in fs.readdirSync TEST_DIR
    continue unless m = testFile.match /^(.*)_test.coffee$/
    testFile = "#{TEST_DIR}/#{m[0]}"
    util.log "test: #{testFile}"

    srcFile = "#{SOURCE_DIR}/#{m[1]}.coffee"
    unless path.existsSync srcFile
      util.log "not found a src file (#{srcFile})"
      continue
    util.log "src:  #{srcFile}"

    jsFile = "#{TEST_DIR}/#{m[1]}_test.js"
    compileCmd = "#{COFFEE} --compile --join #{jsFile} #{srcFile} #{testFile}"

    util.log '$ '+compileCmd
    cp.exec compileCmd, (err, stdout, stderr) ->
      execCallback err, stdout, stderr
      mochaCmd = "#{MOCHA} #{jsFile}"
      util.log '$ '+mochaCmd
      cp.exec mochaCmd, execCallback


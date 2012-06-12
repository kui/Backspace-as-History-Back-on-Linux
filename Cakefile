# -*- coding:utf-8-unix; mode:coffee; -*-

USERSCRIPT = 'backspace_as_browser_back_on_linux.user.js'

##

SOURCE_DIR = 'src'
OUTPUT_DIR = 'build'
TEST_DIR = 'test'
COFFEE = 'coffee'

{exec} = require 'child_process'
util = require 'util'
path = require 'path'
fs = require 'fs'

execCallback = (err, stdout, stderr) ->
  util.log stdout if stdout
  util.log err if err
  # util.debug stderr if stderr
  if err
    util.log 'fail'
  else
    util.log 'success'

task 'build', "Build #{OUTPUT_DIR}/#{USERSCRIPT} from src/*.coffee", ->
  fs.mkdirSync OUTPUT_DIR unless path.existsSync OUTPUT_DIR
  cmd = "#{COFFEE} --compile --join #{OUTPUT_DIR}/#{USERSCRIPT} #{SOURCE_DIR}"
  util.log cmd
  exec cmd, execCallback

task 'clean', "Remove all generated files", ->
  cmd = "rm -fr #{OUTPUT_DIR} #{TEST_DIR}/*.js"
  util.log cmd
  exec cmd, execCallback


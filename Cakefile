# -*- coding:utf-8-unix; mode:coffee; -*-

USERSCRIPT = 'backspace_as_browser_back_on_linux.user.js'

##

SOURCE_DIR = 'src'
OUTPUT_DIR = 'build'
COFFEE = 'coffee'

{exec} = require 'child_process'
util = require 'util'

task 'build', "Build #{OUTPUT_DIR}/#{USERSCRIPT} from src/*.coffee", ->
  cmd = "#{COFFEE} --compile --join #{OUTPUT_DIR}/#{USERSCRIPT} #{SOURCE_DIR}"
  util.log cmd
  exec cmd, (err, stdout, stderr) ->
    util.debug err if err
    util.log stdout if stdout
    util.debug stderr if stderr
    if err
      util.log 'fail'
    else
      util.log 'success'

# -*- coding:utf-8-unix; mode:coffee; -*-

USERSCRIPT = 'backspace_as_browser_back_on_linux.user.js'

##

SOURCE_DIR = 'src'
OUTPUT_DIR = 'build'
TEST_DIR = 'test'
COFFEE = 'coffee'
PACKAGE_JSON = 'package.json'

cp = require 'child_process'
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
  // @include https?://*
  // ==/UserScript==


  """

task 'build', "Build #{OUTPUT_DIR}/#{USERSCRIPT} from src/*.coffee", ->
  fs.mkdirSync OUTPUT_DIR unless path.existsSync OUTPUT_DIR
  coffee = "#{COFFEE} --print --compile --join -- #{SOURCE_DIR}"
  echoHeader = 'cat -'
  cmd = "(#{echoHeader}; #{coffee}) > #{OUTPUT_DIR}/#{USERSCRIPT}"
  util.log cmd
  proc = cp.exec cmd, execCallback
  proc.stdin.end generateUSHeader()

task 'clean', "Remove all generated files", ->
  cmd = "rm -fr #{OUTPUT_DIR} #{TEST_DIR}/*.js"
  util.log cmd
  cp.exec cmd, execCallback

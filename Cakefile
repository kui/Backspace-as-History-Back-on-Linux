# -*- coding:utf-8-unix; mode:coffee; -*-

# commands ####################################################################
MOCHA = 'node_modules/.bin/mocha'
COFFEE = 'node_modules/.bin/coffee'
GOOGLE_CHROME = 'google-chrome'

# files or dirs ###############################################################
PACKAGED_FILES = [
  'manifest.json'
  'hook.js'
  'main.js'
]
SOURCE_DIR = 'src'
TEST_DIR = 'test'
MANIFEST_COFFEE = "#{SOURCE_DIR}/manifest.coffee"

# tasks #######################################################################
task 'build', 'build crx', ->
  manifest = getManifest()

  # create a buid dir
  build = getBuildDirName(manifest)
  mkdirUnlessExists build

  log "generate manifest.json"
  manifestJsonPath = getManifestJsonPath()
  json = JSON.stringify manifest
  fs.writeFileSync manifestJsonPath, json
  log "=> Success"

  pemFile = "#{build}.pem"
  packagedFiles = ("'#{SOURCE_DIR}/#{f}'" for f in PACKAGED_FILES).join ' '
  cmplCmd = """
    #{COFFEE} --bare --compile #{SOURCE_DIR};
    cp -v #{packagedFiles} #{build}
  """
  pkgCmd = "#{GOOGLE_CHROME} --no-message-box --pack-extension='#{build}'"
  pkgCmd += " --pack-extension-key='#{pemFile}'" if fs.existsSync pemFile

  cmplCb = (code) ->
    exec2 pkgCmd, pkgCb if code is 0
  pkgCb = (code) ->
    log 'ERROR: try to package manually on GUI' if code isnt 0

  exec2 cmplCmd, cmplCb


task 'clean', "Remove all generated files", ->
  manifest = getManifest()
  build = getBuildDirName(manifest)
  manifestJsonPath = getManifestJsonPath()

  targets = listPathsByExt 'crx', '.'
  targets = targets.concat listPathsByExt 'js', '.'
  targets.push manifestJsonPath if fs.existsSync manifestJsonPath
  targets.push build if fs.existsSync build
  targets = ("'#{f}'" for f in targets)

  if targets.length == 0
    log 'not found files to remove'
    return

  cmd = "rm -v -r #{targets.join ' '}"

  exec2 cmd, ->


task 'test', "Run all unit tests on #{TEST_DIR}", ->
  testFiles = listPathsByExt 'coffee', TEST_DIR
  srcFiles = listPathsByExt 'coffee', SOURCE_DIR
  srcFilesStr = ("'#{c}'" for c in srcFiles).join ' '

  next = ()->
    f = testFiles.shift()
    mainTest f if f

  mainTest = (testFile) ->
    unless m = testFile.match /(.+?\/)?[^\/]+_test\.coffee$/
      next()
      return
    log "test: #{testFile}"

    srcFile = testFile.replace(TEST_DIR, SOURCE_DIR)
      .replace(/_test\.coffee/, '.coffee')
    unless fs.existsSync srcFile
      log "not found a src file (#{srcFile})"
      next()
      return
    log "src:  #{srcFile}"

    jsFile = testFile.replace /\.coffee$/, '.js'

    cmplCmd = "#{COFFEE} --compile --join '#{jsFile}' #{srcFilesStr} '#{testFile}'"
    cmplCb = (code) ->
      exec2 testCmd, testCb if code is 0

    testCmd = "#{MOCHA} -R spec --colors #{jsFile}"
    testCb = (code, signal) ->
      if code is 0
        next()
      else
        log "ERROR: exit #{code}"

    exec2 cmplCmd, cmplCb

  mainTest testFiles.shift()

# functions ###################################################################
CoffeeScript = require 'coffee-script'
cp = require 'child_process'
util = require 'util'
fs = require 'fs'

log = () ->
  util.log.apply util, arguments

buffer = ""
execLog = (str) ->
  buffer += str
  arr = buffer.split(/\r?\n/)
  buffer = arr.pop()
  log line for line in arr

exec2 = (cmd, cb) ->
  log "$ #{cmd.replace(/\r?\n/, ' ')}"
  child = cp.exec cmd, () ->
  child.stdout.on 'data', execLog
  child.stderr.on 'data', execLog
  child.on 'exit', (code, signal) ->
    log '=> ' + if code is 0 then 'Success' else 'Fail'
    cb code, signal

listPathsByExt = (ext, p) ->
  return [] if p.match("/(?:node_modules|.git)$")

  list = []
  stats = fs.statSync p

  if stats.isFile()
    list.push p if p.match "\\.#{ext}$"

  else if stats.isDirectory()
    for child in fs.readdirSync p
      list = list.concat listPathsByExt ext, "#{p}/#{child}"

  list

mkdirUnlessExists = (dir)->
  if not fs.existsSync dir
    fs.mkdirSync dir
  else if (s = fs.statSync(dir)) && (not s.isDirectory())
    throw "cannot create #{build} directory. please remove or move #{buid} file."

getManifest = ()-> CoffeeScript.eval fs.readFileSync MANIFEST_COFFEE, 'utf8'

getManifestJsonPath = ()->
  if not MANIFEST_COFFEE.match /.coffee$/
    throw 'MANIFEST_COFFEE should have .coffee ext file name'
  return MANIFEST_COFFEE.replace /.coffee$/, '.json'

getBuildDirName = (manifest) -> manifest.name.replace /\s+/, '_'

readdirRecurceveSync = (file) ->
  if s = fs.statSync file
    if s.isDirectory()
      list = []
      for child in fs.readdirSync(file)
        list = list.concat readdirRecurceveSync "#{file}/#{child}"
      return list
    else
      return [file.toString()]
  else
    []

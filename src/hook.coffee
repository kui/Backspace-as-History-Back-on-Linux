# -*- coding:utf-8; mode:coffee; -*-

BACKSPACE_CODE = 8

hook = (event) ->
  return null if isIgnoreEvent event

isIgnoreEvent = (event) ->
  (event.which isnt BACKSPACE_CODE) or
    event.ctrlKey or
    event.altKey


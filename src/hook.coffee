# -*- coding:utf-8; mode:coffee; -*-

BACKSPACE_CODE = 8

hook = (event) ->
  return null if isIgnoreEvent event

isIgnoreEvent = (event) ->
  (event.which isnt BACKSPACE_CODE) and
    (not event.ctrlKey) and
    (not event.altKey)


# -*- coding:utf-8; mode:coffee; -*-

BACKSPACE_CODE = 8

ignoreConditions = []

hook = (event) ->
  return null if isIgnoreEvent event

  if event.shiftKey
    window.history.forward()
  else
    window.history.back()


isIgnoreEvent = (event) ->
  for cond in ignoreConditions
    return true if cond(event)
  false


# a condition with pressed keys
isIgnoreKeys = (event) ->
  (event.which isnt BACKSPACE_CODE) or
    event.ctrlKey or
    event.altKey

ignoreConditions.push isIgnoreKeys


# a condition with the forcused DOM element
isIgnoreElement = (event) ->
  !! isEditableElement event.target

isEditableElement = (ele) ->
  ele? and (ele.selectionStart? or ele.getAttribute('contenteditable')?)

ignoreConditions.push isIgnoreElement

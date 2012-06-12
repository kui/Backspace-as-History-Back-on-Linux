# -*- coding:utf-8; mode:coffee; -*-

BACKSPACE_CODE = 8

hook = (event) ->
  return null unless event.which is BACKSPACE_CODE


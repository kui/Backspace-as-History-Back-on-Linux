# -*- coding:utf-8; mode:coffee; -*-

assert = require 'assert'
sinon = require 'sinon'

window =
  history:
    back: () ->
    forward: () ->

describe 'In hook.coffee, ', ->

  event = null

  describe '#.isIgnoreKeys', ->

    describe 'with non backspace,', ->
      beforeEach ->
        event =
          which: BACKSPACE_CODE+1

      describe 'no alt key and no ctrl key', ->
        beforeEach ->
          event.altKey = false
          event.ctrlKey = false

        it 'should return true', ->
          r = isIgnoreKeys event
          assert.equal r, true

      describe 'pressed alt key and no ctrl key', ->
        before ->
          event.altKey = true
          event.ctrlKey = false

        it 'should return true', ->
          r = isIgnoreKeys event
          assert.equal r, true

    describe 'with backspace,', ->
      beforeEach ->
        event =
          which: BACKSPACE_CODE

      describe 'no alt key and no ctrl key', ->
        beforeEach ->
          event.altKey = false
          event.ctrlKey = false

        it 'should return false', ->
          r = isIgnoreKeys event
          assert.equal r, false

      describe 'pressed alt key and no ctrl key', ->
        beforeEach ->
          event.altKey = true
          event.ctrlKey = false

        it 'should return true', ->
          r = isIgnoreKeys event
          assert.equal r, true


      describe 'no alt key and pressed ctrl key', ->
        beforeEach ->
          event.altKey = false
          event.ctrlKey = true

        it 'should return true', ->
          r = isIgnoreKeys event
          assert.equal r, true

      describe 'pressed alt key and pressed ctrl key', ->
        beforeEach ->
          event.altKey = true
          event.ctrlKey = true

        it 'should return true', ->
          r = isIgnoreKeys event
          assert.equal r, true

  describe '#.isIgnoreElement', ->
    beforeEach ->
      event = target: null

    describe 'with no target', ->
      it 'should return false', ->
        r = isIgnoreElement event
        assert.equal r, false

    describe 'with a target which have the "contenteditable" attribute', ->
      beforeEach ->
        event.target =
          getAttribute: (name) ->
            if name is 'contenteditable' then true else undefined
          selectionStart: undefined

      it 'should return true', ->
        r = isIgnoreElement event
        assert.equal r, true

    describe 'with a target which have the "selectionStart" property', ->
      beforeEach ->
        event.target =
          getAttribute: (name) -> undefined
          selectionStart: 0

      it 'should return true', ->
        r = isIgnoreElement event
        assert.equal r, true

    describe 'with a target which isn\'t editable', ->
      beforeEach ->
        event.target =
          getAttribute: (name) -> undefined
          selectionStart: undefined

      it 'should return false', ->
        r = isIgnoreElement event
        assert.equal r, false

  describe '#.isIgnoreEvent', ->
    describe ', when a function in ignoreConditions return true,', ->
      beforeEach ->
        ignoreConditions = [
          () -> false
          () -> true
          () -> false
        ]

      it 'should return true', ->
        r = isIgnoreEvent event
        assert.equal r, true

    describe ', when all function in ignoreConditions return false,', ->
      beforeEach ->
        ignoreConditions = [
          () -> false
          () -> false
          () -> false
        ]

      it 'should return false', ->
        r = isIgnoreEvent event
        assert.equal r, false

  describe '#.hook', ->
    describe ', when isIgnoreEvent return true,', ->
      beforeEach ->
        isIgnoreEvent = () -> true

      it 'should do nothing', ->
        hook event

    describe ', when isIgnoreEvent return false', ->

      mock = null

      beforeEach ->
        isIgnoreEvent = () -> false
        event = {}
        mock = sinon.mock window.history

      describe 'and shift key is not pressed,', ->
        beforeEach ->
          event.shiftKey = false

        it 'should call window.histroy.back', ->
          mock.expects('back').once()
          hook event
          mock.verify()

      describe 'and shift key is pressed,', ->
        beforeEach ->
          event.shiftKey = true

        it 'should call window.histroy.forward', ->
          mock.expects('forward').once()
          hook event
          mock.verify();

# -*- coding:utf-8; mode:coffee; -*-

assert = require 'assert'

describe 'In hook.coffee, ', ->

  describe '#.isIgnoreEvent', ->

    event = null

    describe 'with non backspace,', ->
      beforeEach ->
        event =
          which: BACKSPACE_CODE+1

      describe 'no alt key and no ctrl key', ->
        beforeEach ->
          event.altKey = false
          event.ctrlKey = false

        it 'should return true', ->
          r = isIgnoreEvent event
          assert.equal r, true

      describe 'pressed alt key and no ctrl key', ->
        before ->
          event.altKey = true
          event.ctrlKey = false

        it 'should return true', ->
          r = isIgnoreEvent event
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
          r = isIgnoreEvent event
          assert.equal r, false

      describe 'pressed alt key and no ctrl key', ->
        beforeEach ->
          event.altKey = true
          event.ctrlKey = false

        it 'should return true', ->
          r = isIgnoreEvent event
          assert.equal r, true


      describe 'no alt key and pressed ctrl key', ->
        beforeEach ->
          event.altKey = false
          event.ctrlKey = true

        it 'should return true', ->
          r = isIgnoreEvent event
          assert.equal r, true

      describe 'pressed alt key and pressed ctrl key', ->
        beforeEach ->
          event.altKey = true
          event.ctrlKey = true

        it 'should return true', ->
          r = isIgnoreEvent event
          assert.equal r, true


openFixture  = require './test_helper'
RedSismica   = require '../index'
chai         = require 'chai'
sinon        = require 'sinon'
expect       = chai.expect

describe 'RedSismica', ->
  beforeEach (done) ->
    @redSismica = new RedSismica
    sinon.stub(@redSismica, 'callService', (data) =>
      openFixture 'index', @data
    )
    done()

  describe '#new', ->
    it 'contains baseUrl property', (done) ->
      expect(@redSismica).to.have.property('baseUrl')
      .to.eql 'http://redsismica.uprm.edu/English'
      done()

    it 'contains feltsUrl property', (done) ->
      expect(@redSismica).to.have.property('feltsUrl')
      .to.eql('http://redsismica.uprm.edu/English/php/CatalogS/Felts.php')
      done()

    it 'contains infoUrl property', (done) ->
      expect(@redSismica).to.have.property('infoUrl')
      .to.match(/myinfoGeneral.php\?id=(.*?)/)
      done()

    it 'contains techInfoUrl property', (done) ->
      expect(@redSismica).to.have.property('techInfoUrl')
      .to.match(/myinfoSolution.php\?id=(.*?)/)
      done()

  describe '#titlelize', ->
    it 'returns string with correct capitalization', (done) ->
      expect(@redSismica.titlelize).to.exist
      expect(@redSismica.titlelize('JONAH')).to.eql('Jonah')
      done()

  describe '#callService', ->
    it 'returns html response', (done) ->
      expect(@redSismica.callService).to.exist
      expect(@redSismica).to.be.an.instanceOf RedSismica
      done()

  describe '#fetchTitles', ->
    it 'returns list of titles', (done) ->
      expect(@redSismica.fetchTitles).to.exist
      done()

  describe '#prepareData', ->
    it 'returns parsed response after processing', (done) ->
      expect(@redSismica.prepareData).to.exist
      done()

  describe '#prepareBulletin', ->
    it 'returns parsed response after processing', (done) ->
      expect(@redSismica.prepareBulletin).to.exist
      done()

  describe '#fetchEvents', ->
    it 'returns events html response', (done) ->
      expect(@redSismica.fetchEvents).to.exist
      expect(@redSismica.fetchEvents).to.be.a 'function'
      done()

  describe '#fetchBulletins', ->
    it 'returns bulletin html response', (done) ->
      expect(@redSismica.fetchBulletins).to.exist
      expect(@redSismica.fetchBulletins).to.be.a 'function'
      done()

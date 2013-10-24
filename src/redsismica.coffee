###
 redsismica - A node scraper module for researching Seismic data from Puerto Rico Seismic Network (University of Puerto Rico
 https://www.github.com/jonahoffline/node-redsismica
 Copyright (c) 2013 Jonah Ruiz
 MIT Licence
###

fs      = require 'fs'
request = require 'request'
cheerio = require 'cheerio'

class RedSismica
  constructor: ->
    @ids          = []
    @baseUrl      = 'http://redsismica.uprm.edu/English'
    @feltsUrl     = "#{@baseUrl}/php/CatalogS/Felts.php"
    @infoUrl      = "#{@baseUrl}/Informe_Sismo/myinfoGeneral.php?id="
    @techInfoUrl  = "#{@baseUrl}/Informe_Sismo/myinfoSolution.php?id="
    @bulletinUrl  = "#{@baseUrl}/Informe_Sismo/myinfoMemo.php?id="

  titlelize: (string) ->
    fix = string.toLowerCase().split(' ').map (word) ->
      word.charAt(0).toUpperCase().concat(word.slice(1))
    fix.join(' ')

  callService: (resource, callback) ->
    resource ?= @feltsUrl
    request.get resource, (err, res, body) ->
      return callback(body) unless err
      err

  fetchTitles: (cb) ->
    @callService @feltsUrl, (res) ->
      $ = cheerio.load(res)
      cb? $('th').map -> $(@).text()


  prepareData: (eventsData, callback) ->
    data = []
    for obj, i in eventsData[0...eventsData.length] by 9
      @ids.push eventsData[i + 8]
      data.push
        seismic_id:  parseInt(eventsData[i + 8])
        magnitude: parseFloat(eventsData[i + 0].replace /\s?Md/, '')
        agency: eventsData[i + 1]
        local_time: eventsData[i + 2]
        loc:
          longitude: parseFloat(eventsData[i + 4])
          latitude: parseFloat(eventsData[i + 3])
        depth: parseInt(eventsData[i + 5])
        mm: eventsData[i + 6]
        region: eventsData[i + 7]
        links:
          general: @infoUrl.concat eventsData[i + 8]
          technical: @techInfoUrl.concat eventsData[i + 8]
    callback data

  prepareBulletin: (eventsData, callback) ->
    regexPattern = /\r+|\n+|\t+\s+/g
    data =
      event_id: eventsData[36]
      event_type: @titlelize(eventsData[15])
      local_date: eventsData[0].replace regexPattern, ''
      local_time: eventsData[1]
      coordinates:
        latitude: eventsData[2]
        longitude: eventsData[3]
      location: eventsData[4].replace /\n|\s+$/g, ''
      estimated_max_intensity: eventsData[7].replace regexPattern, ''
      tsunami_warning_level: eventsData[8].replace regexPattern, ''
      issued_datetime: eventsData[9].replace regexPattern, ''
      bulletin_body: eventsData[30].replace /^\s+|\r+|\t+|\n|\s+$/g, ''
      epicentral_map_image: eventsData[35]
    callback data

  fetchBulletins: (cb) ->
    @ids.map (eventId) =>
      @callService "#{@bulletinUrl}#{eventId}", (res) =>
        recentData = []
        $ = cheerio.load(res)
        $('table:last-child tr td:nth-child(even)').each (index, item) ->
          recentData.push $(@).text()
        $('table:last-child tr td:nth-child(odd)').each (index, item) ->
          recentData.push $(@).text()
        $('table:last-child tr img').each (index, item) ->
          recentData.push $(@).attr('src')
          recentData.push eventId

        @prepareBulletin recentData, (callback) ->
          cb callback

  fetchEvents: (cb) ->
    @callService @feltsUrl, (res) =>
      recentData = []
      $ = cheerio.load(res)
      $('table tbody td').each (index, item) ->
        recentData.push $(@).text()
        link = $(@).find('a')
        if (link.attr('href')?) && not(link.text().match(/^\d{4,}/)?)
          recentData.push link.attr('href')[-14..-1]

      @prepareData recentData, (callback) ->
        cb callback

module.exports = RedSismica

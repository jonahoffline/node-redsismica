/*
 RedSismica - Research Seismic data from Puerto Rico Seismic Network (UPR)
 https://www.github.com/jonahoffline/node-redsismica
 Copyright (c) 2013-2014 Jonah Ruiz
 MIT Licence
*/


(function() {
  var RedSismica, cheerio, fs, request;

  fs = require('fs');

  request = require('request');

  cheerio = require('cheerio');

  RedSismica = (function() {
    function RedSismica() {
      this.ids = [];
      this.baseUrl = 'http://redsismica.uprm.edu/English';
      this.feltsUrl = "" + this.baseUrl + "/php/CatalogS/Felts.php";
      this.infoUrl = "" + this.baseUrl + "/Informe_Sismo/myinfoGeneral.php?id=";
      this.techInfoUrl = "" + this.baseUrl + "/Informe_Sismo/myinfoSolution.php?id=";
      this.bulletinUrl = "" + this.baseUrl + "/Informe_Sismo/myinfoMemo.php?id=";
    }

    RedSismica.prototype.titlelize = function(string) {
      var fix;
      fix = string.toLowerCase().split(' ').map(function(word) {
        return word.charAt(0).toUpperCase().concat(word.slice(1));
      });
      return fix.join(' ');
    };

    RedSismica.prototype.callService = function(resource, callback) {
      if (resource == null) {
        resource = this.feltsUrl;
      }
      return request.get(resource, function(err, res, body) {
        if (!err) {
          return callback(body);
        }
        return err;
      });
    };

    RedSismica.prototype.fetchTitles = function(cb) {
      return this.callService(this.feltsUrl, function(res) {
        var $;
        $ = cheerio.load(res);
        return typeof cb === "function" ? cb($('th').map(function() {
          return $(this).text();
        })) : void 0;
      });
    };

    RedSismica.prototype.prepareData = function(eventsData, callback) {
      var data, i, obj, _i, _len, _ref;
      data = [];
      _ref = eventsData.slice(0, eventsData.length);
      for (i = _i = 0, _len = _ref.length; _i < _len; i = _i += 9) {
        obj = _ref[i];
        this.ids.push(eventsData[i + 8]);
        data.push({
          seismic_id: parseInt(eventsData[i + 8]),
          magnitude: parseFloat(eventsData[i + 0].replace(/\s?Md/, '')),
          agency: eventsData[i + 1],
          local_time: eventsData[i + 2],
          loc: {
            longitude: parseFloat(eventsData[i + 4]),
            latitude: parseFloat(eventsData[i + 3])
          },
          depth: parseInt(eventsData[i + 5]),
          mm: eventsData[i + 6],
          region: eventsData[i + 7],
          links: {
            general: this.infoUrl.concat(eventsData[i + 8]),
            technical: this.techInfoUrl.concat(eventsData[i + 8])
          }
        });
      }
      return callback(data);
    };

    RedSismica.prototype.prepareBulletin = function(eventsData, callback) {
      var data, regexPattern;
      regexPattern = /\r+|\n+|\t+\s+/g;
      data = {
        event_id: eventsData[36],
        event_type: this.titlelize(eventsData[15]),
        local_date: eventsData[0].replace(regexPattern, ''),
        local_time: eventsData[1],
        coordinates: {
          latitude: eventsData[2],
          longitude: eventsData[3]
        },
        location: eventsData[4].replace(/\n|\s+$/g, ''),
        estimated_max_intensity: eventsData[7].replace(regexPattern, ''),
        tsunami_warning_level: eventsData[8].replace(regexPattern, ''),
        issued_datetime: eventsData[9].replace(regexPattern, ''),
        bulletin_body: eventsData[30].replace(/^\s+|\r+|\t+|\n|\s+$/g, ''),
        epicentral_map_image: eventsData[35]
      };
      return callback(data);
    };

    RedSismica.prototype.fetchBulletins = function(cb) {
      var _this = this;
      return this.ids.map(function(eventId) {
        return _this.callService("" + _this.bulletinUrl + eventId, function(res) {
          var $, recentData;
          recentData = [];
          $ = cheerio.load(res);
          $('table:last-child tr td:nth-child(even)').each(function(index, item) {
            return recentData.push($(this).text());
          });
          $('table:last-child tr td:nth-child(odd)').each(function(index, item) {
            return recentData.push($(this).text());
          });
          $('table:last-child tr img').each(function(index, item) {
            recentData.push($(this).attr('src'));
            return recentData.push(eventId);
          });
          return _this.prepareBulletin(recentData, function(callback) {
            return cb(callback);
          });
        });
      });
    };

    RedSismica.prototype.fetchEvents = function(cb) {
      var _this = this;
      return this.callService(this.feltsUrl, function(res) {
        var $, recentData;
        recentData = [];
        $ = cheerio.load(res);
        $('table tbody td').each(function(index, item) {
          var link;
          recentData.push($(this).text());
          link = $(this).find('a');
          if ((link.attr('href') != null) && !(link.text().match(/^\d{4,}/) != null)) {
            return recentData.push(link.attr('href').slice(-14));
          }
        });
        return _this.prepareData(recentData, function(callback) {
          return cb(callback);
        });
      });
    };

    return RedSismica;

  })();

  module.exports = RedSismica;

}).call(this);

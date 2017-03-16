fs = require('fs')
osLocale = require('os-locale')
airport = require('node-wifiscanner2/lib/airport')
iwlist = require('node-wifiscanner2/lib/iwlist')
nmcli = require('node-wifiscanner2/lib/nmcli')
netsh = require('node-wifiscanner2/lib/netsh')
enLocale = require('node-wifiscanner2/locales/en.json')
deLocale = require('node-wifiscanner2/locales/de.json')
terms = undefined
fullLocale = osLocale.sync(spawn: true) or 'en_US'

###* quick-fix:start *###

setLocale = (locale) ->
  shortLocale = locale.split('_')[0]
  if shortLocale.indexOf('de') >= 0
    terms = deLocale
  else
    terms = enLocale
  return

###* quick-fix:end *###

scan = (callback) ->
  fs.exists airport.utility, (exists) ->
    if exists
      airport.scan terms.airport, callback
      return
    fs.exists nmcli.utility, (exists) ->
      if exists
        nmcli.scan terms.nmcli, callback
        return
      fs.exists iwlist.utility, (exists) ->
        if exists
          iwlist.scan terms.iwlist, callback
          return
        fs.exists netsh.utility, (exists) ->
          if exists
            netsh.scan terms.netsh, callback
            return
          callback 'No scanning utility found', null
          return
        return
      return
    return
  return

setLocale fullLocale
exports.scan = scan
exports.setLocale = setLocale

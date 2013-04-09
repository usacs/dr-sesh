# Description:
#   Track where people are working
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot i work at <company> - set the user's company
#   hubot i work at <company> in <location> - set the user's job and company
#   hubot i work in <location> - set the user's job location
#   hubot <user> job - show a user's company and/or job location
#
# Author:
#   GRardB

class JobMap
  constructor: (@robot)->
    @cache = {}

  createUserIfNew:(user)->
    if not cache.hasOwnProperty(user)
      @cache[user] = {
        company: ''
        location: ''
      }

  setLocation: (user, location)->
    @createUserIfNew(user)
    @cache[user]['location'] = location

  setCompany: (user, company)->
    @createUserIfNew(user)
    @cache[user]['company'] = company

module.exports = (robot)->
  job_map = new JobMap(robot)
  robot.respond /i work at (.+) in (.+)/, (msg)->
    company  = msg.match[1].trim()
    location = msg.match[2].trim()
    user     = msg.message.user.name.toLowerCase()

    job_map.setCompany(company)
    job_map.setLocation(location)
    
    msg.send("Okay, #{user} works at #{company} in #{location}")

  robot.respond /i work at (.+)/, (msg)->
    company  = msg.match[1].trim()
    user     = msg.message.user.name.toLowerCase()

    job_map.setCompany(company)
    msg.send("Okay, #{user} works at #{company}")

  robot.respond /i work in (.+)/, (msg)->
    location = msg.match[2].trim()
    user     = msg.message.user.name.toLowerCase()

    job_map.setLocation(location)
    msg.send("Okay, #{user} works in #{location}")

  robot.respond /(.+) job/, (msg)->
    user = msg.match[1].trim()
    cache = job_map.cache

    if not cache.hasOwnProperty(user)
      msg.send("I don't know where #{user} works")
    else
      location_known = cache[user].hasOwnProperty('location')
      company_known  = cache[user].hasOwnProperty('company')

      if location_known and company_known
        msg.send("#{user} works at #{company} in #{location}")
      else if location_known
        msg.send("#{user} works in #{location}")
      else if company_known
        msg.send("#{user} works at #{company}")
      else
        msg.send("I don't know where #{user} works")

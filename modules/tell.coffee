directed_message = require "#{__dirname}/base/directed_message"
_ = require('../utils')

class Tell
  constructor: (@users, settings, @emittor) ->
    @commands = {tell: @command}
    @listeners = [@listener]
    @command._help = "publically passes a message to a user whenever he/she next speaks. usage: !tell <user> <message>"

  command: (from, tokens, cb) =>
    directed_message from, tokens, cb, @users, (nick, data) =>
      @users.addTell nick, data

  listener: (from, message) =>
    rec = @users.get(from)
    return if _(message).automated() || !rec
    tells = @users.getTells(from)
    return if _(tells).isEmpty()
    _(tells).each (item) =>
      @emittor "#{from}:#{item.from} said '#{item.msg}' #{_.date(item.time).fromNow()}"
    @users.clearTells from

module.exports = Tell
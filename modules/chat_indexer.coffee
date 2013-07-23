net = require('net')

class ChatIndexer
	constructor: ({@settings}) ->
		search_settings = @settings['modules']['irc_search']

		@message_listeners = [@message_listener]

		@search_client = new net.Socket
		@search_client.setNoDelay
		@search_client.setKeepAlive
		@search_client.connect search_settings['port'], search_settings['host'], () =>
			console.log "Connected to search server"
			@search_client.write "#{@settings['server']},#{@settings['channel']},#{@settings['nick']}\n"

	message_listener: (from, msg) =>
		console.log (from + ": " + msg)
		line = JSON.stringify [from, new Date().getTime(), msg]
		line = line.substr(1, line.length - 2)
		@search_client.write "#{line}\n"

module.exports = ChatIndexer
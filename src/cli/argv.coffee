parser = require 'nomnom'

judge = require '../judge'

module.exports = (argv) ->
	parser.command 'install'
	.callback (opts) ->
		judge.install process.cwd(), (err) ->
			throw err if err

	parser.parse()

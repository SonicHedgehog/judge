parser = require 'nomnom'

judge = require '../judge'

module.exports = (argv) ->
	parser.command 'install'
	.callback (opts) ->
		judge.install process.cwd(), opts[1], (err) ->
			throw err if err

	parser.command 'run'
	.callback (opts) ->
		judge.run opts[1], process.cwd(), opts[2], opts._[3..], (err) ->
			throw err if err

	parser.parse()

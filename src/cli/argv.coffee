parser = require 'nomnom'

judge = require '../judge'

module.exports = (argv) ->
	parser.command 'install'
	.option 'overwrite',
		flag: true
	.callback (opts) ->
		judge.install process.cwd(), opts[1], opts.overwrite, (err) ->
			throw err if err

	parser.command 'run'
	.callback (opts) ->
		judge.run opts[1], process.cwd(), opts[2], opts._[3..], (err) ->
			throw err if err

	parser.parse()

fs = require 'fs'
path = require 'path'

mkdirp = require 'mkdirp'

module.exports = (judgeCase, packagePath, callback) ->
	fs.exists packagePath, (exists) ->
		callback new Error "#{packagePath} does not exist." unless exists

		pathToMake = path.join packagePath, 'node_modules', '.judge', judgeCase, 'node_modules'

		mkdirp pathToMake, (err) ->
			callback err if err

			callback null

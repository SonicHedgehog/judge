fs = require 'fs'
path = require 'path'

mkdirp = require 'mkdirp'

module.exports = (judgeCase, packagePath, callback) ->
	fs.exists packagePath, (exists) ->
		return callback new Error "#{packagePath} does not exist." unless exists

		pathToMake = path.join packagePath, 'node_modules', '.judge', judgeCase, 'node_modules'

		mkdirp pathToMake, (err) ->
			return callback err if err

			callback null

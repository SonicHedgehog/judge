fs = require 'fs'
path = require 'path'

module.exports = (packagePath, callback) ->
	packageJsonPath = path.join packagePath, 'package.json'

	fs.readFile packageJsonPath, 'utf8', (err, data) ->
		return callback err if err

		try
			data = JSON.parse data
		catch err
			return callback err if err

		callback null, data.judge

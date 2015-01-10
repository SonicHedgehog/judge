npmi = require 'npmi'

module.exports = (packagePath, callback) ->
	npmi path: packagePath, (err, result) ->
		callback err if err

		callback null, result

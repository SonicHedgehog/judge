npmi = require 'npmi'

module.exports = (packageName, packageVersion, targetPath, callback) ->
	# (packagePath, callback) → `npm install` in targetPath
	if arguments.length is 2
		targetPath = packageName
		callback = packageVersion

		npmiOptions = path: targetPath
	else
		npmiOptions =
			name: packageName
			version: packageVersion
			path: targetPath

	npmi npmiOptions, (err, result) ->
		callback err if err

		callback null, result

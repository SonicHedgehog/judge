fs = require 'fs'
path = require 'path'

async = require 'async'
which = require 'which'

originalExtensions = {}

module.exports = (judgeCase, packagePath, command, args = [], callback) ->
	which command, (err, commandPath) ->
		callback err if err

		getModulesInCase judgeCase, packagePath, (err, modules) ->
			callback err if err

			overrideExtensionHandlers()
			clearModuleCache()

			process.argv = ['node', commandPath].concat args

			require commandPath

getModulesInCase = (judgeCase, packagePath, callback) ->
	judgeCasePath = path.join packagePath, 'node_modules', '.judge', judgeCase
	modules = []

	fs.readdir path.join(judgeCasePath, 'node_modules'), (err, files) ->
		callback err if err

		async.each files, (file, callback) ->
			# Skip hidden directories.
			return callback() if file.indexOf('.') is 0

			fs.stat path.join(judgeCasePath, 'node_modules', file), (err, stats) ->
				callback err if err

				modules.push file if stats.isDirectory()
				callback()
		, (err) ->
			callback err if err

			callback null, modules

overrideExtensionHandlers = ->
	for extension of require.extensions
		do (extension) ->
			# Delete any non-default extensions such as .coffee.
			if ['.js', '.json', '.node'].indexOf(extension) is -1
				delete require.extensions[extension]
				return

			unless originalExtensions[extension]
				originalExtensions[extension] = require.extensions[extension]

			if require.extensions[extension].length is 2
				require.extensions[extension] = (module, filename) ->
					originalExtensions[extension](module, filename)

clearModuleCache = ->
	for module of require.cache
		delete require.cache[module]

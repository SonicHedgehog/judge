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

			overrideExtensionHandlers judgeCase, modules, packagePath
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

overrideExtensionHandlers = (judgeCase, modulesToOverride, packagePath) ->
	for extension of require.extensions
		do (extension) ->
			# Delete any non-default extensions such as .coffee.
			if ['.js', '.json', '.node'].indexOf(extension) is -1
				delete require.extensions[extension]
				return

			unless originalExtensions[extension]
				originalExtensions[extension] = require.extensions[extension]

			standardModulePaths = []

			for moduleToOverride in modulesToOverride
				standardModulePaths.push path.resolve packagePath, 'node_modules', moduleToOverride

			if require.extensions[extension].length is 2
				require.extensions[extension] = (module, filename) ->
					for standardModulePath in standardModulePaths
						if filename.indexOf(standardModulePath) is 0
							moduleSubPath = filename.substr standardModulePath.length
							judgeCaseModulePath = path.join standardModulePath, '..', '.judge',
								judgeCase, 'node_modules', moduleToOverride, moduleSubPath

							# Replace module path.
							module.id = module.filename = filename = judgeCaseModulePath

					originalExtensions[extension](module, filename)

clearModuleCache = ->
	for module of require.cache
		delete require.cache[module]

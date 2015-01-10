which = require 'which'

originalExtensions = {}

module.exports = (judgeCase, packagePath, command, args = [], callback) ->
	which command, (err, commandPath) ->
		callback err if err

		overrideExtensionHandlers()
		clearModuleCache()

		process.argv = ['node', commandPath].concat args

		require commandPath

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

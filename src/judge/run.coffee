which = require 'which'

module.exports = (judgeCase, packagePath, command, args = [], callback) ->
	which command, (err, commandPath) ->
		callback err if err

		originalExtensions = {}

		# Override extension handlers.
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

		# Clear module cache.
		for module of require.cache
			delete require.cache[module]

		process.argv = ['node', commandPath].concat args

		require commandPath

path = require 'path'

async = require 'async'

judge = require './index'

module.exports = (packagePath, judgeCase, overwrite, callback) ->
	# (packagePath, callback) → defaults to all Judge cases
	if arguments.length is 2
		callback = judgeCase
		judgeCase = null
	# (packagePath, judgeCase, callback) → overwrite defaults to false
	else if arguments.length is 3
		calback = overwrite
		overwrite = false

	judge.installPackage packagePath, (err, result) ->
		callback err if err

		judge.getCases packagePath, (err, cases) ->
			callback err if err

			if judgeCase
				newCases = {}
				newCases[judgeCase] = cases[judgeCase]
				cases = newCases
			
			async.each Object.keys(cases), (judgeCase, callback) ->
				caseDependencies = cases[judgeCase]

				judge.prepareCase judgeCase, packagePath, (err) ->
					callback err if err

					async.each Object.keys(caseDependencies), (packageName, callback) ->
						packageVersion = caseDependencies[packageName]
						targetPath = if overwrite then packagePath else
							path.join packagePath, 'node_modules', '.judge', judgeCase

						judge.installPackage packageName, packageVersion, targetPath, (err, result) ->
								callback err if err

								callback null
					, (err) ->
						callback err if err
			, (err) ->
				callback err if err

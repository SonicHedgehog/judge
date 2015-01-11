path = require 'path'

async = require 'async'

judge = require './index'

module.exports = (packagePath, callback) ->
	judge.installPackage packagePath, (err, result) ->
		callback err if err

		judge.getCases packagePath, (err, cases) ->
			callback err if err

			async.each Object.keys(cases), (judgeCase, callback) ->
				caseDependencies = cases[judgeCase]

				judge.prepareCase judgeCase, packagePath, (err) ->
					callback err if err

					async.each Object.keys(caseDependencies), (packageName, callback) ->
						packageVersion = caseDependencies[packageName]

						judge.installPackage packageName, packageVersion,
							path.join(packagePath, 'node_modules', '.judge', judgeCase), (err, result) ->
								callback err if err

								callback null
					, (err) ->
						callback err if err
			, (err) ->
				callback err if err

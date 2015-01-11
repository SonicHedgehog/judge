judge = module.exports = {}

judge.installPackage = require './install-package'
judge.getCases = require './get-cases'
judge.prepareCase = require './prepare-case'

judge.install = require './install'
judge.run = require './run'

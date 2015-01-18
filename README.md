# Judge

Test your Node.js package against different versions of dependencies.

*Note:* Judge is a work in progress and may not work very well, yet. See [Stability and limitations](#stability-and-limitations).

## What is this good for?

Let’s say you wrote a middleware for [Express](http://expressjs.com) which is compatible with both Express 3 and Express 4. You use [Travis CI](https://travis-ci.org) to ensure that your tests pass, even against multiple versions of Node.js. However, your tests won’t run against Express 3.

Using Judge, you can specify multiple “Judge cases” (a set of dependencies) to test your package against, so you can be sure that your Express middleware works with both Express 3 and Express 4.

Judge was heavily inspired by [Appraisal](https://github.com/thoughtbot/appraisal) which offers a similar solution for Ruby gems.

## Getting started

Install Judge using:

```shell
$ npm install judge --save-dev
```

Declare Judge cases in your `package.json`:

```json
{
  "name": "your-package",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.10.6 || ^3.18.6"
  },
  "judge": {
    "express-4": {
      "express": "^4.10.6"
    },
    "express-3": {
      "express": "^3.18.6"
    }
  }
}
```

Install all necessary dependencies using:

```shell
$ ./node_modules/.bin/judge install
```

You can now run any Node.js application against a specific Judge case:

```shell
$ ./node_modules/.bin/judge run express-3 grunt test
$ ./node_modules/.bin/judge run express-4 node test.js
```

## Integration with Travis CI

You can configure Travis CI to use Judge when running your tests. Simply add `judge install $JUDGE_CASE --overwrite` to your install process. Then specify every Judge case you want to test against as an environment variable.

```yaml
language: node_js
node_js:
  - "0.10"
  - "0.8"
install:
  - "npm install"
  - "./node_modules/.bin/judge install $JUDGE_CASE --overwrite"
env:
  - "JUDGE_CASE=express-3"
  - "JUDGE_CASE=express-4"
```

## Stability and limitations

Judge is currently a work in progress. For example, you may encounter the following issues and annoyances:

- No built-in help command
- Undefined behavior when passing invalid or unexpected parameters
- May not work well with Node addons
- Does not work with non-Node.js commands
- Judge has no test suite, yet

In general, the environment provided by `judge run` may not be exactly the same as if you start the program using `node` itself.

That said, using the `--overwrite` option, for example to improve your CI tests, should be unproblematic.

## Release History

See [CHANGELOG.md](./CHANGELOG.md).

## License

Judge is licensed under the BSD 2-clause license. See [LICENSE](./LICENSE) for the full license text.

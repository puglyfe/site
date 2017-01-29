browserify = require 'roots-browserify'
css_pipeline = require 'css-pipeline'

module.exports =
  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf', '.sass-lint.yml']

  extensions: [
    browserify(files: 'assets/js/main.coffee', out: 'js/build.js'),
    css_pipeline(files: 'assets/css/*.scss', out: 'css/main.css')
  ]

  'coffee-script':
    sourcemap: true

  jade:
    basedir: 'public'
    pretty: true

  scss:
    includePaths: [
      'node_modules/normalize-scss/sass/'
      'node_modules/include-media/dist/'
    ]
    outputStyle: 'compressed'

  locals:
    data: require './data/data.json'

js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'

module.exports =
  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf', '.sass-lint.yml']

  extensions: [
    js_pipeline(files: ['assets/js/*.js', 'assets/js/*.coffee'], out: 'js/main.js'),
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

autoprefixer = require 'autoprefixer'
browserify = require 'roots-browserify'
css_pipeline = require 'css-pipeline'

module.exports =
  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf', '.*']

  extensions: [
    browserify(files: 'assets/js/main.coffee', out: 'js/build.js')
    css_pipeline(files: 'assets/css/*.scss', out: 'css/main.css')
  ]

  'coffee-script':
    sourcemap: true

  jade:
    basedir: 'public'
    pretty: true

  postcss:
    use: [
      autoprefixer
    ]

  scss:
    includePaths: [
      'node_modules/normalize-scss/sass/'
      'node_modules/include-media/dist/'
    ]
    outputStyle: 'compressed'
    sourceComments: true
    sourceMapEmbed: true

  locals:
    data: require './data/data.json'

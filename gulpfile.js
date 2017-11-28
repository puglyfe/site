'use strict';

/**
  * TODO: clean this up. consolidate config. fix image watch task.
  */

// Gulp Modules
var gulp = require('gulp');
var $ = require('gulp-load-plugins')({ lazy: true });
var del = require('del');
var runSequence = require('run-sequence');
var args = require('yargs').argv;
var browserSync = require('browser-sync').create();

var env = args.env || 'development';

// Other vars
var isProduction = (env === 'production');

var assetsDir = './assets';
var buildDir = './public';
var config = {
  browserSync: {
    server: {
      baseDir: './public'
    },
    logConnections: true,
    open: 'external'
  },
};

//
// BrowserSync Tasks
// -----------------------------------------------------------------------------

gulp.task('browser-sync', function () {
  browserSync.init(config.browserSync);
});

gulp.task('browser-sync:reload', function () {
  if (browserSync.active) {
    browserSync.reload();
  }
});

//
// Clean
// -----------------------------------------------------------------------------

gulp.task('clean', function() {
  return del(buildDir + '/**');
});

//
// Copy
// -----------------------------------------------------------------------------

gulp.task('copy', function () {
  return gulp.src(['./data', './favicon.ico'])
    .pipe(gulp.dest(buildDir));
});

// -
// Build Tasks
// -----------------------------------------------------------------------------

gulp.task('build', function () {
  runSequence(
    'clean',
    'copy',
    'build:js',
    'build:scss',
    'build:images',
    'build:templates'
  );
});

gulp.task('build:js', function() {
  return gulp.src(assetsDir + '/js/main.coffee', { read: false })
    .pipe($.browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe($.if(isProduction, $.uglify({
      mangle: true,
      compress: {
        sequences: true,
        dead_code: true,
        comparisons: true,
        conditionals: true,
        booleans: true,
        negate_iife: true,
        unused: true,
        if_return: true,
        join_vars: true,
        drop_console: false
      }
    })))
    .pipe($.rename('build.js'))
    .pipe(gulp.dest(buildDir + '/js'))
});

gulp.task('build:scss', function () {
  return gulp.src(assetsDir + '/css/main.scss')
    .pipe($.if(!isProduction, $.sourcemaps.init({ loadMaps: true })))
    .pipe($.sass({
      includePaths: [
        './node_modules/normalize-scss/sass',
        './node_modules/include-media/dist'
      ],
      outputStyle: isProduction ? 'compressed' : 'nested',
      sourceComments: isProduction ? false : 'map'
    })
      .on('error', $.sass.logError)
    )
    .pipe($.autoprefixer())
    .pipe(
      $.if(isProduction,$.cssnano({
        autoprefixer: false,
        discardComments: { removeAll: true }
      }))
    )
    .pipe($.if(!isProduction, $.sourcemaps.write()))
    .pipe(gulp.dest(buildDir + '/css'));
});

gulp.task('build:images', function () {
  return gulp.src(assetsDir + '/img/**/*')
    .pipe(gulp.dest(buildDir + '/img'));
});

gulp.task('build:templates', function () {
  return gulp.src('./views/index.pug')
    .pipe($.pug({
      basedir: 'public',
      locals: {
        data: require('./data/data.json'),
        social: require('./data/social.json')
      },
      pretty: isProduction ? false : true
    }))
    .pipe(gulp.dest(buildDir));
});

//
// Watch
// -----------------------------------------------------------------------------

gulp.task('watch', function () {
  runSequence(
    'watch:js',
    'watch:scss',
    'watch:templates'
    // 'watch:images'
  );
});

gulp.task('watch:js', function () {
  gulp.watch(assetsDir + '/js/**/*.coffee', ['build:js']);
  gulp.watch(buildDir + '/js/**/*.js', ['browser-sync:reload']);
});

gulp.task('watch:scss', function () {
  gulp.watch(assetsDir + '/css/**/*.scss', ['build:scss']);
  gulp.watch(buildDir + '/css/**/*.css', ['browser-sync:reload']);
});

gulp.task('watch:templates', function () {
  gulp.watch('./views/**/*.pug', ['build:templates'])
  gulp.watch(buildDir + '/**/*.html', ['browser-sync:reload']);
});

gulp.task('watch:images', function () {
  gulp.watch(assetsDir + './img', ['build:images'])
  gulp.watch(buildDir + '/img/**/*.{jpg,png,svg}', ['browser-sync:reload']);
});

//
// Default Tasks
// --------------------------------------------------

gulp.task('help', $.taskListing);
gulp.task('default', ['help']);
gulp.task('serve', ['build', 'browser-sync', 'watch']);

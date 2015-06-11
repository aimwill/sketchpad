gulp = require 'gulp'
changed = require 'gulp-changed'
cached = require 'gulp-cached'
inheritance = require 'gulp-jade-inheritance'
debug = require 'gulp-debug'
gulpif = require 'gulp-if'
jade = require 'gulp-jade'
chmod = require 'gulp-chmod'
filter = require 'gulp-filter'
rename = require 'gulp-rename'
config = require './config.coffee'
argv = require('yargs').argv
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'

errorAlert = (error) ->
  notify.onError(
    title: 'Jade Error'
    message: 'Check your terminal!'
  )(error)
  console.log error.toString()
  this.emit 'end'

gulp.task 'jade', ->
  gulp.src 'src/**/*.jade'
    .pipe plumber errorHandler: errorAlert
    .pipe changed(config.path, extension: '.html')

    .pipe cached('jade')
    .pipe inheritance(basedir: 'src')
    .pipe debug(title: 'changed')
    .pipe filter (file) ->
      /canvas\//.test file.path

    .pipe gulpif(
      argv.sandbox,
      jade(pretty: true, locals: {sandbox: true}),
      jade(pretty: true)
    )
    .pipe chmod(755)

    .pipe rename (file) ->
      file.dirname = file.dirname.replace('canvas', '')
    .pipe gulp.dest(config.path)

gulp.task 'jadeProduction', ->
  gulp.src 'src/components/**/*.jade'
    .pipe plumber errorHandler: errorAlert
    .pipe changed("#{config.path}/partials", extension: '.html')

    .pipe gulpif(
      argv.sandbox,
      jade(pretty: true, locals: {sandbox: true}),
      jade(pretty: true)
    )
    .pipe chmod(755)

    .pipe gulp.dest("#{config.path}/partials/")

module.exports = gulp
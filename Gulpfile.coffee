gulp = require 'gulp'
browserSync = require('browser-sync').create()
reload = browserSync.reload

gulpDeps = ['watch', 'coffee', 'jade', 'stylus', 'sourcemaps', 'clean', 'debug', 'util']

gulpDeps.forEach (dep) -> eval "#{dep} = require('gulp-#{dep}')" # require each dep



gulp.task 'default', ['watch', 'copy-all', 'browser-sync']

gulp.task 'watch', ['watch-coffee', 'watch-jade', 'watch-stylus']

gulp.task 'watch-coffee', ->
    gulp.src 'src/**/*.coffee'
        .pipe watch 'src/**/*.coffee', verbose: true, name: 'Coffee'
        .pipe sourcemaps.init()
        .pipe coffee bare: true
            .on 'error', util.log
        .pipe sourcemaps.write()
        .pipe gulp.dest 'build'
        .pipe reload stream: true

gulp.task 'watch-jade', ->
    gulp.src 'src/**/*.jade'
        .pipe watch 'src/**/*.jade', verbose: true, name: 'Jade'
        .pipe jade(pretty: true)
        .pipe gulp.dest 'build'
        .pipe reload stream: true

gulp.task 'watch-stylus', ->
    gulp.src 'src/**/*.styl'
        .pipe watch 'src/**/*.styl', verbose: true, name: 'Stylus'
        .pipe sourcemaps.init()
        .pipe stylus()
        .pipe sourcemaps.write()
        .pipe gulp.dest 'build'
        .pipe reload stream: true

gulp.task 'copy-all', ->
  gulp.src 'src/**'
    .pipe gulp.dest 'build'

gulp.task 'browser-sync', ->
    browserSync.init
        server:
            baseDir: 'build'

gulp.task 'clean', ->
    gulp.src 'build', read: false
        .pipe clean()

"use strict"

const gulp = require('gulp');
const runSequence = require('run-sequence');
const sass = require('gulp-sass');
const sourcemaps = require('gulp-sourcemaps');
const image = require('gulp-image');
const rename = require("gulp-rename");
const gulpCopy = require('gulp-copy');
const concat = require('gulp-concat-util');
const minify = require('gulp-minify-css');
const gutil = require('gulp-util');
const critical = require('critical').stream;
const autoprefixer = require('gulp-autoprefixer');
const cachebust = require('gulp-cache-bust');
const clean = require('gulp-clean');
const template = require('gulp-md-template');
const handlebars = require('gulp-compile-handlebars');
const replace = require('gulp-replace');

// Clean out the dist folder
gulp.task('clean_without_images', () => {
  return gulp.src(['./dist/assets/css', './dist/*.*', './dist/CNAME'], {
    read: false,
    force: true
  })
  .pipe(clean());
});

// Clean out the dist folder
gulp.task('clean', () => {
  return gulp.src('./dist', {
    read: false,
    force: true
  })
  .pipe(clean());
});

// Clean out the dist folder
gulp.task('clean_tmp', () => {
  return gulp.src('./dist/tmp', {
    read: false,
    force: true
  })
  .pipe(clean());
});

gulp.task('handlebars', function () {

  var templateData = {
    cells: [
      {
        ger: 'Marco Lehmann',
        eng: 'marco lehmann',
        file: 'marco_lehmann'
      },
      {
        ger: 'Jobs',
        eng: 'jobs',
        file: 'jobs'
      },
      {
        ger: 'Letzte Projekte',
        eng: 'recent projects',
        file: 'projects'
      },
      {
        ger: 'Hobbys',
        eng: 'hobbys',
        file: 'hobbys'
      },
      {
        ger: 'Kontakt',
        eng: 'contact',
        file: 'contact'
      },
      {
        ger: 'Impressum',
        eng: 'imprint',
        file: 'imprint'
      }
    ]
  };
  var options = {
    ignorePartials: false,
    helpers : {
      capitals : function(str){
        return str.toUpperCase();
      }
    }
  };
  return gulp.src('src/*.html')
    .pipe(handlebars(templateData, options))
    .pipe(replace('[[', '{{'))
    .pipe(replace(']]', '}}'))
    .pipe(gulp.dest('./dist/tmp'));
});

gulp.task('markdown', function () {
  return gulp.src('./dist/tmp/*.html')
    .pipe(template('./content'))
    .pipe(gulp.dest('./dist'));
});

// Copy files
gulp.task('copy', () => {
   return gulp.src([
     // 'src/*.html',
     'src/CNAME',
     'src/*.xml',
     'src/*.json',
     'src/*.ico',
     'src/*.png',
     'src/*.svg'
   ])
   .pipe(gulp.dest('dist'));
});

// SASS compile
gulp.task('sass', () => {
  // Autoprefixer configuration
  var autoprefixerOptions = {
    browsers: [
      'last 2 versions',
      '> 5%',
      'Firefox ESR'
    ]
  };

  return gulp
    .src('src/assets/scss/**/*.scss')
    // .pipe(sourcemaps.init())
    .pipe(sass({
      errLogToConsole: true,
      outputStyle: 'compressed',
      includePaths: [
        // 'node_modules/foundation-sites/_vendor',
        // 'node_modules/foundation-sites/scss',
        // 'node_modules/animate-sass'
      ]
    }))
    .on('error', sass.logError)
    .pipe(autoprefixer(autoprefixerOptions))
    // .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('dist/assets/css'))
  ;
});

// Minify images
gulp.task('image', () => {
  return gulp.src('src/assets/image/**')
    .pipe(image())
    .pipe(gulp.dest('dist/assets/image'));
});

// Generate & Inline Critical-path CSS
// gulp.task('critical', () => {
//   return gulp.src('dist/*.html')
//     .pipe(critical({
//       base: 'dist/',
//       inline: false,
//       css: [
//         'dist/assets/css/style.css',
//         'dist/assets/css/one.css'
//       ],
//       minify: true
//     }))
//     .on('error', (err) => {
//       gutil.log(gutil.colors.red(err.message));
//     })
//     .pipe(gulp.dest('dist'));
// });

// Publish files to S3
gulp.task("cachebuster", () => {
  gulp.src('dist/*.html')
    .pipe(cachebust({
      type: 'timestamp'
    }))
    .pipe(gulp.dest('dist'));
});

// Publish files to S3
// gulp.task("publish", () => {

//   // AWS configuration
//   var publisher = awspublish.create(require('./aws-credentials.json'));

//   gulp.src("dist/**/*", { cwd: "." })
//     .pipe(awspublishRouter({
//       cache: {
//         // cache for 5 minutes by default
//         cacheTime: 300
//       },
//       routes: {
//         "^assets/(?:.+)\\.(?:js|css|svg|ttf)$": {
//           // don't modify original key. this is the default
//           key: "$&",
//           // use gzip for assets that benefit from it
//           gzip: true,
//           // cache static assets for 20 years
//           cacheTime: 630720000
//         },
//         "^assets/.+$": {
//           // cache static assets for 20 years
//           cacheTime: 630720000
//         },
//         // pass-through for anything that wasn't matched by routes above, to be uploaded with default options
//         "^.+$": "$&"
//       }
//     })
//   )
//   .pipe(publisher.publish())
//   .pipe(publisher.sync())
//   .pipe(awspublish.reporter())
// });

// gulp.task('invalidate', () => {
//   // AWS configuration
//   var publisher = awspublish.create(require('./aws-credentials.json'));

//   return gulp.src('dist/**/*')
//     .pipe(publisher.publish({
//       'Cache-Control': 'max-age=315360000, no-transform, public'
//     }))
//     .pipe(cloudfront({
//       distribution: publisher.config.cloudfront.distribution,
//       wait: true,
//       indexRootPath: true
//     }))
//     .pipe(publisher.cache())
//     .pipe(awspublish.reporter());
// });

// Watch tasks
gulp.task('watch', function () {
  gulp.watch(['src/assets/scss/**/*.scss', 'src/**/*.html', 'content/**/*.md', 'src/*.html'], ['build_without_images'])
});

gulp.task('watch_images', function () {
  gulp.watch('src/assets/image/*.*', ['build'])
});

// Build task
gulp.task('build_without_images', (callback) => {
  runSequence('clean_without_images', 'handlebars', 'markdown', 'clean_tmp', 'copy', 'sass', 'cachebuster', callback) //, 'critical'
});

// Build task
gulp.task('build', (callback) => {
  runSequence('clean', 'handlebars', 'markdown', 'clean_tmp', 'copy', 'image', 'sass', 'cachebuster', callback) //, 'critical'
});


// Default task
gulp.task('default', ['watch', 'watch_images', 'build']);

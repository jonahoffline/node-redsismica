module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files:
          'lib/redsismica.js': ['src/*.coffee']
    mochaTest:
      options:
        reporter: 'nyan'
      src: ['test/redsismica_test.coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'default', ['coffee', 'mochaTest']

class Utils

  constructor: (@fs, @path, @logger) ->


  getPageTitle: (content) ->
    titleRegex = /<title>(.*)<\/title>/i;
    match = content.match titleRegex

    if match isnt null && match.length >= 1
    then match[1]
    else null


  uniq: (a) ->
    Array.from new Set a


  mkdirSync: (path) ->
    try
      @fs.mkdirSync path
    catch e
      throw e if e.code isnt 'EEXIST'


  mkdirpSync: (dirpath) ->
    @logger.info "Making: " + dirpath
    parts = dirpath.split @path.sep

    @mkdirSync @path.join.apply(
      null, parts.slice 0, i
    ) for el, i in parts


  ###*
  # fills the HTML_FILE_LIST constant
  ###
  getAllHtmlFileNames: (dir) ->
    htmlFileList = []
    list = @fs.readdirSync dir
    list.forEach (file) =>
      fullPath = dir + "/" + file
      fileStat = @fs.statSync fullPath

      if fileStat && fileStat.isDirectory()
        htmlFileList.push (@getAllHtmlFileNames fullPath)...
      else if file.endsWith '.html'
        htmlFileList.push file

    htmlFileList


module.exports = Utils
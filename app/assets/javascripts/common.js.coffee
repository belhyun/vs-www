(($_) ->
  $_.ajax = (args) ->
    $.ajax
        type: args.type
        dataType: args.dataType
        url: args.url
        data: args.data
        success: _.wrap((isSuccess, resp) ->
          if isSuccess
            args.success.call this, resp
          else
            args.fail.call this, resp
          return
        , (fn, resp) ->
           if resp.code isnt 1
             fn false, resp
           else
             fn true, resp
        )
  _.isStrEmpty = (v) ->
    return not v or 0 is v.length
  $_.redirect = (move)->
    location.href = move
).call this, window

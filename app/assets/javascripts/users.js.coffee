# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(($_) ->
  $(document).ready ->
    $(".modal-dialog .modal-footer .btn-primary").click ->
      if(_.isStrEmpty($(".form-control").val()))
        alert($_.ERR_MSG.NICK_EMPTY)
        return
      args = {}
      args.type = 'POST'
      args.dataType = 'JSON'
      args.url = "http://"+document.location.host+"/users/nick"
      args.data = {"nick":$(".form-control").val()}
      args.success = ->
        alert($_.ERR_MSG.NICK_DUP)
        return
      args.fail = ->
        uri = new URI(document.URL).query(true)
        $_.redirect("/auth/guest?nick="+$(".form-control").val()+"&acc_token="+uri.acc_token)
      $_.ajax(args)
).call this, window

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(($_) ->
  $(document).ready ->
    $(".modal-dialog .modal-footer .btn-primary").click ->
      if(_.isStrEmpty($("#vs-email").val()))
        alert $_.ERR_MSG.EMAIL_EMPTY
        return
      if(!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test $("#vs-email").val())
        alert $_.ERR_MSG.EMAIL_FORMAT
        return
      if(_.isStrEmpty($("#vs-pwd").val()))
        alert $_.ERR_MSG.PWD_EMPTY
        return
      if(_.isStrEmpty($("#vs-nick").val()))
        alert $_.ERR_MSG.NICK_EMPTY
        return
      args = {}
      args.type = 'POST'
      args.dataType = 'JSON'
      args.url = "http://"+document.location.host+"/users/is_dup"
      args.data = {"nick":$("#vs-nick").val(),"email":$("#vs-email").val()}
      args.success = (resp)->
        if resp.body.code == 1
          alert($_.ERR_MSG.NICK_DUP)
          return
        else if resp.body.code == 2
          alert($_.ERR_MSG.EMAIL_DUP)
          return
      args.fail = ->
        uri = new URI(document.URL).query(true)
        $_.redirect(URI("/auth/vs")
          .addSearch("nick",$("#vs-nick").val())
          .addSearch("email",$("#vs-email").val())
          .addSearch("password",$("#vs-pwd").val()))
      $_.ajax(args)
).call this, window

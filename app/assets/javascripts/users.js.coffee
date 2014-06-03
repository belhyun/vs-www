# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(($_) ->
  $(document).ready ->
    $("#if-signup .modal-dialog .modal-footer .btn-primary").click ->
      if(_.isStrEmpty($("#if-signup #vs-email").val()))
        alert $_.ERR_MSG.EMAIL_EMPTY
        return
      if(!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test $("#if-signup #vs-email").val())
        alert $_.ERR_MSG.EMAIL_FORMAT
        return
      if(_.isStrEmpty($("#if-signup #vs-pwd").val()))
        alert $_.ERR_MSG.PWD_EMPTY
        return
      if(_.isStrEmpty($("#if-signup #vs-nick").val()))
        alert $_.ERR_MSG.NICK_EMPTY
        return
      args = {}
      args.type = 'POST'
      args.dataType = 'JSON'
      args.url = "http://"+document.location.host+"/users/is_dup"
      args.data = {"nick":$("#if-signup #vs-nick").val(),"email":$("#if-signup #vs-email").val()}
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
          .addSearch("nick",$("#if-signup #vs-nick").val())
          .addSearch("email",$("#if-signup #vs-email").val())
          .addSearch("password",$("#if-signup #vs-pwd").val()))
      $_.ajax(args)
    $("#if-signin .modal-dialog .modal-footer .btn-primary").click ->
      if(_.isStrEmpty($("#if-signin #vs-email").val()))
        alert $_.ERR_MSG.EMAIL_EMPTY
        return
      if(!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test $("#if-signin #vs-email").val())
        alert $_.ERR_MSG.EMAIL_FORMAT
        return
      if(_.isStrEmpty($("#if-signin #vs-pwd").val()))
        alert $_.ERR_MSG.PWD_EMPTY
        return
      uri = new URI(document.URL).query(true)
      args = {}
      args.type = 'POST'
      args.dataType = 'JSON'
      args.url = "http://"+document.location.host+"/users/is_valid_user"
      args.data = {"password":$("#if-signin #vs-pwd").val(),"email":$("#if-signin #vs-email").val()}
      args.success = (resp)->
        uri = new URI(document.URL).query(true)
        $_.redirect(URI("/auth/signin")
          .addSearch("email",$("#if-signin #vs-email").val())
          .addSearch("password",$("#if-signin #vs-pwd").val()))
      args.fail = (resp)->
        if resp.code == 0
          alert($_.ERR_MSG.NOT_VALID_USER)
          return
      $_.ajax(args)
).call this, window

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(($_) ->
  $(document).ready ->
    IFAlert = (message) ->
      $("<div></div>").dialog(
        buttons:
          Ok: ->
            #$(this).dialog "Close"
            $(this).remove()
            return
          close: (event, ui) ->
            $(this).remove()
            return
        resizable: false
        title: "IF"
        modal: false
        dialogClass: "no-close"
      ).text message
      return
    uri = new URI(document.url)
    if uri.query(true).error == "duplicate"
      IFAlert $_.ERR_MSG.DUPLICATE
      return
    $("#member-section #signup").click ->
      email = $("#input input[type=email]").val()
      pwd = $("#input input[type=password]").val()

      if(_.isStrEmpty(email))
        IFAlert $_.ERR_MSG.EMAIL_EMPTY
        return
      if(!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test email)
        IFAlert $_.ERR_MSG.EMAIL_FORMAT
        return
      if(_.isStrEmpty(pwd))
        IFAlert $_.ERR_MSG.PWD_EMPTY
        return
      if(!/^[a-zA-Z\d]{6,14}$/.test pwd)
        IFAlert $_.ERR_MSG.PWD_FORMAT
        return

      $("#if-signin").modal('show')
      $(".btn-primary").click ->
        nick = $("#vs-email").val()
        if !nick
          IFAlert "닉네임을 입력해 주세요"
          return false

        if(_.isStrEmpty(nick))
          IFAlert $_.ERR_MSG.NICK_EMPTY
          return

        if(!/^.{1,5}$/.test nick)
          IFAlert $_.ERR_MSG.NICK_FORMAT
          return
        args = {}
        args.type = 'POST'
        args.dataType = 'JSON'
        args.url = "http://"+document.location.host+"/users/is_dup"
        args.data = {"email":email, "nick":nick}
        args.success = (resp)->
          #$("#spinner,#modal").css("display","none")
          if resp.body.code == 2
            IFAlert $_.ERR_MSG.EMAIL_DUP
            return
          else if resp.body.code == 1
            IFAlert $_.ERR_MSG.NICK_DUP
            return
        args.fail = ->
          #$("#spinner,#modal").css("display","none")
          uri = new URI(document.URL).query(true)
          $_.redirect(URI("/auth/vs")
            .addSearch("email",email)
            .addSearch("password",pwd)
            .addSearch("nick",nick))
        $_.ajax(args)

    $("#member-section #signin").click ->
      email = $("#input input[type=email]").val()
      pwd = $("#input input[type=password]").val()
      if(_.isStrEmpty(email))
        IFAlert $_.ERR_MSG.EMAIL_EMPTY
        return
      if(!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test email)
        IFAlert $_.ERR_MSG.EMAIL_FORMAT
        return
      if(_.isStrEmpty(pwd))
        IFAlert $_.ERR_MSG.PWD_EMPTY
        return
      #$("#spinner,#modal").css("display","block")
      uri = new URI(document.URL).query(true)
      args = {}
      args.type = 'POST'
      args.dataType = 'JSON'
      args.url = "http://"+document.location.host+"/users/is_valid_user"
      args.data = {"password":pwd,"email":email}
      args.success = (resp)->
        #$("#spinner,#modal").css("display","none")
        uri = new URI(document.URL).query(true)
        $_.redirect(URI("/auth/signin")
          .addSearch("email",email)
          .addSearch("password",pwd))
      args.fail = (resp)->
        #$("#spinner,#modal").css("display","none")
        if resp.code == 0
          IFAlert($_.ERR_MSG.NOT_VALID_USER)
          return
      $_.ajax(args)
    $("#fb-login").click ->
      #$("#spinner,#modal").css("display","block")
      location.href = "/auth/facebook"
    $("#tw-login").click ->
      #$("#spinner,#modal").css("display","block")
      location.href = "/auth/twitter"
).call this, window

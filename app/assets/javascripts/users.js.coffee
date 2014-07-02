# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(($_) ->
  $(document).ready ->
    $("#member-section #signup").click ->
      email = $("#input input[type=email]").val()
      pwd = $("#input input[type=password]").val()
      nick = prompt("사용할 닉네임을 입력해주세요!")
      if !nick
        alert "닉네임을 입력해 주세요"
        return false

      if(_.isStrEmpty(email))
        alert $_.ERR_MSG.EMAIL_EMPTY
        return
      if(!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test email)
        alert $_.ERR_MSG.EMAIL_FORMAT
        return
      if(_.isStrEmpty(pwd))
        alert $_.ERR_MSG.PWD_EMPTY
        return
      if(_.isStrEmpty(nick))
        alert $_.ERR_MSG.NICK_EMPTY
        return
      if(!/^[a-zA-Z\d]{6,14}$/.test pwd)
        alert $_.ERR_MSG.PWD_FORMAT
        return
      if(!/^.{1,5}$/.test nick)
        alert $_.ERR_MSG.NICK_FORMAT
        return
      args = {}
      args.type = 'POST'
      args.dataType = 'JSON'
      args.url = "http://"+document.location.host+"/users/is_dup"
      args.data = {"email":email, "nick":nick}
      args.success = (resp)->
        if resp.body.code == 2
          alert $_.ERR_MSG.EMAIL_DUP
          return
        else if resp.body.code == 1
          alert $_.ERR_MSG.NICK_DUP
          return
      args.fail = ->
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
        alert $_.ERR_MSG.EMAIL_EMPTY
        return
      if(!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test email)
        alert $_.ERR_MSG.EMAIL_FORMAT
        return
      if(_.isStrEmpty(pwd))
        alert $_.ERR_MSG.PWD_EMPTY
        return
      uri = new URI(document.URL).query(true)
      args = {}
      args.type = 'POST'
      args.dataType = 'JSON'
      args.url = "http://"+document.location.host+"/users/is_valid_user"
      args.data = {"password":pwd,"email":email}
      args.success = (resp)->
        uri = new URI(document.URL).query(true)
        $_.redirect(URI("/auth/signin")
          .addSearch("email",email)
          .addSearch("password",pwd))
      args.fail = (resp)->
        if resp.code == 0
          alert($_.ERR_MSG.NOT_VALID_USER)
          return
      $_.ajax(args)
).call this, window

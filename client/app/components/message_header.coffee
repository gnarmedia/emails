{div, span, table, tbody, tr, td, img, a, i} = React.DOM
MessageUtils = require '../utils/message_utils'

{MessageFlags} = require '../constants/app_constants'


(Array.prototype.last = -> this[this.length - 1]) unless Array.prototype.last


module.exports = React.createClass
    displayName: 'MessageHeader'

    propTypes:
        message: React.PropTypes.object.isRequired


    getInitialState: ->
        detailled: false


    render: ->
        avatar = MessageUtils.getAvatar @props.message

        div null,
            if avatar
                div className: 'sender-avatar',
                    img className: 'media-object', src: avatar
            div className: 'infos',
                @renderAddress 'from'
                @renderAddress 'to'
                @renderAddress 'cc'
                div className: 'indicators',
                    if @props.message.get('attachments').length
                        i className: 'fa fa-paperclip fa-flip-horizontal'
                    if MessageFlags.FLAGGED in @props.message.get('flags')
                        i className: 'fa fa-star'
                div className: 'date',
                    MessageUtils.formatDate @props.message.get 'createdAt'
                @renderDetailsPopup()


        # attachments    = message.get('attachments')
        # hasAttachments = attachments.length
        # leftClass = if hasAttachments then 'col-md-8' else 'col-md-12'
        # flags     = message.get('flags') or []
        #
        # date      = MessageUtils.formatDate message.get 'createdAt'
        # classes = classer
        #     'header': true
        #     'row': true
        #     'full': @state.headers
        #     'compact': not @state.headers
        #     'has-attachments': hasAttachments
        #     'is-fav': flags.indexOf(MessageFlags.FLAGGED) isnt -1

        # #toggleActive = a className: "toggle-active", onClick: @toggleActive,
        # #    if @state.active
        # #        i className: 'fa fa-compress'
        # #    else
        # #        i className: 'fa fa-expand'
        # if @state.headers
        #     # detailed headers
        #     div className: classes, onClick: @toggleActive,
        #         div className: leftClass,
        #             if avatar
        #                 img className: 'sender-avatar', src: avatar
        #             else
        #                 i className: 'sender-avatar fa fa-user'
        #             div className: 'participants col-md-9',
        #                 p className: 'sender',
        #                     @renderAddress 'from'
        #                     i
        #                         className: 'toggle-headers fa fa-toggle-up clickable'
        #                         onClick: @toggleHeaders
        #                 p className: 'receivers',
        #                     span null, t "mail receivers"
        #                     @renderAddress 'to'
        #                 if @props.message.get('cc')?.length > 0
        #                     p className: 'receivers',
        #                         span null, t "mail receivers cc"
        #                         @renderAddress 'cc'
        #                 if hasAttachments
        #                     span className: 'hour', date
        #             if not hasAttachments
        #                 span className: 'hour', date
        #         if hasAttachments
        #             div className: 'col-md-4',
        #                 FilePicker
        #                     ref: 'filePicker'
        #                     editable: false
        #                     value: attachments
        #                     messageID: @props.message.get 'id'
        #         #if @props.inConversation
        #         #    toggleActive
        # else
        #     # compact headers
        #     div className: classes, onClick: @toggleActive,
        #         if avatar
        #             img className: 'sender-avatar', src: avatar
        #         else
        #             i className: 'sender-avatar fa fa-user'
        #         span className: 'participants', @getParticipants message
        #         if @state.active
        #             i
        #                 className: 'toggle-headers fa fa-toggle-down clickable'
        #                 onClick: @toggleHeaders
        #         #span className: 'subject', @props.message.get 'subject'
        #         span className: 'hour', date
        #         span className: "flags",
        #             i
        #                 className: 'attach fa fa-paperclip clickable'
        #                 onClick: @toggleHeaders
        #             i className: 'fav fa fa-star'
        #         #if @props.inConversation
        #         #    toggleActive
        #


    renderAddress: (field) ->
        formatUsers = (users) ->
            items = []

            for user in users
                label = if user.name
                    "#{user.name} <#{user.address}>"
                else
                    user.address

                items.push a null, label
                items.push ", " if user isnt users.last()

            return items

        users = @props.message.get field
        return unless users.length

        div className: "addresses #{field}",
            if field isnt 'from'
                span null,
                    t "mail #{field}: "
            formatUsers(users)...


    renderDetailsPopup: ->
        from = @props.message.get('from')[0]
        to = @props.message.get 'to'
        cc = @props.message.get 'cc'
        replyTo = @props.message.get('reply-to')?[0]

        row = (value, label = false, rowSpan = false) ->
            items = []
            if label
                attrs = className: 'label'
                attrs.rowSpan = rowSpan if rowSpan
                items.push td attrs, t label
            items.push td null, value
            return tr null, items...


        div className: 'details', 'aria-expanded': @state.detailled,
            i className: 'btn fa fa-caret-down', onClick: @showDetails
            div className: 'popup', 'aria-hidden': !@state.detailled,
                table null,
                    tbody null,
                        row "#{from.name} <#{from.address}>", 'headers from'
                        row "#{to[0].name} <#{to[0].address}>", 'headers to'
                        row "#{dest.name} <#{dest.address}>" for dest in to[1..]
                        row "#{cc[0].name} <#{cc[0].address}>", 'headers cc', cc.length if cc.length
                        row "#{dest.name} <#{dest.address}>" for dest in cc[1..] if cc.length
                        row "#{replyTo.name} <#{replyTo.address}>", 'headers reply-to' if replyTo?
                        row @props.message.get('createdAt'), 'headers date'
                        row @props.message.get('subject'), 'headers subject'

    showDetails: ->
        @setState detailled: !@state.detailled

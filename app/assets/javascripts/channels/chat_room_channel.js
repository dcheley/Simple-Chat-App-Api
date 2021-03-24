// Subscribe and process streamed message data
$(function() {
  $('[data-channel-subscribe="chat-room"]').each(function(index, element) {
    var $element = $(element),
        chat_room_id = $element.data('chat-room-id')
        messageTemplate = $('[data-role="message-template"]');

    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)

    App.cable.subscriptions.create(
      {
        channel: "ChatRoomChannel",
        chat_room: chat_room_id
      },
      {
        received: function(data) {
          var content = messageTemplate.children().clone(true, true);
          content.find('[data-role="username"]').text(data.user_name);
          content.find('[data-role="message-content"]').text(data.content);
          content.find('[data-role="message-date"]').text(data.updated_at);
          $element.append(content);
          $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);
        }
      }
    );
  });
});

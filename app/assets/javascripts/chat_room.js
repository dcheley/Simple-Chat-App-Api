// Bind the ajax:success event to submission from the messages#new form to clear
// input after a message is sent.
$(function() {
  $('#new_message').on('ajax:success', function(a, b, c) {
    $(this).find('input[type="text"]').val('');
  });
});

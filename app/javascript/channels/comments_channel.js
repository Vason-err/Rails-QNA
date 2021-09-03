import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    if (gon.question_id) {
      this.perform('follow', { question_id: gon.question_id })
    }
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(comment) {
    if (comment.author_id !== gon.current_user_id) {
      const comment_template = comment.template;

      if (comment.answer_id) {
        $(`#answer-id-${comment.answer_id}`).find('.answer-comments').append(comment_template);
      } else {
        $('.question-comments').append(comment_template);
      }
    }
  }
});

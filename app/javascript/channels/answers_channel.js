import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    if (gon.question_id) {
      this.perform('follow', { question_id: gon.question_id })
    }
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(answer) {
    const answerList = $('.answers');
    if (answer.author_id !== gon.current_user_id) {
      const answer_template = answer.templates.answer;
      answerList.append(answer_template);

      if (gon.current_user_id) {
        $(`#answer-id-${answer.id} .vote-actions`).append(answer.templates.vote_links);
        onAjaxSuccessVoteLink($(`#answer-id-${answer.id} .vote-actions .vote-link`));
      }
    }
  }
});

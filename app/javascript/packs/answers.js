$(document).on('turbolinks:load', function() {
    const answerList = $('.answers');
    answerList.on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).addClass('hidden');
        const answerId = $(this).data('answerId');
        $('form#edit-answer-form-' + answerId).removeClass('hidden');
    })

    App.cable.subscriptions.create('AnswersChannel', {
        connected() {
            if (gon.question_id) {
                this.perform('follow', { question_id: gon.question_id })
            }
        },
        received(answer) {
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
});
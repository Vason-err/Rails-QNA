$(document).on('turbolinks:load', function() {
    onAjaxCommentForm($('.new-comment-form form'));

    App.cable.subscriptions.create('CommentsChannel', {
        connected() {
            if (gon.question_id) {
                this.perform('follow', { question_id: gon.question_id })
            }
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
});

function onAjaxCommentForm(elem) {
    $(elem)
        .on('ajax:success', function(response) {
            clearCommentError(response.currentTarget);
            clearCommentForm(response.currentTarget);
            showComment(response.detail[0]);
        })
        .on('ajax:error', function(response) {
            clearCommentError(response.currentTarget);

            const error_block = $(response.currentTarget).closest('.new-comment-form').find('.comment-errors');
            $.each(response.detail[0].errors, function(index, error) {
                error_block.append(`<p>${error}</p>`)
            });
        })
}

function clearCommentError(form) {
    const error_block = $(form).closest('.new-comment-form').find('.comment-errors');
    error_block.html('');
}

function clearCommentForm(form) {
    const inputs = $(form).find('input')
    inputs.val('');
}

function showComment(comment) {
    var template = `<div className="comment" id="comment-id-${comment.id}"><p>${comment.text}</p></div>`

    switch (comment.commentable_type) {
        case 'Question':
            $('.question-comments').append(template);
            break;
        case 'Answer':
            $(`#answer-id-${comment.commentable_id}`).find('.answer-comments').append(template);
            break;
    }
}

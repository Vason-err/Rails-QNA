$(document).on('turbolinks:load', function() {
    onAjaxCommentForm($('.new-comment-form form'));
});

function onAjaxCommentForm(elem) {
  $(elem)
    .on('ajax:success', function(response) {
      clearCommentError(response.currentTarget);
      clearCommentForm(response.currentTarget);
      showComment(response.detail[0]['comment']);
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
  const template = `<div className="comment" id="comment-id-${comment.id}"><p>${comment.text}</p></div>`

  switch (comment.commentable_type) {
     case 'Question':
       $('.question-comments').append(template);
       break;
     case 'Answer':
       $(`#answer-id-${comment.commentable_id}`).find('.answer-comments').append(template);
       break;
    }
}

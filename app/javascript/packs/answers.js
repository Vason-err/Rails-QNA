$(document).on('turbolinks:load', function() {
    const answerList = $('.answers');
    answerList.on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).addClass('hidden');
        const answerId = $(this).data('answerId');
        $('form#edit-answer-form-' + answerId).removeClass('hidden');
    })
});
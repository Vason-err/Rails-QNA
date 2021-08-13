$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).addClass('hidden');
        const questionId = $(this).data('questionId');
        $('form#edit-question-form-' + questionId).removeClass('hidden');
    })
});
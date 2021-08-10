$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).addClass('hidden');
        const answerId = $(this).data('answerId');
        $('form#edit-answer-form-' + answerId).removeClass('hidden');
    })
});
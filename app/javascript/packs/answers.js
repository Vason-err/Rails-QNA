$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).addClass('hidden');
        let answerId = $(this).data('answerId');
        $('form#edit-answer-form-' + answerId).removeClass('hidden');
    })
});
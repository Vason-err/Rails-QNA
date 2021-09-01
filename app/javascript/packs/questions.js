$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).addClass('hidden');
        const questionId = $(this).data('questionId');
        $('form#edit-question-form-' + questionId).removeClass('hidden');

        const questionsList = $('.questions-list');

        App.cable.subscriptions.create('QuestionsChannel', {
            connected() {
                this.perform('follow')
            },
            received(question) {
                const template = question.template
                questionsList.append(template)
            }
        });
    })
});
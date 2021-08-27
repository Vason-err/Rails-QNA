$(document).on('turbolinks:load', function() {
    onAjaxSuccessVoteLink($('.question .vote-block .vote-link'));
    onAjaxSuccessDeleteVote($(`.question .vote-block .delete-vote`));

    onAjaxSuccessVoteLink($('.answer .vote-block .vote-link'));
    onAjaxSuccessDeleteVote($(`.answer .vote-block .delete-vote`));
});

function onAjaxSuccessVoteLink(elem) {
    $(elem).on('ajax:success', function(response) {
        successVoteLink(response, this);
    });
}

function onAjaxSuccessDeleteVote(elem) {
    $(elem).on('ajax:success', function(response) {
        successDeleteVote(response, this);
    });
}

function successVoteLink(response, elem) {
    var vote = response.detail[0];
    var vote_block = $(elem).closest('.vote-block');
    var rating_elem = vote_block.find('.vote-rating');
    var rating = parseInt(rating_elem.html());
    rating_elem.html(rating + vote.value);
    vote_block.find('.vote-links').remove();
    insertVoteResult(vote, vote_block);
    onAjaxSuccessDeleteVote(vote_block.find('.delete-vote'));
}

function successDeleteVote(response, elem) {
    var vote = response.detail[0];
    var vote_block = $(elem).closest('.vote-block');
    var rating_elem = vote_block.find('.vote-rating');
    var rating = parseInt(rating_elem.html());
    rating_elem.html(rating - vote.value);
    vote_block.find('.vote-result').remove();
    insertVoteLinks(vote, vote_block);
    onAjaxSuccessVoteLink(vote_block.find('.vote-link'));
}

function insertVoteResult(vote, voteBlock) {
    var value = vote.value > 0 ? "Plus" : "Minus";
    var voteResultBlock = `<div class='vote-result'>${value}<p><a class='delete-vote' data-remote='true' rel='nofollow' data-method='delete' href='/votes/${vote.id}'>Delete</a></p></div>`;
    voteBlock.find('.vote-actions').html(voteResultBlock);
}

function insertVoteLinks(vote, voteBlock) {
    switch (vote.voteable_type) {
        case 'Question':
            var resource = 'questions';
            break;
        case 'Answer':
            var resource = 'answers';
            break;
    }
    var voteLinksBlock = `<div class='vote-links'><p><a class='vote-link' data-remote='true' rel='nofollow' data-method='post' href='/${resource}/${vote.voteable_id}/votes?value=1'>Plus</a></p><p><a class='vote-link' data-remote='true' rel='nofollow' data-method='post' href='/${resource}/${vote.voteable_id}/votes?value=-1'>Minus</a></p></div>`;
    voteBlock.find('.vote-actions').html(voteLinksBlock);
}
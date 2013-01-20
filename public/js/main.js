function loadJokes() {
    var ts = Math.round((new Date()).getTime() / 1000);
    $('div#loadmoreajaxloader').show();
    $.ajax({
        dataType: 'json',
        url: "/api/jokes/random?limit=5&timestamp=" + ts,
        beforeSend: function ( xhr ) {
            $('div#loader').show();
            $('div#showmore').hide();
        }
    }).done(function ( data ) {
        if(data.jokes){
            $.each(data.jokes, function(key, joke) {
                $("#jokeTmpl").tmpl(joke).hide().appendTo('#jokeswrapper').fadeIn();
            });
            $('div#loader').hide();
            $('div#showmore').show();
            $('div#jokeswrapper').show();
        }else{
            $('div#loader').html('<center>No more jokes to show.</center>');
        }
    });
}

function loadJoke(id) {
    var ts = Math.round((new Date()).getTime() / 1000);
    $('div#loadmoreajaxloader').show();
    $.ajax({
        dataType: 'json',
        url: '/api/jokes/' + id + '?timestamp=' + ts,
        beforeSend: function ( xhr ) {
            $('div#loader').show();
            $('div#showmore').hide();
            $('div#jokeswrapper').hide();
            $('div#jokewrapper').html("");
        }
    }).done(function ( data ) {
            if(data.content){
                $("#jokeTmpl").tmpl(data.content).appendTo('#jokewrapper');
                $('div#loader').hide();
                $('div#jokewrapper').fadeIn();
            }else{
                $('div#loader').html('<center>No more jokes to show.</center>');
            }
    });
}

$(window).scroll(function(){
    if($(window).scrollTop() >= $(document).height() - $(window).height() - 100){
        loadJokes();
    }
});

$(document).ready(function() {
    $("#showmore").click(function() {
        loadJokes();
    });
    var hash = window.location.hash.substring(1);
    if(hash) {
        loadJoke(hash);
    } else {
        loadJokes();
    }
    $(window).bind('hashchange', function() {
        var hash = window.location.hash.substring(1);
        if(hash) {
            loadJoke(hash);
        } else {
            $('div#jokewrapper').html("");
            $('div#jokewrapper').hide();
            $('div#jokeswrapper').html("");
            loadJokes();
        }
    });
    $(window).on('click', '.joke', function () {
        var id = $(this).data('tmplItem').data._id;
        if(id) {
            window.location.hash = id;
        }
    });
});
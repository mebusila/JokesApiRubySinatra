function loadJokes() {
    var rnd = Math.floor(Math.random()*Math.round((new Date()).getTime() / 1000));
    $('div#loadmoreajaxloader').show();
    $.ajax({
        dataType: 'json',
        url: "/api/jokes/random?limit=5&rnd=" + rnd,
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

$(window).scroll(function(){
    if($(window).scrollTop() >= $(document).height() - $(window).height() - 100){
        loadJokes();
    }
});

$(document).ready(function() {
    $("#showmore").click(function() {
        loadJokes();
    });
    loadJokes();
});
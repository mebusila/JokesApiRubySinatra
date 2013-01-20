function loadJokes() {
    $('div#loadmoreajaxloader').show();
    $.ajax({
        dataType: 'json',
        url: "/api/jokes/random?limit=5",
        beforeSend: function ( xhr ) {
            $('div#loader').show();
            $('div#showmore').hide();
        }
    }).done(function ( data ) {
        if(data.jokes){
            $.each(data.jokes, function(key, joke) {
                $("#jokeTmpl").tmpl(joke).appendTo('#jokeswrapper');
            });
            $('div#loader').hide();
            $('div#showmore').show();
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
    loadJokes();
    $("#showmore").click(function() {
        loadJokes();
    });
});
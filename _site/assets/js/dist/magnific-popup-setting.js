$(function() {

    $('.post-content img').wrap( function(){
		
        $(this).magnificPopup({
            type: 'image',
            closeOnContentClick: true,
            showCloseBtn: false,
            items: {
              src: $(this).attr('src')
            },
        });
				
        $(this).parent('p').css('overflow', 'auto');
				
        // return '<figure> </figure>' + '<figcaption style="text-align: center;" class="caption">' + $(this).attr('alt') + '</figcaption>';
        return '';
    });
});
$(() => {
    $('.cont').fadeOut()
    window.addEventListener('message', (event) => {
        let v = event.data;
        if (v.type == "open") {
            $('.cont').fadeIn()
            $('.msg').html(`${v.data.msg}`)
            $('.title').html(`${v.data.title}`)
            if (v.data.img) {
                $(".img").attr("src", `${v.data.img}`)
            }else{
                $(".img").attr("src", `https://cdn.discordapp.com/attachments/980137081038843974/1049257017778384946/75-754812_question-mark-image-point-d-interrogation-png.png`)
            } 
            setTimeout(() => {
                $('.cont').fadeOut()                
            }, v.data.time);
            console.log(`MSG: ${v.data.msg} | TITLE ${v.data.title} | IMG ${v.data.img}`);
        }

    })
})
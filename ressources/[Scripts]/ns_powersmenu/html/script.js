
var Load = document.getElementById("imLoad");
var LoadVid = $('#imLoadVid')[0];
var imOverlay = document.getElementById("imOverlay");;


$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "player") {
            $('#player')[0].play();
        } else if (event.data.type == 'chargeLoop') {
            if (event.data.state == true) {
                $('#chargeLoop')[0].play()
                $('#chargeLoop')[0].volume = 0.2
            } else if (event.data.state == false) {
                $('#chargeLoop')[0].pause()
            }
        } else if (event.data.type == 'chargeLaunch') {
            $('#chargeLaunch')[0].play()
            $('#chargeLaunch')[0].volume = 0.2
        } else if (event.data.type == 'imLoad') {
            if (event.data.state == true) {
                LoadIm()
            } else if (event.data.state == false) {
                Load.style.display = 'none'
            }
        }
    });
});

function LoadIm() {
    Load.style.display = 'block'
    $('#imLoadVid')[0].load()
    $('#imLoadVid')[0].play()
}

LoadVid.addEventListener("ended", function() {
    Load.style.display = 'none'
    imOverlay.style.display = 'block'
}, true);

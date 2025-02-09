$(function () {
	window.addEventListener('message', function (event) {
        var data = event.data;

		if (data.action === "showProgress") {
			if (data.display === true) {
                $("#progressBar").show();

                var start = new Date();
                var maxTime = data.time;
                var text = data.text;
                var timeoutVal = Math.floor(maxTime/100);

                animateUpdate();

                $('#pbar_innertext').text(text);

                function updateProgress(percentage) {
                    $('#pbar_innerdiv').css("width", percentage + "%");
                }
                
                function animateUpdate() {
                    var now = new Date();
                    var timeDiff = now.getTime() - start.getTime();
                    var perc = Math.round((timeDiff/maxTime)*100);
                    if (perc <= 100) {
                        updateProgress(perc);
                        setTimeout(animateUpdate, timeoutVal);
                    } else {
                        $("#progressBar").hide();
                    }
                }
            } else {
                $("#progressBar").hide();
            }
        }
	})
})
window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "updateHUD") {
        updateRightTextContent('#bank', '$' + data.bank.toLocaleString());
        updateRightTextContent('#cash', '$' + data.cash.toLocaleString());
        
        updateTextContent('.id', '#' + data.playerId);
        updateTextContent('.online', data.players + ' /1024');
        
        updateProgressBar('hunger-bar', data.hunger);
        updateProgressBar('thirst-bar', data.thirst);
    } else if (data.type === "updateDateTime") {
        updateTextContent('.date-text', data.date);
        updateTextContent('.hour-text', data.time);
    }
});

function updateTextContent(selector, newText) {
    var element = document.querySelector(selector);
    if (element) {
        var icon = element.querySelector('i');
        var span = element.querySelector('span') || document.createElement('span');
        
        span.textContent = newText;
        
        element.innerHTML = '';
        
        if (icon) element.appendChild(icon);
        element.appendChild(span);
    }
}

function updateRightTextContent(selector, newText) {
    var element = document.querySelector(selector);
    if (element) {
        var icon = element.querySelector('i');
        var span = element.querySelector('span') || document.createElement('span');

        span.textContent = newText;

        element.innerHTML = '';

        if (icon)
            element.appendChild(span);
        element.appendChild(icon);
    }
}

function updateProgressBar(barId, percent) {
    var progressBar = document.querySelector(`#${barId} .progresss`);
    if (progressBar) {
        progressBar.style.width = `${percent}%`;
    }
    
    var statusBar = document.querySelector(`#${barId}`);
    if (statusBar) {
        statusBar.setAttribute('data-value', `${percent}%`);
        
        if (percent < 20) {
            statusBar.classList.add('low-status');
        } else {
            statusBar.classList.remove('low-status');
        }
    }
}

function updateDateTime() {
    var now = new Date();
    var dateString = now.toLocaleDateString('fr-FR');
    var timeString = now.toLocaleTimeString('fr-FR');
    
    updateTextContent('.date-text', dateString);
    updateTextContent('.hour-text', timeString);
}

setInterval(updateDateTime, 1000);
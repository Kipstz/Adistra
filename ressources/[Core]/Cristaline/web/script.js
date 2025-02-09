// html/script.js
$(document).ready(function() {
    let isTabletOpen = false;

    // Gestion des messages NUI
    window.addEventListener('message', function(event) {
        const item = event.data;
        if (item.type === "ui") {
            if (item.status) {
                openTablet();
            } else {
                closeTablet();
            }
        }
    });

    // Fonction pour ouvrir la tablette
    function openTablet() {
        isTabletOpen = true;
        $('body').css('display', 'flex');
        showLoading();
        setTimeout(() => {
            hideLoading();
            showHome();
        }, 1500);
    }

    // Fonction pour fermer la tablette
    function closeTablet() {
        isTabletOpen = false;
        $('body').css('display', 'none');
        resetToHome();
    }

    // Fonction pour afficher l'écran de chargement
    function showLoading() {
        $('#loading-screen').css('display', 'flex').fadeIn(300);
    }

    // Fonction pour cacher l'écran de chargement
    function hideLoading() {
        $('#loading-screen').fadeOut(300);
    }

    // Fonction pour afficher la page d'accueil
    function showHome() {
        $('.app-page').removeClass('active');
        $('#home-page').removeClass('hiding').addClass('active');
        updateTime(); // Met à jour l'heure immédiatement
    }

    // Fonction pour réinitialiser à la page d'accueil
    function resetToHome() {
        $('.app-page').removeClass('active');
        $('#home-page').removeClass('hiding').addClass('active');
    }

    // Animation des éléments de la page standard
    function animatePageContent() {
        $('.page-content div').css({
            'opacity': '0',
            'transform': 'translateY(20px)'
        });

        $('.page-content div').each(function(index) {
            setTimeout(() => {
                $(this).css({
                    'opacity': '1',
                    'transform': 'translateY(0)',
                    'transition': 'all 0.3s ease-out'
                });
            }, 100 * (index + 1));
        });
    }

    // Animation spéciale pour la page bancaire
    function animateBankPage() {
        $('.bank-card, .balance-box, .transactions-box').css({
            'opacity': '0',
            'transform': 'translateY(20px)'
        });

        // Animation de la carte bancaire
        setTimeout(() => {
            $('.bank-card').css({
                'opacity': '1',
                'transform': 'translateY(0)',
                'transition': 'all 0.5s ease-out'
            });
        }, 100);

        // Animation du solde
        setTimeout(() => {
            $('.balance-box').css({
                'opacity': '1',
                'transform': 'translateY(0)',
                'transition': 'all 0.5s ease-out'
            });
        }, 300);

        // Animation des transactions
        setTimeout(() => {
            $('.transactions-box').css({
                'opacity': '1',
                'transform': 'translateY(0)',
                'transition': 'all 0.5s ease-out'
            });
        }, 500);
    }

    // Fonction pour afficher une page d'application
    function showAppPage(pageName) {
        $('#home-page').addClass('hiding');
        setTimeout(() => {
            $('#home-page').removeClass('active');
            $('.app-page').removeClass('active');
            $(`#${pageName}-page`).addClass('active');

            // Choix de l'animation selon la page
            if (pageName === 'bank') {
                animateBankPage();
            } else {
                animatePageContent();
            }
        }, 300);
    }

    // Mise à jour de l'heure
    function updateTime() {
        const now = new Date();
        $('.time').text(now.toLocaleTimeString('fr-FR', {
            hour: '2-digit',
            minute: '2-digit'
        }));
    }

    // Démarrage de la mise à jour de l'heure
    setInterval(updateTime, 1000);
    updateTime();

    // Gestionnaires d'événements pour les clics

    // Clic sur les applications
    $('.app').click(function() {
        const pageName = $(this).data('page');
        if (pageName) {
            showAppPage(pageName);

            // Post vers le client Lua pour notification de changement de page
            $.post(`https://${GetParentResourceName()}/appClick`, JSON.stringify({
                app: $(this).find('.app-label').text()
            }));
        }
    });

    $('.user-avatar').click(function() {
        showHome();
    });

    // Clic sur le bouton retour
    $('.back-btn').click(function() {
        showHome();
    });

    $('.dock').click(function() {
        $.post(`https://${GetParentResourceName()}/exit`);
    });

    // Clic sur les transactions (pour la page bancaire)
    $('.transaction').click(function() {
        $(this).css('transform', 'scale(0.98)');
        setTimeout(() => {
            $(this).css('transform', 'scale(1)');
        }, 100);
    });

    // Gestion de la touche Echap
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            if ($('#home-page').hasClass('active')) {
                $.post(`https://${GetParentResourceName()}/exit`);
            } else {
                showHome();
            }
        }
    });

    $('.app, .back-btn, .transaction').hover(
        function() {
            $(this).css('transition', 'all 0.2s ease');
        },
        function() {
            $(this).css('transition', 'all 0.2s ease');
        }
    );

    window.onerror = function(msg, url, lineNo, columnNo, error) {
        console.log('Error: ' + msg + '\nURL: ' + url + '\nLine: ' + lineNo + '\nColumn: ' + columnNo + '\nError object: ' + JSON.stringify(error));
        return false;
    };

    function updateBankData(data) {
        if (data.balance) {
            $('.balance-amount').text(`$${data.balance.toLocaleString()}`);
        }
        if (data.transactions) {
            updateTransactions(data.transactions);
        }
    }

    function updateTransactions(transactions) {
        const transactionBox = $('.transactions-box');
        transactionBox.empty();

        transactions.forEach(transaction => {
            // Création des nouvelles transactions
            const transactionElement = createTransactionElement(transaction);
            transactionBox.append(transactionElement);
        });
    }

    function getTransactionIcon(type) {
        // Retourne l'icône appropriée selon le type de transaction
        const icons = {
            shopping: 'fa-shopping-cart',
            salary: 'fa-money-bill-wave',
            gas: 'fa-gas-pump',
            transfer: 'fa-exchange-alt',
            default: 'fa-receipt'
        };
        return icons[type] || icons.default;
    }

    function initializeBankPage() {
        // Configuration du graphique
        const ctx = document.getElementById('transactionsChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
                datasets: [{
                    data: [1200, 2100, 800, 1600, 2400, 900],
                    borderColor: 'rgb(255, 255, 255)',
                    borderWidth: 2,
                    tension: 0.4,
                    pointStyle: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false,
                            drawBorder: false
                        },
                        ticks: {
                            color: '#666'
                        }
                    },
                    y: {
                        display: false
                    }
                }
            }
        });

        // Données des transactions
        const transactions = [
            {
                type: 'deposit',
                name: 'Dépôt facture',
                subtext: 'Thomas Carter',
                amount: '+$10,000',
                date: '09/05/24',
                icon: 'fa-money-bill-wave'
            },
            {
                type: 'withdrawal',
                name: 'Sortie',
                subtext: 'Thomas Carter',
                amount: '-$10,000',
                date: '09/05/24',
                icon: 'fa-arrow-right'
            },
            {
                type: 'deposit',
                name: 'Dépôt facture',
                subtext: 'Thomas Carter',
                amount: '+$10,000',
                date: '09/05/24',
                icon: 'fa-money-bill-wave'
            }
        ];

        // Générer la liste des transactions
        const transactionsList = document.querySelector('.transactions-list');
        transactions.forEach(transaction => {
            const transactionElement = createTransactionElement(transaction);
            transactionsList.appendChild(transactionElement);
        });
    }

    function createTransactionElement(transaction) {
        const div = document.createElement('div');
        div.className = 'transaction-item';

        div.innerHTML = `
        <div class="transaction-info">
            <div class="transaction-icon">
                <i class="fas ${transaction.icon}"></i>
            </div>
            <div class="transaction-details">
                <span class="transaction-name">${transaction.name}</span>
                <span class="transaction-date">${transaction.date}</span>
            </div>
        </div>
        <span class="transaction-amount ${transaction.type === 'deposit' ? 'income' : 'expense'}">
            ${transaction.amount}
        </span>
    `;

        return div;
    }

// Initialiser la page bancaire quand elle est affichée
    document.querySelector('[data-page="bank"]').addEventListener('click', () => {
        setTimeout(() => {
            initializeBankPage();
        }, 300);
    });
});
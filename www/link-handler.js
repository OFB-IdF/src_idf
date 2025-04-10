/**
 * link-handler.js
 * 
 * Ce script gère les interactions avec les liens dans l'application FichesSRC.
 * Il permet de :
 * 1. Copier les URLs des liens locaux dans le presse-papier
 * 2. Tenter d'ouvrir l'explorateur Windows pour les liens locaux
 * 3. Gérer différemment les liens internes et externes
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialiser la gestion des liens une fois que le DOM est chargé
    initLinkHandlers();
    
    // Observer les modifications du DOM pour gérer les liens ajoutés dynamiquement
    setupMutationObserver();
});

/**
 * Configure un observateur de mutations pour détecter les nouveaux liens ajoutés au DOM
 */
function setupMutationObserver() {
    // Créer un observateur de mutations
    const observer = new MutationObserver(function(mutations) {
        let shouldProcessLinks = false;
        
        // Vérifier si des nœuds ont été ajoutés
        mutations.forEach(function(mutation) {
            if (mutation.addedNodes.length) {
                shouldProcessLinks = true;
            }
        });
        
        // Si des nœuds ont été ajoutés, traiter les liens
        if (shouldProcessLinks) {
            initLinkHandlers();
        }
    });
    
    // Configurer l'observateur pour surveiller les ajouts de nœuds dans tout le document
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
}

/**
 * Initialise les gestionnaires d'événements pour tous les liens
 */
function initLinkHandlers() {
    // Sélectionner tous les liens dans le document
    const links = document.querySelectorAll('a');
    
    links.forEach(link => {
        // Vérifier si le lien a déjà été traité
        if (link.hasAttribute('data-link-handled')) {
            return;
        }
        
        // Marquer le lien comme traité
        link.setAttribute('data-link-handled', 'true');
        
        // Vérifier si c'est un lien local (commence par file:)
        const href = link.getAttribute('href');
        if (href && href.startsWith('file:')) {
            // Remplacer le comportement par défaut pour les liens locaux
            setupLocalLinkHandler(link, href);
        } else if (href && !href.startsWith('javascript:')) {
            // Pour les liens externes, ajouter target="_blank" s'il n'existe pas déjà
            if (!link.getAttribute('target')) {
                link.setAttribute('target', '_blank');
            }
        }
    });
}

/**
 * Configure le gestionnaire pour les liens locaux
 * @param {HTMLElement} link - L'élément lien à configurer
 * @param {string} href - L'URL du lien
 */
function setupLocalLinkHandler(link, href) {
    // Supprimer l'attribut href original pour empêcher la navigation par défaut
    link.removeAttribute('href');
    link.setAttribute('data-file-path', href);
    link.style.cursor = 'pointer';
    link.style.textDecoration = 'underline';
    link.style.color = '#0066cc';
    
    // Créer un conteneur pour le lien et les boutons
    const linkContainer = document.createElement('span');
    linkContainer.className = 'link-container';
    linkContainer.style.display = 'inline-flex';
    linkContainer.style.alignItems = 'center';
    
    // Déplacer le lien dans le conteneur
    const linkParent = link.parentNode;
    linkParent.insertBefore(linkContainer, link);
    linkContainer.appendChild(link);
    
    // Créer le bouton de copie
    const copyButton = document.createElement('button');
    copyButton.className = 'link-action-button copy-button';
    copyButton.innerHTML = '<i class="fas fa-copy"></i>';
    copyButton.title = 'Copier l\'adresse';
    copyButton.style.marginLeft = '5px';
    copyButton.style.padding = '2px 5px';
    copyButton.style.fontSize = '0.8em';
    copyButton.style.backgroundColor = '#f0f0f0';
    copyButton.style.border = '1px solid #ccc';
    copyButton.style.borderRadius = '3px';
    copyButton.style.cursor = 'pointer';
    
    // Créer le bouton d'ouverture dans l'explorateur
    const openButton = document.createElement('button');
    openButton.className = 'link-action-button open-button';
    openButton.innerHTML = '<i class="fas fa-folder-open"></i>';
    openButton.title = 'Ouvrir dans l\'explorateur';
    openButton.style.marginLeft = '5px';
    openButton.style.padding = '2px 5px';
    openButton.style.fontSize = '0.8em';
    openButton.style.backgroundColor = '#f0f0f0';
    openButton.style.border = '1px solid #ccc';
    openButton.style.borderRadius = '3px';
    openButton.style.cursor = 'pointer';
    
    // Ajouter les boutons au conteneur
    linkContainer.appendChild(copyButton);
    linkContainer.appendChild(openButton);
    
    // Ajouter les gestionnaires d'événements
    link.addEventListener('click', function(e) {
        e.preventDefault();
    });
    
    copyButton.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        copyToClipboard(href);
    });
    
    openButton.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        openInExplorer(href);
    });
}

// La fonction showLinkOptions a été supprimée car remplacée par des boutons d'action directe

/**
 * Copie un texte dans le presse-papier
 * @param {string} text - Le texte à copier
 */
function copyToClipboard(text) {
    // Essayer d'abord avec l'API Clipboard moderne
    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text)
            .then(() => {
                showNotification('Adresse copiée dans le presse-papier!');
            })
            .catch(err => {
                console.error('Erreur avec l\'API Clipboard: ', err);
                // Utiliser la méthode de secours
                fallbackCopyToClipboard(text);
            });
    } else {
        // Utiliser la méthode de secours pour les contextes non sécurisés (comme les fichiers locaux)
        fallbackCopyToClipboard(text);
    }
}

/**
 * Méthode alternative pour copier du texte dans le presse-papier
 * @param {string} text - Le texte à copier
 */
function fallbackCopyToClipboard(text) {
    try {
        // Créer un élément textarea temporaire
        const textArea = document.createElement('textarea');
        textArea.value = text;
        
        // Rendre l'élément invisible mais présent dans le DOM
        textArea.style.position = 'fixed';
        textArea.style.left = '-999999px';
        textArea.style.top = '-999999px';
        document.body.appendChild(textArea);
        
        // Sélectionner et copier le texte
        textArea.focus();
        textArea.select();
        
        const successful = document.execCommand('copy');
        document.body.removeChild(textArea);
        
        if (successful) {
            showNotification('Adresse copiée dans le presse-papier!');
        } else {
            showNotification('Impossible de copier l\'adresse. Veuillez essayer manuellement.', true);
        }
    } catch (err) {
        console.error('Erreur lors de la copie (méthode alternative): ', err);
        showNotification('Impossible de copier l\'adresse', true);
    }
}

/**
 * Tente d'ouvrir un chemin dans l'explorateur Windows
 * @param {string} filePath - Le chemin du fichier à ouvrir
 */
function openInExplorer(filePath) {
    try {
        // Copier d'abord l'URL dans le presse-papier
        copyToClipboard(filePath);
        
        // Ouvrir un nouvel onglet vierge
        const win = window.open('about:blank', '_blank');
        if (win) {
            win.focus();
            showNotification('Nouvel onglet ouvert. Vous pouvez y coller l\'URL (Ctrl+V)');
        } else {
            showNotification('Le navigateur a bloqué l\'ouverture du nouvel onglet. Veuillez l\'autoriser.', true);
        }
    } catch (err) {
        console.error('Erreur lors de l\'ouverture: ', err);
        showNotification('Impossible d\'ouvrir le nouvel onglet. Veuillez essayer manuellement.', true);
    }
}

/**
 * Affiche une notification temporaire
 * @param {string} message - Le message à afficher
 * @param {boolean} isError - Indique si c'est une erreur
 */
function showNotification(message, isError = false) {
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.style.position = 'fixed';
    notification.style.bottom = '20px';
    notification.style.right = '20px';
    notification.style.padding = '10px 15px';
    notification.style.backgroundColor = isError ? '#f44336' : '#4CAF50';
    notification.style.color = 'white';
    notification.style.borderRadius = '4px';
    notification.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
    notification.style.zIndex = '2000';
    notification.style.transition = 'opacity 0.5s';
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Faire disparaître la notification après 3 secondes
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => {
            if (document.body.contains(notification)) {
                document.body.removeChild(notification);
            }
        }, 500);
    }, 3000);
}
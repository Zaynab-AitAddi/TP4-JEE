// ============================================
// UTILITAIRES GÉNÉRAUX
// ============================================

/**
 * Affiche un message de notification
 */
function showNotification(message, type = 'info', duration = 3000) {
    const alertClass = `alert alert-${type}`;
    const alertHTML = `
        <div class="${alertClass}" style="display: none;">
            <span class="alert-icon">
                ${type === 'success' ? '✓' : type === 'error' ? '✕' : 'ℹ'}
            </span>
            ${message}
        </div>
    `;

    const container = document.querySelector('.main-content') || document.body;
    const alert = new DOMParser().parseFromString(alertHTML, 'text/html').body.firstChild;
    container.insertBefore(alert, container.firstChild);

    alert.style.display = 'block';
    setTimeout(() => {
        alert.style.opacity = '0';
        setTimeout(() => alert.remove(), 300);
    }, duration);
}

/**
 * Valide un email
 */
function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Valide la force du mot de passe
 */
function validatePassword(password) {
    const minLength = password.length >= 8;
    const hasUpperCase = /[A-Z]/.test(password);
    const hasLowerCase = /[a-z]/.test(password);
    const hasDigit = /\d/.test(password);

    return minLength && hasUpperCase && hasLowerCase && hasDigit;
}

/**
 * Affiche les critères du mot de passe
 */
function updatePasswordStrength(passwordInput) {
    const password = passwordInput.value;
    const requirements = {
        minLength: password.length >= 8,
        hasUpperCase: /[A-Z]/.test(password),
        hasLowerCase: /[a-z]/.test(password),
        hasDigit: /\d/.test(password)
    };

    const passesAll = Object.values(requirements).every(val => val);

    if (passesAll) {
        passwordInput.style.borderColor = '#10b981';
    } else {
        passwordInput.style.borderColor = '#ef4444';
    }
}

/**
 * Formate une date
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

/**
 * Formate un prix
 */
function formatPrice(price) {
    return new Intl.NumberFormat('fr-FR', {
        style: 'currency',
        currency: 'EUR'
    }).format(price);
}

// ============================================
// GESTION DES FORMULAIRES
// ============================================

/**
 * Initialise les écouteurs pour les formulaires
 */
function initFormListeners() {
    // Formulaire de connexion
    const loginForm = document.querySelector('.login-form');
    if (loginForm) {
        const emailInput = loginForm.querySelector('#email');
        const passwordInput = loginForm.querySelector('#password');

        if (emailInput) {
            emailInput.addEventListener('blur', function() {
                if (this.value && !validateEmail(this.value)) {
                    this.style.borderColor = '#ef4444';
                } else {
                    this.style.borderColor = '';
                }
            });
        }
    }

    // Formulaire d'inscription
    const signupForm = document.querySelector('.signup-form');
    if (signupForm) {
        const passwordInput = signupForm.querySelector('#password');
        const confirmInput = signupForm.querySelector('#confirmPassword');
        const emailInput = signupForm.querySelector('#email');

        if (passwordInput) {
            passwordInput.addEventListener('input', function() {
                updatePasswordStrength(this);
            });
        }

        if (confirmInput) {
            confirmInput.addEventListener('input', function() {
                if (this.value && passwordInput.value !== this.value) {
                    this.style.borderColor = '#ef4444';
                } else {
                    this.style.borderColor = '';
                }
            });
        }

        if (emailInput) {
            emailInput.addEventListener('blur', function() {
                if (this.value && !validateEmail(this.value)) {
                    this.style.borderColor = '#ef4444';
                } else {
                    this.style.borderColor = '';
                }
            });
        }
    }

    // Formulaires de produits
    const productForm = document.querySelector('.product-form');
    if (productForm) {
        const prixInput = productForm.querySelector('#prix');
        if (prixInput) {
            prixInput.addEventListener('change', function() {
                if (this.value && this.value <= 0) {
                    this.style.borderColor = '#ef4444';
                } else {
                    this.style.borderColor = '';
                }
            });
        }
    }
}

// ============================================
// GESTION DU TABLEAU
// ============================================

/**
 * Initialise les interactions du tableau
 */
function initTableInteractions() {
    const deleteButtons = document.querySelectorAll('.btn-delete');

    deleteButtons.forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (!confirm('Êtes-vous sûr de vouloir supprimer ce produit? Cette action est irréversible.')) {
                e.preventDefault();
            }
        });
    });

    // Tri du tableau
    const tableHeaders = document.querySelectorAll('.products-table th');
    tableHeaders.forEach((header, index) => {
        if (index < 5) { // Exclure la colonne Actions
            header.style.cursor = 'pointer';
            header.addEventListener('click', function() {
                sortTable(index);
            });
        }
    });
}

/**
 * Trie le tableau
 */
function sortTable(columnIndex) {
    const table = document.querySelector('.products-table');
    const rows = Array.from(table.querySelectorAll('tbody tr'));
    const isAscending = !table.dataset.sortAscending;

    rows.sort((a, b) => {
        const aValue = a.cells[columnIndex].textContent.trim();
        const bValue = b.cells[columnIndex].textContent.trim();

        // Essayer de convertir en nombre
        const aNum = parseFloat(aValue);
        const bNum = parseFloat(bValue);

        if (!isNaN(aNum) && !isNaN(bNum)) {
            return isAscending ? aNum - bNum : bNum - aNum;
        }

        return isAscending ? 
            aValue.localeCompare(bValue) : 
            bValue.localeCompare(aValue);
    });

    const tbody = table.querySelector('tbody');
    rows.forEach(row => tbody.appendChild(row));
    table.dataset.sortAscending = isAscending;
}

// ============================================
// GESTION DE LA RECHERCHE
// ============================================

/**
 * Initialise la recherche auto-complète
 */
function initSearch() {
    const searchInput = document.querySelector('.search-input');
    
    if (searchInput) {
        let searchTimeout;
        
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                // Optionnel: chercher à mesure qu'on tape (AJAX)
                // Pour maintenant, la recherche se fait lors du submit
            }, 300);
        });
    }
}

// ============================================
// ANIMATIONS ET INTERACTIONS
// ============================================

/**
 * Initialise les animations au chargement
 */
function initAnimations() {
    // Fade-in des éléments
    const elements = document.querySelectorAll('.alert, .form-box, .login-box, .signup-box, .table-container');
    elements.forEach((el, index) => {
        el.style.animation = `fadeIn 0.5s ease-in-out ${index * 0.1}s both`;
    });
}

/**
 * Ajoute les animations CSS
 */
function injectAnimations() {
    const style = document.createElement('style');
    style.textContent = `
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.5;
            }
        }
    `;
    document.head.appendChild(style);
}

// ============================================
// GESTION DE LA SESSION
// ============================================

/**
 * Affiche une alerte de session expirée
 */
function checkSessionTimeout() {
    // Cette vérification se fait côté serveur via le filtre
    // Cette fonction peut être utilisée pour du feedback utilisateur
}

// ============================================
// INITIALISATION AU CHARGEMENT
// ============================================

document.addEventListener('DOMContentLoaded', function() {
    console.log('Application Gestion des Produits - Chargée');

    // Injecter les animations CSS
    injectAnimations();

    // Initialiser tous les composants
    initFormListeners();
    initTableInteractions();
    initSearch();
    initAnimations();

    // Gestion des paramètres GET pour les messages de succès/erreur
    const urlParams = new URLSearchParams(window.location.search);
    
    if (urlParams.has('success')) {
        showNotification(urlParams.get('success'), 'success', 4000);
    }

    if (urlParams.has('error')) {
        showNotification(urlParams.get('error'), 'error', 4000);
    }

    // Nettoyer les paramètres GET de la barre d'adresse
    if (urlParams.has('success') || urlParams.has('error')) {
        setTimeout(() => {
            const newUrl = window.location.pathname;
            window.history.replaceState({}, document.title, newUrl);
        }, 500);
    }

    // Confirmation avant de quitter si des modifications non sauvegardées
    let hasChanged = false;
    const form = document.querySelector('form');
    
    if (form) {
        form.addEventListener('change', () => {
            hasChanged = true;
        });

        window.addEventListener('beforeunload', (e) => {
            if (hasChanged && !form.checkValidity()) {
                e.preventDefault();
                e.returnValue = '';
                return '';
            }
        });

        form.addEventListener('submit', () => {
            hasChanged = false;
        });
    }
});

// Export pour utilisation externe si nécessaire
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        validateEmail,
        validatePassword,
        formatPrice,
        showNotification
    };
}
// ============================================
// FONCTIONS SPÉCIFIQUES POUR LA PAGE D'AJOUT
// ============================================

/**
 * Initialise l'aperçu en direct du formulaire d'ajout
 */
function initAddProductPreview() {
    const nomInput = document.getElementById('nom');
    const descInput = document.getElementById('description');
    const prixInput = document.getElementById('prix');
    const categorieSelect = document.getElementById('categorie');

    const previewNom = document.getElementById('previewNom');
    const previewDescription = document.getElementById('previewDescription');
    const previewPrix = document.getElementById('previewPrix');
    const previewCategorie = document.getElementById('previewCategorie');

    if (!nomInput) return;

    function updatePreview() {
        if (previewNom) previewNom.textContent = nomInput.value.trim() || '---';
        
        if (previewDescription) {
            let desc = descInput.value.trim();
            if (desc.length > 100) desc = desc.substring(0, 100) + '...';
            previewDescription.textContent = desc || '---';
        }
        
        if (previewPrix) {
            let prix = parseFloat(prixInput.value);
            if (!isNaN(prix) && prix > 0) {
                previewPrix.textContent = prix.toFixed(2) + ' €';
            } else {
                previewPrix.textContent = '0,00 €';
            }
        }
        
        if (previewCategorie && categorieSelect) {
            let selectedOption = categorieSelect.options[categorieSelect.selectedIndex];
            previewCategorie.textContent = categorieSelect.value ? selectedOption.text : '---';
        }
    }

    function updateCharCounters() {
        const nomLen = nomInput.value.length;
        const descLen = descInput.value.length;
        
        const nomCounter = document.getElementById('nomCount');
        const descCounter = document.getElementById('descCount');
        
        if (nomCounter) {
            nomCounter.textContent = nomLen;
            const parent = nomCounter.parentElement;
            if (nomLen > 80) parent.classList.add('warning');
            else parent.classList.remove('warning');
            if (nomLen > 90) parent.classList.add('danger');
            else parent.classList.remove('danger');
        }
        
        if (descCounter) {
            descCounter.textContent = descLen;
            const parent = descCounter.parentElement;
            if (descLen > 400) parent.classList.add('warning');
            else parent.classList.remove('warning');
            if (descLen > 480) parent.classList.add('danger');
            else parent.classList.remove('danger');
        }
    }

    nomInput.addEventListener('input', () => { updatePreview(); updateCharCounters(); });
    descInput.addEventListener('input', () => { updatePreview(); updateCharCounters(); });
    if (prixInput) prixInput.addEventListener('input', updatePreview);
    if (categorieSelect) categorieSelect.addEventListener('change', updatePreview);

    updatePreview();
    updateCharCounters();
}

/**
 * Initialise la validation du formulaire d'ajout
 */
function initAddProductValidation() {
    const form = document.getElementById('addProductForm');
    if (!form) return;

    form.addEventListener('submit', function(e) {
        const nom = document.getElementById('nom')?.value.trim();
        const description = document.getElementById('description')?.value.trim();
        const prix = parseFloat(document.getElementById('prix')?.value);
        const categorie = document.getElementById('categorie')?.value;
        
        if (nom && nom.length < 2) {
            e.preventDefault();
            alert('❌ Le nom du produit doit contenir au moins 2 caractères');
            document.getElementById('nom')?.focus();
            return false;
        }
        
        if (description && description.length < 10) {
            e.preventDefault();
            alert('❌ La description doit contenir au moins 10 caractères');
            document.getElementById('description')?.focus();
            return false;
        }
        
        if (isNaN(prix) || prix <= 0) {
            e.preventDefault();
            alert('❌ Le prix doit être un nombre supérieur à 0');
            document.getElementById('prix')?.focus();
            return false;
        }
        
        if (!categorie) {
            e.preventDefault();
            alert('❌ Veuillez sélectionner une catégorie');
            document.getElementById('categorie')?.focus();
            return false;
        }
        
        return true;
    });
}

// Initialiser les fonctions spécifiques au chargement
document.addEventListener('DOMContentLoaded', function() {
    initAddProductPreview();
    initAddProductValidation();
});
package metier;

import dao.impl.UserDAOImpl;
import dao.interfaces.IUserDAO;
import dao.model.User;
import dao.model.Role;
import util.PasswordUtil;
import util.ValidationUtil;
import java.util.List;

/**
 * Service métier pour l'authentification et la gestion des utilisateurs
 */
public class UserMetier {
    private static UserMetier instance;
    private IUserDAO dao;

    private UserMetier() {
        this.dao = new UserDAOImpl();
    }

    /**
     * Récupère l'instance singleton du service
     * 
     * @return Instance unique de UserMetier
     */
    public static UserMetier getInstance() {
        if (instance == null) {
            synchronized (UserMetier.class) {
                if (instance == null) {
                    instance = new UserMetier();
                }
            }
        }
        return instance;
    }

    /**
     * Authentifie un utilisateur
     * 
     * @param email    L'email de l'utilisateur
     * @param password Le mot de passe
     * @return L'utilisateur authentifié ou null
     */
    public User authenticate(String email, String password) {
        try {
            if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password)) {
                return null;
            }

            User user = dao.getUserByEmail(email);
            if (user == null || !user.isActif()) {
                return null;
            }

            if (PasswordUtil.verifyPassword(password, user.getPassword())) {
                return user;
            }
            return null;
        } catch (Exception e) {
            System.err.println("Erreur lors de l'authentification: " + e.getMessage());
            return null;
        }
    }

    /**
     * Enregistre un nouvel utilisateur
     * 
     * @param email    L'email
     * @param password Le mot de passe
     * @param nom      Le nom
     * @param prenom   Le prénom
     * @return true si l'enregistrement est réussi, false sinon
     */
    public boolean signUp(String email, String password, String nom, String prenom) {
        try {
            // Validations
            if (!ValidationUtil.isValidEmail(email)) {
                return false;
            }

            if (!ValidationUtil.isValidName(nom) || !ValidationUtil.isValidName(prenom)) {
                return false;
            }

            if (!PasswordUtil.isStrongPassword(password)) {
                return false;
            }

            // Vérifier si l'utilisateur existe déjà
            if (dao.userExists(email)) {
                return false;
            }

            // Créer et ajouter le nouvel utilisateur
            User newUser = new User(email, PasswordUtil.hashPassword(password), nom, prenom);
            newUser.setRole(Role.USER);
            dao.addUser(newUser);

            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de l'inscription: " + e.getMessage());
            return false;
        }
    }

    /**
     * Récupère un utilisateur par son email
     * 
     * @param email L'email
     * @return L'utilisateur ou null
     */
    public User getUserByEmail(String email) {
        try {
            if (ValidationUtil.isEmpty(email)) {
                return null;
            }
            return dao.getUserByEmail(email);
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération de l'utilisateur: " + e.getMessage());
            return null;
        }
    }

    /**
     * Récupère un utilisateur par son ID
     * 
     * @param id L'ID
     * @return L'utilisateur ou null
     */
    public User getUserById(Long id) {
        try {
            if (id == null || id <= 0) {
                return null;
            }
            return dao.getUserById(id);
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération de l'utilisateur: " + e.getMessage());
            return null;
        }
    }

    /**
     * Récupère tous les utilisateurs
     * 
     * @return Liste de tous les utilisateurs
     */
    public List<User> getAllUsers() {
        try {
            return dao.getAllUsers();
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des utilisateurs: " + e.getMessage());
            return List.of();
        }
    }

    /**
     * Met à jour un utilisateur
     * 
     * @param user L'utilisateur à mettre à jour
     * @return true si la mise à jour est réussie
     */
    public boolean updateUser(User user) {
        try {
            if (user == null || user.getIdUser() == null) {
                return false;
            }
            dao.updateUser(user);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la mise à jour de l'utilisateur: " + e.getMessage());
            return false;
        }
    }

    /**
     * Supprime un utilisateur
     * 
     * @param id L'ID de l'utilisateur
     * @return true si la suppression est réussie
     */
    public boolean deleteUser(Long id) {
        try {
            if (id == null || id <= 0) {
                return false;
            }
            dao.deleteUser(id);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la suppression de l'utilisateur: " + e.getMessage());
            return false;
        }
    }

    /**
     * Change le rôle d'un utilisateur (admin seulement)
     * 
     * @param userId  L'ID de l'utilisateur
     * @param newRole Le nouveau rôle
     * @return true si le changement est réussi
     */
    public boolean changeUserRole(Long userId, Role newRole) {
        try {
            User user = getUserById(userId);
            if (user == null) {
                return false;
            }
            user.setRole(newRole);
            return updateUser(user);
        } catch (Exception e) {
            System.err.println("Erreur lors du changement de rôle: " + e.getMessage());
            return false;
        }
    }
}

package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

/**
 * Utilitaire pour le hachage des mots de passe
 */
public class PasswordUtil {

    /**
     * Hache un mot de passe en utilisant SHA-256
     * 
     * @param password Le mot de passe à hacher
     * @return Le mot de passe haché en Base64
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur lors du hachage du mot de passe", e);
        }
    }

    /**
     * Vérifie si un mot de passe correspond à un hash
     * 
     * @param password Le mot de passe en clair
     * @param hash     Le hash à comparer
     * @return true si le mot de passe correspond, false sinon
     */
    public static boolean verifyPassword(String password, String hash) {
        String passwordHash = hashPassword(password);
        return passwordHash.equals(hash);
    }

    /**
     * Valide la force du mot de passe
     * 
     * @param password Le mot de passe à valider
     * @return true si le mot de passe est assez fort
     */
    public static boolean isStrongPassword(String password) {
        // Au minimum 8 caractères, 1 majuscule, 1 minuscule, 1 chiffre
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasUpperCase = password.matches(".*[A-Z].*");
        boolean hasLowerCase = password.matches(".*[a-z].*");
        boolean hasDigit = password.matches(".*\\d.*");

        return hasUpperCase && hasLowerCase && hasDigit;
    }
}

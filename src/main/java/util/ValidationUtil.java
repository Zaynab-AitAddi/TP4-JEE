package util;

import java.util.regex.Pattern;

/**
 * Utilitaire pour les validations
 */
public class ValidationUtil {

    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@(.+)$";

    private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);

    /**
     * Valide une adresse email
     * 
     * @param email L'email à valider
     * @return true si l'email est valide
     */
    public static boolean isValidEmail(String email) {
        return email != null && pattern.matcher(email).matches();
    }

    /**
     * Valide un nom (au minimum 2 caractères)
     * 
     * @param name Le nom à valider
     * @return true si le nom est valide
     */
    public static boolean isValidName(String name) {
        return name != null && name.trim().length() >= 2;
    }

    /**
     * Vérifie si une string est vide ou null
     * 
     * @param str La string à vérifier
     * @return true si vide ou null
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Valide un prix (positif)
     * 
     * @param price Le prix à valider
     * @return true si le prix est valide
     */
    public static boolean isValidPrice(String price) {
        try {
            double p = Double.parseDouble(price);
            return p > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}

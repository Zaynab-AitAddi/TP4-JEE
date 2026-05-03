package dao.model;

/**
 * Énumération des rôles utilisateur
 */
public enum Role {
    ADMIN("Administrateur"),
    USER("Utilisateur"),
    MANAGER("Gestionnaire");

    private String label;

    Role(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}

package dao.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Entité Utilisateur
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long idUser;
    private String email;
    private String password;
    private String nom;
    private String prenom;
    private Role role;
    private boolean actif;
    private Date dateCreation;
    private Date dateModification;

    // Constructeurs
    public User() {
        this.dateCreation = new Date();
        this.dateModification = new Date();
        this.actif = true;
        this.role = Role.USER;
    }

    public User(String email, String password, String nom, String prenom) {
        this();
        this.email = email;
        this.password = password;
        this.nom = nom;
        this.prenom = prenom;
    }

    public User(Long idUser, String email, String password, String nom, String prenom, Role role, boolean actif) {
        this();
        this.idUser = idUser;
        this.email = email;
        this.password = password;
        this.nom = nom;
        this.prenom = prenom;
        this.role = role;
        this.actif = actif;
    }

    // Getters et Setters
    public Long getIdUser() {
        return idUser;
    }

    public void setIdUser(Long idUser) {
        this.idUser = idUser;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }

    public Date getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }

    public Date getDateModification() {
        return dateModification;
    }

    public void setDateModification(Date dateModification) {
        this.dateModification = dateModification;
    }

    public String getFullName() {
        return prenom + " " + nom;
    }

    @Override
    public String toString() {
        return "User{" +
                "idUser=" + idUser +
                ", email='" + email + '\'' +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", role=" + role +
                ", actif=" + actif +
                '}';
    }
}

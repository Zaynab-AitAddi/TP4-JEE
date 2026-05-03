package metier;

import dao.impl.ProduitDAOImpl;
import dao.interfaces.IProduitDAO;
import dao.model.Produit;
import java.util.List;

/**
 * Service métier pour les Produits
 */
public class ProduitMetier {
    private static ProduitMetier instance;
    private IProduitDAO dao;

    private ProduitMetier() {
        this.dao = new ProduitDAOImpl();
    }

    /**
     * Récupère l'instance singleton du service
     * 
     * @return Instance unique de ProduitMetier
     */
    public static ProduitMetier getInstance() {
        if (instance == null) {
            synchronized (ProduitMetier.class) {
                if (instance == null) {
                    instance = new ProduitMetier();
                }
            }
        }
        return instance;
    }

    /**
     * Ajoute un nouveau produit
     * 
     * @param produit Le produit à ajouter
     * @return true si l'ajout est réussi
     */
    public boolean addProduit(Produit produit) {
        try {
            if (produit == null || produit.getNom() == null || produit.getPrix() == null) {
                return false;
            }
            dao.addProduit(produit);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de l'ajout du produit: " + e.getMessage());
            return false;
        }
    }

    /**
     * Supprime un produit par son ID
     * 
     * @param id L'ID du produit
     * @return true si la suppression est réussie
     */
    public boolean deleteProduit(Long id) {
        try {
            if (id == null || id <= 0) {
                return false;
            }
            dao.deleteProduit(id);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la suppression du produit: " + e.getMessage());
            return false;
        }
    }

    /**
     * Récupère un produit par son ID
     * 
     * @param id L'ID du produit
     * @return Le produit ou null
     */
    public Produit getProduitById(Long id) {
        try {
            if (id == null || id <= 0) {
                return null;
            }
            return dao.getProduitById(id);
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération du produit: " + e.getMessage());
            return null;
        }
    }

    /**
     * Récupère tous les produits
     * 
     * @return Liste de tous les produits
     */
    public List<Produit> getAllProduits() {
        try {
            return dao.getAllProduits();
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des produits: " + e.getMessage());
            return List.of();
        }
    }

    /**
     * Met à jour un produit
     * 
     * @param produit Le produit à mettre à jour
     * @return true si la mise à jour est réussie
     */
    public boolean updateProduit(Produit produit) {
        try {
            if (produit == null || produit.getIdProduit() == null) {
                return false;
            }
            dao.updateProduit(produit);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la mise à jour du produit: " + e.getMessage());
            return false;
        }
    }

    /**
     * Recherche des produits par mot-clé
     * 
     * @param keyword Le mot-clé de recherche
     * @return Liste des produits correspondants
     */
    public List<Produit> searchProduits(String keyword) {
        try {
            return dao.searchProduits(keyword);
        } catch (Exception e) {
            System.err.println("Erreur lors de la recherche: " + e.getMessage());
            return List.of();
        }
    }
}

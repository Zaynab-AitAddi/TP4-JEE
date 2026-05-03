package dao.impl;

import dao.interfaces.IProduitDAO;
import dao.model.Produit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Implémentation DAO pour Produit
 */
public class ProduitDAOImpl implements IProduitDAO {
    private List<Produit> produits = new ArrayList<>();
    private static long nextId = 1;

    public ProduitDAOImpl() {
        initData();
    }

    private void initData() {
        addProduit(new Produit("Laptop Dell XPS", "Ordinateur portable high-performance", 1299.99, "Électronique"));
        addProduit(new Produit("iPhone 15", "Smartphone dernier modèle", 999.99, "Électronique"));
        addProduit(new Produit("Clavier Mécanique", "Clavier gaming RGB", 149.99, "Accessoires"));
        addProduit(new Produit("Souris Logitech", "Souris sans fil haute précision", 49.99, "Accessoires"));
        addProduit(new Produit("Monitor LG UltraWide", "Écran 34 pouces ultrawide", 549.99, "Électronique"));
    }

    @Override
    public void addProduit(Produit p) {
        if (p.getIdProduit() == null) {
            p.setIdProduit(nextId++);
        } else {
            if (p.getIdProduit() >= nextId) {
                nextId = p.getIdProduit() + 1;
            }
        }
        produits.add(p);
    }

    @Override
    public void deleteProduit(Long id) {
        produits.removeIf(p -> p.getIdProduit().equals(id));
    }

    @Override
    public Produit getProduitById(Long id) {
        return produits.stream()
                .filter(p -> p.getIdProduit().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Produit> getAllProduits() {
        return new ArrayList<>(produits);
    }

    @Override
    public void updateProduit(Produit p) {
        Produit existing = getProduitById(p.getIdProduit());
        if (existing != null) {
            existing.setNom(p.getNom());
            existing.setDescription(p.getDescription());
            existing.setPrix(p.getPrix());
            existing.setCategorie(p.getCategorie());
        }
    }

    @Override
    public List<Produit> searchProduits(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllProduits();
        }
        String searchTerm = keyword.toLowerCase();
        return produits.stream()
                .filter(p -> p.getNom().toLowerCase().contains(searchTerm) ||
                        p.getDescription().toLowerCase().contains(searchTerm) ||
                        p.getCategorie().toLowerCase().contains(searchTerm))
                .collect(Collectors.toList());
    }
}

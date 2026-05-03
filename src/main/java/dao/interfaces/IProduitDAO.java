package dao.interfaces;

import dao.model.Produit;
import java.util.List;

/**
 * Interface DAO pour Produit
 */
public interface IProduitDAO {
    void addProduit(Produit p);

    void deleteProduit(Long id);

    Produit getProduitById(Long id);

    List<Produit> getAllProduits();

    void updateProduit(Produit p);

    List<Produit> searchProduits(String keyword);
}

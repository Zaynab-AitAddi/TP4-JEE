package dao.impl;

import dao.interfaces.IUserDAO;
import dao.model.User;
import dao.model.Role;
import util.PasswordUtil;
import java.util.ArrayList;
import java.util.List;

/**
 * Implémentation DAO pour User (Authentification)
 */
public class UserDAOImpl implements IUserDAO {
    private List<User> users = new ArrayList<>();
    private static long nextId = 1;

    public UserDAOImpl() {
        initData();
    }

    private void initData() {
        // Créer des utilisateurs de test
        User admin = new User(nextId++, "admin@example.com",
                PasswordUtil.hashPassword("admin123"),
                "Admin", "Principal", Role.ADMIN, true);
        users.add(admin);

        User user1 = new User(nextId++, "john@example.com",
                PasswordUtil.hashPassword("password123"),
                "Doe", "John", Role.USER, true);
        users.add(user1);

        User manager = new User(nextId++, "manager@example.com",
                PasswordUtil.hashPassword("manager123"),
                "Martin", "Sophie", Role.MANAGER, true);
        users.add(manager);
    }

    @Override
    public void addUser(User user) {
        if (user.getIdUser() == null) {
            user.setIdUser(nextId++);
        } else {
            if (user.getIdUser() >= nextId) {
                nextId = user.getIdUser() + 1;
            }
        }
        users.add(user);
    }

    @Override
    public void deleteUser(Long id) {
        users.removeIf(u -> u.getIdUser().equals(id));
    }

    @Override
    public User getUserById(Long id) {
        return users.stream()
                .filter(u -> u.getIdUser().equals(id))
                .findFirst()
                .orElse(null);
    }

    @Override
    public User getUserByEmail(String email) {
        return users.stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }

    @Override
    public void updateUser(User user) {
        User existing = getUserById(user.getIdUser());
        if (existing != null) {
            existing.setEmail(user.getEmail());
            existing.setNom(user.getNom());
            existing.setPrenom(user.getPrenom());
            existing.setRole(user.getRole());
            existing.setActif(user.isActif());
            existing.setDateModification(new java.util.Date());
        }
    }

    @Override
    public boolean userExists(String email) {
        return getUserByEmail(email) != null;
    }
}

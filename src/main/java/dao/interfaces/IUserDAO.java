package dao.interfaces;

import dao.model.User;
import java.util.List;

/**
 * Interface DAO pour User (Authentification)
 */
public interface IUserDAO {
    void addUser(User user);

    void deleteUser(Long id);

    User getUserById(Long id);

    User getUserByEmail(String email);

    List<User> getAllUsers();

    void updateUser(User user);

    boolean userExists(String email);
}

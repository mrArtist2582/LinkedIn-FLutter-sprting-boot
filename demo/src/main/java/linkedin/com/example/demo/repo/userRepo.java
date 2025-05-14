package linkedin.com.example.demo.repo;



import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

import linkedin.com.example.demo.models.userModel;

@Repository
public interface userRepo extends JpaRepository<userModel,Long> {
    Optional<userModel> findByEmail(String email);

    Optional<userModel> findByUsername(String username);
}
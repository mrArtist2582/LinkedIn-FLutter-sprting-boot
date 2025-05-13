package Linkedin.com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<Linkedin.com.example.demo.entity.User, Long> {
    Optional<Linkedin.com.example.demo.entity.User> findByEmail(String email);
    boolean existsByEmail(String email);
}

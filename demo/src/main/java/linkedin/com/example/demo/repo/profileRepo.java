package linkedin.com.example.demo.repo;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import linkedin.com.example.demo.models.profileModel;
import linkedin.com.example.demo.models.userModel;

import java.util.Optional;

@Repository
public interface profileRepo extends JpaRepository<profileModel,Long> {

    Optional<profileModel> findByUser(userModel userModel);
}
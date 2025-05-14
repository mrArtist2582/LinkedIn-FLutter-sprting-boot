package linkedin.com.example.demo.repo;



import org.springframework.data.jpa.repository.JpaRepository;

import linkedin.com.example.demo.models.postModel;

public interface postRepo extends JpaRepository<postModel,Long> {
}
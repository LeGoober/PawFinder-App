package com.pawfinder.auth.repository;

import com.pawfinder.shared.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByAuthId(String authId);

    Optional<User> findByPhoneHash(String phoneHash);

    boolean existsByAuthId(String authId);
}

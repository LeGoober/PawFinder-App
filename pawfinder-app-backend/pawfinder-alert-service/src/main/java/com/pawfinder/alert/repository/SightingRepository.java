package com.pawfinder.alert.repository;

import com.pawfinder.alert.entity.Sighting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface SightingRepository extends JpaRepository<Sighting, UUID> {

    List<Sighting> findByAlertId(UUID alertId);

    List<Sighting> findByFinderId(UUID finderId);
}

package com.pawfinder.alert.controller;

import com.pawfinder.alert.dto.CreatePetRequest;
import com.pawfinder.alert.dto.PetDTO;
import com.pawfinder.alert.entity.Pet;
import com.pawfinder.alert.repository.PetRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/pets")
@RequiredArgsConstructor
@Tag(name = "Pets", description = "Pet profile management endpoints")
public class PetController {

    private final PetRepository petRepository;

    @GetMapping
    @Operation(summary = "List user's pets")
    @ApiResponse(responseCode = "200", description = "Pets retrieved")
    public ResponseEntity<List<PetDTO>> listPets(Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        List<Pet> pets = petRepository.findByOwnerId(ownerId);
        List<PetDTO> dtos = pets.stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @PostMapping
    @Operation(summary = "Create a pet profile")
    @ApiResponse(responseCode = "201", description = "Pet created")
    public ResponseEntity<PetDTO> createPet(
            @Valid @RequestBody CreatePetRequest request,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());

        Pet pet = Pet.builder()
                .ownerId(ownerId)
                .name(request.getName())
                .species(request.getSpecies())
                .breed(request.getBreed())
                .color(request.getColor())
                .size(request.getSize())
                .distinguishingFeatures(request.getDistinguishingFeatures())
                .temperamentNotes(request.getTemperamentNotes())
                .medicalNeeds(request.getMedicalNeeds())
                .photos(request.getPhotos())
                .qrCodeId(request.getQrCodeId())
                .createdAt(LocalDateTime.now())
                .build();

        pet = petRepository.save(pet);
        return ResponseEntity.status(HttpStatus.CREATED).body(toDTO(pet));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get pet details")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Pet found"),
        @ApiResponse(responseCode = "404", description = "Pet not found")
    })
    public ResponseEntity<PetDTO> getPet(@PathVariable UUID id) {
        Pet pet = petRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Pet not found with id: " + id));
        return ResponseEntity.ok(toDTO(pet));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update pet profile")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Pet updated"),
        @ApiResponse(responseCode = "403", description = "Not the pet owner"),
        @ApiResponse(responseCode = "404", description = "Pet not found")
    })
    public ResponseEntity<PetDTO> updatePet(
            @PathVariable UUID id,
            @Valid @RequestBody CreatePetRequest request,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        Pet pet = petRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Pet not found with id: " + id));

        if (!pet.getOwnerId().equals(ownerId)) {
            throw new SecurityException("You do not own this pet profile");
        }

        pet.setName(request.getName());
        pet.setSpecies(request.getSpecies());
        pet.setBreed(request.getBreed());
        pet.setColor(request.getColor());
        pet.setSize(request.getSize());
        pet.setDistinguishingFeatures(request.getDistinguishingFeatures());
        pet.setTemperamentNotes(request.getTemperamentNotes());
        pet.setMedicalNeeds(request.getMedicalNeeds());
        pet.setPhotos(request.getPhotos());
        pet.setQrCodeId(request.getQrCodeId());

        pet = petRepository.save(pet);
        return ResponseEntity.ok(toDTO(pet));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete pet profile")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Pet deleted"),
        @ApiResponse(responseCode = "403", description = "Not the pet owner"),
        @ApiResponse(responseCode = "404", description = "Pet not found")
    })
    public ResponseEntity<Void> deletePet(
            @PathVariable UUID id,
            Authentication authentication) {
        UUID ownerId = UUID.fromString(authentication.getName());
        Pet pet = petRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Pet not found with id: " + id));

        if (!pet.getOwnerId().equals(ownerId)) {
            throw new SecurityException("You do not own this pet profile");
        }

        petRepository.delete(pet);
        return ResponseEntity.noContent().build();
    }

    private PetDTO toDTO(Pet pet) {
        return PetDTO.builder()
                .id(pet.getId())
                .ownerId(pet.getOwnerId())
                .name(pet.getName())
                .species(pet.getSpecies())
                .breed(pet.getBreed())
                .color(pet.getColor())
                .size(pet.getSize())
                .distinguishingFeatures(pet.getDistinguishingFeatures())
                .temperamentNotes(pet.getTemperamentNotes())
                .medicalNeeds(pet.getMedicalNeeds())
                .photos(pet.getPhotos())
                .qrCodeId(pet.getQrCodeId())
                .createdAt(pet.getCreatedAt())
                .build();
    }
}

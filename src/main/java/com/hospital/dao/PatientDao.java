package com.hospital.dao;

import com.hospital.model.Patient;
import java.util.List;
import java.util.Optional;

public interface PatientDao {
    Long save(Patient patient);
    int update(Patient patient);
    int deleteById(Long id);
    Optional<Patient> findById(Long id);
    Optional<Patient> findByUhid(String uhid);
    List<Patient> findAll();
    List<Patient> search(String keyword);
    int count();
    String generateNextUhid();
}

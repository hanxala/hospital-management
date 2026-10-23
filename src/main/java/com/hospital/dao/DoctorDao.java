package com.hospital.dao;

import com.hospital.model.Doctor;
import java.util.List;
import java.util.Optional;

public interface DoctorDao {
    Long save(Doctor doctor);
    Optional<Doctor> findById(Long id);
    List<Doctor> findAll();
    int count();
}

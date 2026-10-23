package com.hospital.dao;

import com.hospital.model.Consultation;
import java.util.List;
import java.util.Optional;

public interface ConsultationDao {
    Long save(Consultation consultation);
    int update(Consultation consultation);
    int updateStatus(Long id, String status);
    Optional<Consultation> findById(Long id);
    List<Consultation> findAll();
    List<Consultation> findByPatientId(Long patientId);
    List<Consultation> findUnbilledByPatientId(Long patientId);
    int count();
}

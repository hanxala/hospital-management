package com.hospital.service;

import com.hospital.model.Patient;
import java.util.List;

public interface PatientService {
    Long registerPatient(Patient patient);
    boolean updatePatient(Patient patient);
    boolean deletePatient(Long id);
    Patient getPatientById(Long id);
    Patient getPatientByUhid(String uhid);
    List<Patient> getAllPatients();
    List<Patient> searchPatients(String keyword);
    String getNextUhid();
}

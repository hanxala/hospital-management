package com.hospital.service;

import com.hospital.model.Consultation;
import com.hospital.model.Doctor;
import java.util.List;

public interface ConsultationService {
    Long recordConsultation(Consultation consultation);
    boolean updateConsultation(Consultation consultation);
    Consultation getConsultationById(Long id);
    List<Consultation> getAllConsultations();
    List<Consultation> getConsultationsByPatientId(Long patientId);
    List<Consultation> getUnbilledConsultationsByPatientId(Long patientId);
    List<Doctor> getAllDoctors();
    Doctor getDoctorById(Long doctorId);
}

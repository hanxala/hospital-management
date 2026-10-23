package com.hospital.service;

import com.hospital.dao.ConsultationDao;
import com.hospital.dao.DoctorDao;
import com.hospital.model.Consultation;
import com.hospital.model.Doctor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ConsultationServiceImpl implements ConsultationService {

    private final ConsultationDao consultationDao;
    private final DoctorDao doctorDao;

    @Autowired
    public ConsultationServiceImpl(ConsultationDao consultationDao, DoctorDao doctorDao) {
        this.consultationDao = consultationDao;
        this.doctorDao = doctorDao;
    }

    @Override
    @Transactional
    public Long recordConsultation(Consultation consultation) {
        if (consultation.getConsultationFee() == null && consultation.getDoctorId() != null) {
            doctorDao.findById(consultation.getDoctorId()).ifPresent(doctor ->
                consultation.setConsultationFee(doctor.getConsultationFee())
            );
        }
        return consultationDao.save(consultation);
    }

    @Override
    @Transactional
    public boolean updateConsultation(Consultation consultation) {
        return consultationDao.update(consultation) > 0;
    }

    @Override
    public Consultation getConsultationById(Long id) {
        return consultationDao.findById(id).orElse(null);
    }

    @Override
    public List<Consultation> getAllConsultations() {
        return consultationDao.findAll();
    }

    @Override
    public List<Consultation> getConsultationsByPatientId(Long patientId) {
        return consultationDao.findByPatientId(patientId);
    }

    @Override
    public List<Consultation> getUnbilledConsultationsByPatientId(Long patientId) {
        return consultationDao.findUnbilledByPatientId(patientId);
    }

    @Override
    public List<Doctor> getAllDoctors() {
        return doctorDao.findAll();
    }

    @Override
    public Doctor getDoctorById(Long doctorId) {
        return doctorDao.findById(doctorId).orElse(null);
    }
}

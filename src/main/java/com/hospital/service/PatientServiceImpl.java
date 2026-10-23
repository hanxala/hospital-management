package com.hospital.service;

import com.hospital.dao.PatientDao;
import com.hospital.model.Patient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PatientServiceImpl implements PatientService {

    private final PatientDao patientDao;

    @Autowired
    public PatientServiceImpl(PatientDao patientDao) {
        this.patientDao = patientDao;
    }

    @Override
    @Transactional
    public Long registerPatient(Patient patient) {
        if (patient.getPatientUhid() == null || patient.getPatientUhid().trim().isEmpty()) {
            patient.setPatientUhid(patientDao.generateNextUhid());
        }
        return patientDao.save(patient);
    }

    @Override
    @Transactional
    public boolean updatePatient(Patient patient) {
        return patientDao.update(patient) > 0;
    }

    @Override
    @Transactional
    public boolean deletePatient(Long id) {
        return patientDao.deleteById(id) > 0;
    }

    @Override
    public Patient getPatientById(Long id) {
        return patientDao.findById(id).orElse(null);
    }

    @Override
    public Patient getPatientByUhid(String uhid) {
        return patientDao.findByUhid(uhid).orElse(null);
    }

    @Override
    public List<Patient> getAllPatients() {
        return patientDao.findAll();
    }

    @Override
    public List<Patient> searchPatients(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return patientDao.findAll();
        }
        return patientDao.search(keyword.trim());
    }

    @Override
    public String getNextUhid() {
        return patientDao.generateNextUhid();
    }
}

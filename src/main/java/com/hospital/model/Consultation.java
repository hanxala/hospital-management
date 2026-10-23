package com.hospital.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Consultation {
    private Long id;
    private Long patientId;
    private Long doctorId;
    private Timestamp consultationDate;
    private String symptoms;
    private String diagnosis;
    private String prescription;
    private BigDecimal consultationFee;
    private String status;
    private String notes;

    // Joined fields for display
    private String patientName;
    private String patientUhid;
    private String doctorName;
    private String doctorSpecialization;

    public Consultation() {
    }

    public Consultation(Long id, Long patientId, Long doctorId, Timestamp consultationDate, String symptoms,
                        String diagnosis, String prescription, BigDecimal consultationFee, String status,
                        String notes) {
        this.id = id;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.consultationDate = consultationDate;
        this.symptoms = symptoms;
        this.diagnosis = diagnosis;
        this.prescription = prescription;
        this.consultationFee = consultationFee;
        this.status = status;
        this.notes = notes;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public Long getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(Long doctorId) {
        this.doctorId = doctorId;
    }

    public Timestamp getConsultationDate() {
        return consultationDate;
    }

    public void setConsultationDate(Timestamp consultationDate) {
        this.consultationDate = consultationDate;
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getPrescription() {
        return prescription;
    }

    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }

    public BigDecimal getConsultationFee() {
        return consultationFee;
    }

    public void setConsultationFee(BigDecimal consultationFee) {
        this.consultationFee = consultationFee;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientUhid() {
        return patientUhid;
    }

    public void setPatientUhid(String patientUhid) {
        this.patientUhid = patientUhid;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getDoctorSpecialization() {
        return doctorSpecialization;
    }

    public void setDoctorSpecialization(String doctorSpecialization) {
        this.doctorSpecialization = doctorSpecialization;
    }
}

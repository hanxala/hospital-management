package com.hospital.model;

import java.math.BigDecimal;

public class Doctor {
    private Long id;
    private String name;
    private String specialization;
    private String department;
    private BigDecimal consultationFee;
    private String phone;
    private String email;
    private String availableDays;

    public Doctor() {
    }

    public Doctor(Long id, String name, String specialization, String department, BigDecimal consultationFee,
                  String phone, String email, String availableDays) {
        this.id = id;
        this.name = name;
        this.specialization = specialization;
        this.department = department;
        this.consultationFee = consultationFee;
        this.phone = phone;
        this.email = email;
        this.availableDays = availableDays;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public BigDecimal getConsultationFee() {
        return consultationFee;
    }

    public void setConsultationFee(BigDecimal consultationFee) {
        this.consultationFee = consultationFee;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvailableDays() {
        return availableDays;
    }

    public void setAvailableDays(String availableDays) {
        this.availableDays = availableDays;
    }
}

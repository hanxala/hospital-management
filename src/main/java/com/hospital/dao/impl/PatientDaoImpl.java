package com.hospital.dao.impl;

import com.hospital.dao.PatientDao;
import com.hospital.model.Patient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@Repository
public class PatientDaoImpl implements PatientDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public PatientDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Patient> rowMapper = (rs, rowNum) -> new Patient(
            rs.getLong("id"),
            rs.getString("patient_uhid"),
            rs.getString("first_name"),
            rs.getString("last_name"),
            rs.getInt("age"),
            rs.getString("gender"),
            rs.getString("phone"),
            rs.getString("email"),
            rs.getString("blood_group"),
            rs.getString("address"),
            rs.getString("emergency_contact"),
            rs.getTimestamp("registration_date"),
            rs.getString("status"),
            rs.getString("medical_history")
    );

    @Override
    public Long save(Patient patient) {
        String sql = "INSERT INTO patients (patient_uhid, first_name, last_name, age, gender, phone, email, " +
                "blood_group, address, emergency_contact, registration_date, status, medical_history) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        KeyHolder keyHolder = new GeneratedKeyHolder();
        Timestamp now = patient.getRegistrationDate() != null ? patient.getRegistrationDate() : new Timestamp(System.currentTimeMillis());

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setString(1, patient.getPatientUhid());
            ps.setString(2, patient.getFirstName());
            ps.setString(3, patient.getLastName());
            ps.setInt(4, patient.getAge() != null ? patient.getAge() : 0);
            ps.setString(5, patient.getGender());
            ps.setString(6, patient.getPhone());
            ps.setString(7, patient.getEmail());
            ps.setString(8, patient.getBloodGroup());
            ps.setString(9, patient.getAddress());
            ps.setString(10, patient.getEmergencyContact());
            ps.setTimestamp(11, now);
            ps.setString(12, patient.getStatus() != null ? patient.getStatus() : "ACTIVE");
            ps.setString(13, patient.getMedicalHistory());
            return ps;
        }, keyHolder);

        if (keyHolder.getKeys() != null) {
            for (java.util.Map.Entry<String, Object> entry : keyHolder.getKeys().entrySet()) {
                if ("id".equalsIgnoreCase(entry.getKey()) && entry.getValue() instanceof Number num) {
                    return num.longValue();
                }
            }
        }
        Number key = keyHolder.getKey();
        return key != null ? key.longValue() : null;
    }

    @Override
    public int update(Patient patient) {
        String sql = "UPDATE patients SET first_name=?, last_name=?, age=?, gender=?, phone=?, email=?, " +
                "blood_group=?, address=?, emergency_contact=?, status=?, medical_history=? WHERE id=?";
        return jdbcTemplate.update(sql,
                patient.getFirstName(),
                patient.getLastName(),
                patient.getAge(),
                patient.getGender(),
                patient.getPhone(),
                patient.getEmail(),
                patient.getBloodGroup(),
                patient.getAddress(),
                patient.getEmergencyContact(),
                patient.getStatus(),
                patient.getMedicalHistory(),
                patient.getId());
    }

    @Override
    public int deleteById(Long id) {
        String sql = "DELETE FROM patients WHERE id = ?";
        return jdbcTemplate.update(sql, id);
    }

    @Override
    public Optional<Patient> findById(Long id) {
        String sql = "SELECT * FROM patients WHERE id = ?";
        try {
            Patient patient = jdbcTemplate.queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(patient);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<Patient> findByUhid(String uhid) {
        String sql = "SELECT * FROM patients WHERE UPPER(patient_uhid) = UPPER(?)";
        try {
            Patient patient = jdbcTemplate.queryForObject(sql, rowMapper, uhid);
            return Optional.ofNullable(patient);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Patient> findAll() {
        String sql = "SELECT * FROM patients ORDER BY id DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Patient> search(String keyword) {
        String sql = "SELECT * FROM patients WHERE UPPER(patient_uhid) LIKE UPPER(?) OR UPPER(first_name) LIKE UPPER(?) " +
                "OR UPPER(last_name) LIKE UPPER(?) OR phone LIKE ? ORDER BY id DESC";
        String pattern = "%" + keyword + "%";
        return jdbcTemplate.query(sql, rowMapper, pattern, pattern, pattern, pattern);
    }

    @Override
    public int count() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM patients", Integer.class);
        return count != null ? count : 0;
    }

    @Override
    public String generateNextUhid() {
        Integer maxId = jdbcTemplate.queryForObject("SELECT COALESCE(MAX(id), 0) FROM patients", Integer.class);
        int next = (maxId != null ? maxId : 0) + 1001;
        return "UHID-" + next;
    }
}

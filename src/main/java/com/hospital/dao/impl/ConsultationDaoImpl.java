package com.hospital.dao.impl;

import com.hospital.dao.ConsultationDao;
import com.hospital.model.Consultation;
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
public class ConsultationDaoImpl implements ConsultationDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public ConsultationDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Consultation> rowMapper = (rs, rowNum) -> {
        Consultation c = new Consultation(
                rs.getLong("id"),
                rs.getLong("patient_id"),
                rs.getLong("doctor_id"),
                rs.getTimestamp("consultation_date"),
                rs.getString("symptoms"),
                rs.getString("diagnosis"),
                rs.getString("prescription"),
                rs.getBigDecimal("consultation_fee"),
                rs.getString("status"),
                rs.getString("notes")
        );
        c.setPatientName(rs.getString("patient_name"));
        c.setPatientUhid(rs.getString("patient_uhid"));
        c.setDoctorName(rs.getString("doctor_name"));
        c.setDoctorSpecialization(rs.getString("doctor_specialization"));
        return c;
    };

    private static final String BASE_SELECT =
            "SELECT c.*, " +
            "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.patient_uhid, " +
            "d.name AS doctor_name, d.specialization AS doctor_specialization " +
            "FROM consultations c " +
            "JOIN patients p ON c.patient_id = p.id " +
            "JOIN doctors d ON c.doctor_id = d.id ";

    @Override
    public Long save(Consultation consultation) {
        String sql = "INSERT INTO consultations (patient_id, doctor_id, consultation_date, symptoms, diagnosis, " +
                "prescription, consultation_fee, status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        Timestamp date = consultation.getConsultationDate() != null ? consultation.getConsultationDate() : new Timestamp(System.currentTimeMillis());

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setLong(1, consultation.getPatientId());
            ps.setLong(2, consultation.getDoctorId());
            ps.setTimestamp(3, date);
            ps.setString(4, consultation.getSymptoms());
            ps.setString(5, consultation.getDiagnosis());
            ps.setString(6, consultation.getPrescription());
            ps.setBigDecimal(7, consultation.getConsultationFee());
            ps.setString(8, consultation.getStatus() != null ? consultation.getStatus() : "COMPLETED");
            ps.setString(9, consultation.getNotes());
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
    public int update(Consultation consultation) {
        String sql = "UPDATE consultations SET doctor_id=?, symptoms=?, diagnosis=?, prescription=?, " +
                "consultation_fee=?, status=?, notes=? WHERE id=?";
        return jdbcTemplate.update(sql,
                consultation.getDoctorId(),
                consultation.getSymptoms(),
                consultation.getDiagnosis(),
                consultation.getPrescription(),
                consultation.getConsultationFee(),
                consultation.getStatus(),
                consultation.getNotes(),
                consultation.getId());
    }

    @Override
    public int updateStatus(Long id, String status) {
        String sql = "UPDATE consultations SET status = ? WHERE id = ?";
        return jdbcTemplate.update(sql, status, id);
    }

    @Override
    public Optional<Consultation> findById(Long id) {
        String sql = BASE_SELECT + "WHERE c.id = ?";
        try {
            Consultation c = jdbcTemplate.queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(c);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Consultation> findAll() {
        String sql = BASE_SELECT + "ORDER BY c.consultation_date DESC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public List<Consultation> findByPatientId(Long patientId) {
        String sql = BASE_SELECT + "WHERE c.patient_id = ? ORDER BY c.consultation_date DESC";
        return jdbcTemplate.query(sql, rowMapper, patientId);
    }

    @Override
    public List<Consultation> findUnbilledByPatientId(Long patientId) {
        String sql = BASE_SELECT + "WHERE c.patient_id = ? AND c.status = 'COMPLETED' ORDER BY c.consultation_date DESC";
        return jdbcTemplate.query(sql, rowMapper, patientId);
    }

    @Override
    public int count() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM consultations", Integer.class);
        return count != null ? count : 0;
    }
}

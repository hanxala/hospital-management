package com.hospital.dao.impl;

import com.hospital.dao.DoctorDao;
import com.hospital.model.Doctor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

@Repository
public class DoctorDaoImpl implements DoctorDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public DoctorDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Doctor> rowMapper = (rs, rowNum) -> new Doctor(
            rs.getLong("id"),
            rs.getString("name"),
            rs.getString("specialization"),
            rs.getString("department"),
            rs.getBigDecimal("consultation_fee"),
            rs.getString("phone"),
            rs.getString("email"),
            rs.getString("available_days")
    );

    @Override
    public Long save(Doctor doctor) {
        String sql = "INSERT INTO doctors (name, specialization, department, consultation_fee, phone, email, available_days) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setString(1, doctor.getName());
            ps.setString(2, doctor.getSpecialization());
            ps.setString(3, doctor.getDepartment());
            ps.setBigDecimal(4, doctor.getConsultationFee());
            ps.setString(5, doctor.getPhone());
            ps.setString(6, doctor.getEmail());
            ps.setString(7, doctor.getAvailableDays());
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
    public Optional<Doctor> findById(Long id) {
        String sql = "SELECT * FROM doctors WHERE id = ?";
        try {
            Doctor doc = jdbcTemplate.queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(doc);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Doctor> findAll() {
        String sql = "SELECT * FROM doctors ORDER BY name ASC";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public int count() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM doctors", Integer.class);
        return count != null ? count : 0;
    }
}

package com.hospital.dao.impl;

import com.hospital.dao.AuditLogDao;
import com.hospital.model.AuditLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;

@Repository
public class AuditLogDaoImpl implements AuditLogDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public AuditLogDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<AuditLog> rowMapper = (rs, rowNum) -> new AuditLog(
            rs.getLong("id"),
            rs.getString("action"),
            rs.getString("entity_name"),
            rs.getString("entity_id"),
            rs.getString("details"),
            rs.getString("performed_by"),
            rs.getTimestamp("timestamp")
    );

    @Override
    public Long save(AuditLog log) {
        String sql = "INSERT INTO audit_logs (action, entity_name, entity_id, details, performed_by, timestamp) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        Timestamp now = log.getTimestamp() != null ? log.getTimestamp() : new Timestamp(System.currentTimeMillis());

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setString(1, log.getAction());
            ps.setString(2, log.getEntityName());
            ps.setString(3, log.getEntityId());
            ps.setString(4, log.getDetails());
            ps.setString(5, log.getPerformedBy() != null ? log.getPerformedBy() : "SYSTEM");
            ps.setTimestamp(6, now);
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
    public List<AuditLog> findRecent(int limit) {
        String sql = "SELECT * FROM audit_logs ORDER BY id DESC LIMIT ?";
        return jdbcTemplate.query(sql, rowMapper, limit);
    }

    @Override
    public int count() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM audit_logs", Integer.class);
        return count != null ? count : 0;
    }
}

package com.hospital.dao.impl;

import com.hospital.dao.PerformanceLogDao;
import com.hospital.model.PerformanceLog;
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
public class PerformanceLogDaoImpl implements PerformanceLogDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public PerformanceLogDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<PerformanceLog> rowMapper = (rs, rowNum) -> new PerformanceLog(
            rs.getLong("id"),
            rs.getString("class_name"),
            rs.getString("method_name"),
            rs.getLong("execution_time_ms"),
            rs.getBoolean("threshold_exceeded"),
            rs.getTimestamp("timestamp")
    );

    @Override
    public Long save(PerformanceLog log) {
        String sql = "INSERT INTO performance_logs (class_name, method_name, execution_time_ms, threshold_exceeded, timestamp) " +
                "VALUES (?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        Timestamp now = log.getTimestamp() != null ? log.getTimestamp() : new Timestamp(System.currentTimeMillis());

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setString(1, log.getClassName());
            ps.setString(2, log.getMethodName());
            ps.setLong(3, log.getExecutionTimeMs());
            ps.setBoolean(4, log.getThresholdExceeded() != null ? log.getThresholdExceeded() : false);
            ps.setTimestamp(5, now);
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
    public List<PerformanceLog> findRecent(int limit) {
        String sql = "SELECT * FROM performance_logs ORDER BY id DESC LIMIT ?";
        return jdbcTemplate.query(sql, rowMapper, limit);
    }

    @Override
    public int countAlerts() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM performance_logs WHERE threshold_exceeded = TRUE", Integer.class);
        return count != null ? count : 0;
    }
}

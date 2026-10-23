package com.hospital.dao.impl;

import com.hospital.dao.LabDao;
import com.hospital.model.LabOrder;
import com.hospital.model.LabTestCatalog;
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
public class LabDaoImpl implements LabDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public LabDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<LabTestCatalog> catalogRowMapper = (rs, rowNum) -> new LabTestCatalog(
            rs.getLong("id"),
            rs.getString("test_code"),
            rs.getString("test_name"),
            rs.getString("category"),
            rs.getBigDecimal("standard_fee"),
            rs.getString("description")
    );

    private final RowMapper<LabOrder> orderRowMapper = (rs, rowNum) -> {
        LabOrder order = new LabOrder(
                rs.getLong("id"),
                rs.getLong("patient_id"),
                rs.getLong("test_id"),
                rs.getObject("doctor_id") != null ? rs.getLong("doctor_id") : null,
                rs.getTimestamp("order_date"),
                rs.getBigDecimal("lab_fee"),
                rs.getString("status"),
                rs.getString("result_summary"),
                rs.getTimestamp("reported_date")
        );
        order.setPatientName(rs.getString("patient_name"));
        order.setPatientUhid(rs.getString("patient_uhid"));
        order.setTestName(rs.getString("test_name"));
        order.setTestCode(rs.getString("test_code"));
        order.setTestCategory(rs.getString("test_category"));
        order.setDoctorName(rs.getString("doctor_name"));
        return order;
    };

    private static final String ORDER_BASE_SELECT =
            "SELECT o.*, " +
            "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.patient_uhid, " +
            "c.test_name, c.test_code, c.category AS test_category, " +
            "COALESCE(d.name, 'N/A') AS doctor_name " +
            "FROM lab_orders o " +
            "JOIN patients p ON o.patient_id = p.id " +
            "JOIN lab_catalog c ON o.test_id = c.id " +
            "LEFT JOIN doctors d ON o.doctor_id = d.id ";

    @Override
    public List<LabTestCatalog> findAllCatalog() {
        return jdbcTemplate.query("SELECT * FROM lab_catalog ORDER BY category, test_name", catalogRowMapper);
    }

    @Override
    public Optional<LabTestCatalog> findCatalogById(Long id) {
        try {
            LabTestCatalog item = jdbcTemplate.queryForObject("SELECT * FROM lab_catalog WHERE id = ?", catalogRowMapper, id);
            return Optional.ofNullable(item);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public Long saveOrder(LabOrder order) {
        String sql = "INSERT INTO lab_orders (patient_id, test_id, doctor_id, order_date, lab_fee, status, result_summary) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        Timestamp now = order.getOrderDate() != null ? order.getOrderDate() : new Timestamp(System.currentTimeMillis());

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setLong(1, order.getPatientId());
            ps.setLong(2, order.getTestId());
            if (order.getDoctorId() != null) {
                ps.setLong(3, order.getDoctorId());
            } else {
                ps.setNull(3, java.sql.Types.BIGINT);
            }
            ps.setTimestamp(4, now);
            ps.setBigDecimal(5, order.getLabFee());
            ps.setString(6, order.getStatus() != null ? order.getStatus() : "PENDING");
            ps.setString(7, order.getResultSummary());
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
    public int updateOrderStatus(Long orderId, String status, String resultSummary) {
        String sql = "UPDATE lab_orders SET status = ?, result_summary = ?, reported_date = ? WHERE id = ?";
        Timestamp now = "COMPLETED".equalsIgnoreCase(status) ? new Timestamp(System.currentTimeMillis()) : null;
        return jdbcTemplate.update(sql, status, resultSummary, now, orderId);
    }

    @Override
    public Optional<LabOrder> findOrderById(Long id) {
        String sql = ORDER_BASE_SELECT + "WHERE o.id = ?";
        try {
            LabOrder order = jdbcTemplate.queryForObject(sql, orderRowMapper, id);
            return Optional.ofNullable(order);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public List<LabOrder> findAllOrders() {
        String sql = ORDER_BASE_SELECT + "ORDER BY o.order_date DESC";
        return jdbcTemplate.query(sql, orderRowMapper);
    }

    @Override
    public List<LabOrder> findOrdersByPatientId(Long patientId) {
        String sql = ORDER_BASE_SELECT + "WHERE o.patient_id = ? ORDER BY o.order_date DESC";
        return jdbcTemplate.query(sql, orderRowMapper, patientId);
    }

    @Override
    public List<LabOrder> findUnbilledOrdersByPatientId(Long patientId) {
        String sql = ORDER_BASE_SELECT + "WHERE o.patient_id = ? AND o.status <> 'BILLED' ORDER BY o.order_date DESC";
        return jdbcTemplate.query(sql, orderRowMapper, patientId);
    }

    @Override
    public int countOrders() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM lab_orders", Integer.class);
        return count != null ? count : 0;
    }

    @Override
    public int countPendingOrders() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM lab_orders WHERE status = 'PENDING'", Integer.class);
        return count != null ? count : 0;
    }
}

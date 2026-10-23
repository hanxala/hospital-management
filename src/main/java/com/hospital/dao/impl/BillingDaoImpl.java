package com.hospital.dao.impl;

import com.hospital.dao.BillingDao;
import com.hospital.model.Bill;
import com.hospital.model.BillItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
public class BillingDaoImpl implements BillingDao {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public BillingDaoImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private final RowMapper<Bill> billRowMapper = (rs, rowNum) -> {
        Bill b = new Bill();
        b.setId(rs.getLong("id"));
        b.setBillNumber(rs.getString("bill_number"));
        b.setPatientId(rs.getLong("patient_id"));
        b.setConsultationCharges(rs.getBigDecimal("consultation_charges"));
        b.setLabCharges(rs.getBigDecimal("lab_charges"));
        b.setRoomCharges(rs.getBigDecimal("room_charges"));
        b.setPharmacyCharges(rs.getBigDecimal("pharmacy_charges"));
        b.setOtherCharges(rs.getBigDecimal("other_charges"));
        b.setSubtotal(rs.getBigDecimal("subtotal"));
        b.setDiscountPercentage(rs.getBigDecimal("discount_percentage"));
        b.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        b.setTaxPercentage(rs.getBigDecimal("tax_percentage"));
        b.setTaxAmount(rs.getBigDecimal("tax_amount"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setPaidAmount(rs.getBigDecimal("paid_amount"));
        b.setBalanceAmount(rs.getBigDecimal("balance_amount"));
        b.setPaymentStatus(rs.getString("payment_status"));
        b.setPaymentMode(rs.getString("payment_mode"));
        b.setBillingDate(rs.getTimestamp("billing_date"));
        b.setRemarks(rs.getString("remarks"));

        b.setPatientName(rs.getString("patient_name"));
        b.setPatientUhid(rs.getString("patient_uhid"));
        b.setPatientPhone(rs.getString("patient_phone"));
        b.setPatientEmail(rs.getString("patient_email"));
        b.setPatientAddress(rs.getString("patient_address"));
        return b;
    };

    private final RowMapper<BillItem> itemRowMapper = (rs, rowNum) -> new BillItem(
            rs.getLong("id"),
            rs.getLong("bill_id"),
            rs.getString("item_type"),
            rs.getString("item_description"),
            rs.getBigDecimal("unit_price"),
            rs.getInt("quantity"),
            rs.getBigDecimal("total_price")
    );

    private static final String BILL_BASE_SELECT =
            "SELECT b.*, " +
            "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.patient_uhid, " +
            "p.phone AS patient_phone, p.email AS patient_email, p.address AS patient_address " +
            "FROM bills b " +
            "JOIN patients p ON b.patient_id = p.id ";

    @Override
    public Long saveBill(Bill bill) {
        String sql = "INSERT INTO bills (bill_number, patient_id, consultation_charges, lab_charges, room_charges, " +
                "pharmacy_charges, other_charges, subtotal, discount_percentage, discount_amount, tax_percentage, " +
                "tax_amount, total_amount, paid_amount, balance_amount, payment_status, payment_mode, billing_date, remarks) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        Timestamp now = bill.getBillingDate() != null ? bill.getBillingDate() : new Timestamp(System.currentTimeMillis());

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, new String[]{"id"});
            ps.setString(1, bill.getBillNumber());
            ps.setLong(2, bill.getPatientId());
            ps.setBigDecimal(3, bill.getConsultationCharges());
            ps.setBigDecimal(4, bill.getLabCharges());
            ps.setBigDecimal(5, bill.getRoomCharges());
            ps.setBigDecimal(6, bill.getPharmacyCharges());
            ps.setBigDecimal(7, bill.getOtherCharges());
            ps.setBigDecimal(8, bill.getSubtotal());
            ps.setBigDecimal(9, bill.getDiscountPercentage());
            ps.setBigDecimal(10, bill.getDiscountAmount());
            ps.setBigDecimal(11, bill.getTaxPercentage());
            ps.setBigDecimal(12, bill.getTaxAmount());
            ps.setBigDecimal(13, bill.getTotalAmount());
            ps.setBigDecimal(14, bill.getPaidAmount());
            ps.setBigDecimal(15, bill.getBalanceAmount());
            ps.setString(16, bill.getPaymentStatus());
            ps.setString(17, bill.getPaymentMode());
            ps.setTimestamp(18, now);
            ps.setString(19, bill.getRemarks());
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
    public void saveBillItems(List<BillItem> items) {
        String sql = "INSERT INTO bill_items (bill_id, item_type, item_description, unit_price, quantity, total_price) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.batchUpdate(sql, items, items.size(), (ps, item) -> {
            ps.setLong(1, item.getBillId());
            ps.setString(2, item.getItemType());
            ps.setString(3, item.getItemDescription());
            ps.setBigDecimal(4, item.getUnitPrice());
            ps.setInt(5, item.getQuantity() != null ? item.getQuantity() : 1);
            ps.setBigDecimal(6, item.getTotalPrice());
        });
    }

    @Override
    public int updatePayment(Long billId, BigDecimal paidAmount, BigDecimal balanceAmount, String paymentStatus, String paymentMode, String remarks) {
        String sql = "UPDATE bills SET paid_amount = ?, balance_amount = ?, payment_status = ?, payment_mode = ?, remarks = ? WHERE id = ?";
        return jdbcTemplate.update(sql, paidAmount, balanceAmount, paymentStatus, paymentMode, remarks, billId);
    }

    @Override
    public Optional<Bill> findBillById(Long id) {
        String sql = BILL_BASE_SELECT + "WHERE b.id = ?";
        try {
            Bill b = jdbcTemplate.queryForObject(sql, billRowMapper, id);
            if (b != null) {
                b.setItems(findItemsByBillId(b.getId()));
            }
            return Optional.ofNullable(b);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<Bill> findBillByNumber(String billNumber) {
        String sql = BILL_BASE_SELECT + "WHERE UPPER(b.bill_number) = UPPER(?)";
        try {
            Bill b = jdbcTemplate.queryForObject(sql, billRowMapper, billNumber);
            if (b != null) {
                b.setItems(findItemsByBillId(b.getId()));
            }
            return Optional.ofNullable(b);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Bill> findAllBills() {
        String sql = BILL_BASE_SELECT + "ORDER BY b.billing_date DESC";
        return jdbcTemplate.query(sql, billRowMapper);
    }

    @Override
    public List<Bill> findBillsByPatientId(Long patientId) {
        String sql = BILL_BASE_SELECT + "WHERE b.patient_id = ? ORDER BY b.billing_date DESC";
        return jdbcTemplate.query(sql, billRowMapper, patientId);
    }

    @Override
    public List<BillItem> findItemsByBillId(Long billId) {
        String sql = "SELECT * FROM bill_items WHERE bill_id = ? ORDER BY id ASC";
        return jdbcTemplate.query(sql, itemRowMapper, billId);
    }

    @Override
    public int countBills() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM bills", Integer.class);
        return count != null ? count : 0;
    }

    @Override
    public int countUnpaidBills() {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM bills WHERE payment_status <> 'PAID'", Integer.class);
        return count != null ? count : 0;
    }

    @Override
    public BigDecimal sumTotalRevenue() {
        BigDecimal total = jdbcTemplate.queryForObject("SELECT COALESCE(SUM(paid_amount), 0.00) FROM bills", BigDecimal.class);
        return total != null ? total : BigDecimal.ZERO;
    }

    @Override
    public BigDecimal sumPendingBalance() {
        BigDecimal balance = jdbcTemplate.queryForObject("SELECT COALESCE(SUM(balance_amount), 0.00) FROM bills", BigDecimal.class);
        return balance != null ? balance : BigDecimal.ZERO;
    }

    @Override
    public String generateNextBillNumber() {
        Integer count = jdbcTemplate.queryForObject("SELECT COALESCE(MAX(id), 0) FROM bills", Integer.class);
        int next = (count != null ? count : 0) + 1;
        String year = new SimpleDateFormat("yyyy").format(new Date());
        return String.format("BILL-%s-%04d", year, next);
    }
}

package com.hospital.model;

import java.math.BigDecimal;

public class BillItem {
    private Long id;
    private Long billId;
    private String itemType;
    private String itemDescription;
    private BigDecimal unitPrice;
    private Integer quantity;
    private BigDecimal totalPrice;

    public BillItem() {
    }

    public BillItem(Long id, Long billId, String itemType, String itemDescription, BigDecimal unitPrice,
                    Integer quantity, BigDecimal totalPrice) {
        this.id = id;
        this.billId = billId;
        this.itemType = itemType;
        this.itemDescription = itemDescription;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

    public BillItem(Long billId, String itemType, String itemDescription, BigDecimal unitPrice,
                    Integer quantity, BigDecimal totalPrice) {
        this.billId = billId;
        this.itemType = itemType;
        this.itemDescription = itemDescription;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

    public BillItem(String itemType, String itemDescription, BigDecimal unitPrice, Integer quantity, BigDecimal totalPrice) {
        this.itemType = itemType;
        this.itemDescription = itemDescription;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getBillId() {
        return billId;
    }

    public void setBillId(Long billId) {
        this.billId = billId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public String getItemDescription() {
        return itemDescription;
    }

    public void setItemDescription(String itemDescription) {
        this.itemDescription = itemDescription;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}

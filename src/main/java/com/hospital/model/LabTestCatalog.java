package com.hospital.model;

import java.math.BigDecimal;

public class LabTestCatalog {
    private Long id;
    private String testCode;
    private String testName;
    private String category;
    private BigDecimal standardFee;
    private String description;

    public LabTestCatalog() {
    }

    public LabTestCatalog(Long id, String testCode, String testName, String category, BigDecimal standardFee,
                          String description) {
        this.id = id;
        this.testCode = testCode;
        this.testName = testName;
        this.category = category;
        this.standardFee = standardFee;
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTestCode() {
        return testCode;
    }

    public void setTestCode(String testCode) {
        this.testCode = testCode;
    }

    public String getTestName() {
        return testName;
    }

    public void setTestName(String testName) {
        this.testName = testName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public BigDecimal getStandardFee() {
        return standardFee;
    }

    public void setStandardFee(BigDecimal standardFee) {
        this.standardFee = standardFee;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

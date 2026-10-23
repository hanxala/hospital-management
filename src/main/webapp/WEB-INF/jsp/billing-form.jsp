<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Generate Patient Bill - LifeCare Hospital" />
<c:set var="activePage" value="billing" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="fa-solid fa-file-invoice-dollar text-primary me-2"></i>Generate Comprehensive Hospital Invoice
                </h3>
                <p class="text-muted mb-0">Review itemized consultation and lab charges, adjust discounts and taxes, and process initial payment.</p>
            </div>
            <a href="${pageContext.request.contextPath}/billing" class="btn btn-outline-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Invoices
            </a>
        </div>

        <form action="${pageContext.request.contextPath}/billing/generate" method="post" id="billingForm">
            <input type="hidden" name="patientId" value="${bill.patientId}">

            <div class="row g-4">
                <!-- Patient Demographics Card -->
                <div class="col-lg-4">
                    <div class="card card-custom p-3 mb-4 border-primary">
                        <h6 class="fw-bold text-primary mb-3">
                            <i class="fa-solid fa-user-circle me-1"></i> Patient Information
                        </h6>
                        <table class="table table-sm table-borderless mb-0" style="font-size: 0.9rem;">
                            <tr>
                                <td class="text-muted">UHID:</td>
                                <td class="fw-bold text-primary">${bill.patientUhid}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">Name:</td>
                                <td class="fw-bold text-dark">${bill.patientName}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">Contact:</td>
                                <td>${bill.patientPhone}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">Email:</td>
                                <td>${bill.patientEmail != null ? bill.patientEmail : 'N/A'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">Address:</td>
                                <td style="font-size: 0.8rem;">${bill.patientAddress != null ? bill.patientAddress : 'N/A'}</td>
                            </tr>
                        </table>
                    </div>

                    <div class="card card-custom p-3">
                        <h6 class="fw-bold text-dark mb-3">
                            <i class="fa-solid fa-info-circle text-primary me-1"></i> Invoice Meta
                        </h6>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Invoice Number</label>
                            <input type="text" name="billNumber" class="form-control bg-light"
                                   value="${bill.billNumber}" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Payment Mode</label>
                            <select name="paymentMode" class="form-select">
                                <option value="CASH" selected>Cash Payment</option>
                                <option value="UPI">UPI / QR (GooglePay, PhonePe, Paytm)</option>
                                <option value="CARD">Credit / Debit Card</option>
                                <option value="NET_BANKING">Net Banking / NEFT</option>
                                <option value="INSURANCE">TPA / Health Insurance Claim</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Remarks / Billing Notes</label>
                            <textarea name="remarks" class="form-control" rows="2"
                                      placeholder="e.g. Consultation and diagnostic workup bill"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Itemized Breakdown & Charges Form -->
                <div class="col-lg-8">
                    <!-- Itemized List Table -->
                    <div class="card card-custom mb-4">
                        <div class="card-header bg-transparent py-3">
                            <span class="fw-bold text-dark">
                                <i class="fa-solid fa-list-check text-primary me-1"></i> Auto-Aggregated Clinical Items (${bill.items.size()})
                            </span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-sm table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Type</th>
                                            <th>Description</th>
                                            <th class="text-end">Unit Price</th>
                                            <th class="text-center">Qty</th>
                                            <th class="text-end">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${bill.items}">
                                            <tr>
                                                <td>
                                                    <span class="badge ${item.itemType == 'CONSULTATION' ? 'bg-primary-subtle text-primary' : (item.itemType == 'LAB_TEST' ? 'bg-info-subtle text-info' : 'bg-secondary-subtle text-secondary')}">
                                                        ${item.itemType}
                                                    </span>
                                                </td>
                                                <td>${item.itemDescription}</td>
                                                <td class="text-end">₹<fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2"/></td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-end fw-semibold">₹<fmt:formatNumber value="${item.totalPrice}" minFractionDigits="2"/></td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty bill.items}">
                                            <tr>
                                                <td colspan="5" class="text-center py-3 text-muted">No unbilled consultations or lab orders found. You can manually enter charges below.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Financial Inputs & Live Computation Card -->
                    <div class="card card-custom p-4">
                        <h6 class="fw-bold text-dark mb-3">
                            <i class="fa-solid fa-calculator text-primary me-1"></i> Financial Calculations & Settlement
                        </h6>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Doctor Consultation Charges (₹)</label>
                                <input type="number" step="0.01" name="consultationCharges" id="consultationCharges"
                                       class="form-control calc-input" value="${bill.consultationCharges}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Laboratory Investigation Charges (₹)</label>
                                <input type="number" step="0.01" name="labCharges" id="labCharges"
                                       class="form-control calc-input" value="${bill.labCharges}">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Room / Bed Charges (₹)</label>
                                <input type="number" step="0.01" name="roomCharges" id="roomCharges"
                                       class="form-control calc-input" value="0.00">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Pharmacy / Meds Charges (₹)</label>
                                <input type="number" step="0.01" name="pharmacyCharges" id="pharmacyCharges"
                                       class="form-control calc-input" value="0.00">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Hospital Service / Misc Charges (₹)</label>
                                <input type="number" step="0.01" name="otherCharges" id="otherCharges"
                                       class="form-control calc-input" value="${bill.otherCharges}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Discount (%)</label>
                                <input type="number" step="0.01" min="0" max="100" name="discountPercentage"
                                       id="discountPercentage" class="form-control calc-input" value="0.00">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Tax / GST (%)</label>
                                <input type="number" step="0.01" min="0" max="100" name="taxPercentage"
                                       id="taxPercentage" class="form-control calc-input" value="5.00">
                            </div>
                        </div>

                        <!-- Summary Calculation Card -->
                        <div class="bg-light p-3 rounded mt-4 border">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted">Subtotal:</span>
                                        <span class="fw-bold" id="displaySubtotal">₹0.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted">Discount Applied:</span>
                                        <span class="text-danger fw-semibold" id="displayDiscount">-₹0.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted">GST Tax (5%):</span>
                                        <span class="text-dark fw-semibold" id="displayTax">+₹0.00</span>
                                    </div>
                                    <div class="d-flex justify-content-between pt-2 border-top">
                                        <span class="fw-bold fs-6 text-dark">Grand Total Payable:</span>
                                        <span class="fw-bold fs-5 text-primary" id="displayGrandTotal">₹0.00</span>
                                    </div>
                                </div>

                                <div class="col-md-6 border-start ps-md-4 mt-3 mt-md-0">
                                    <label class="form-label fw-bold text-success">Amount Received Now (₹)</label>
                                    <div class="input-group mb-2">
                                        <span class="input-group-text bg-success-subtle text-success fw-bold">₹</span>
                                        <input type="number" step="0.01" name="paidAmount" id="paidAmount"
                                               class="form-control form-control-lg fw-bold text-success calc-input" value="0.00">
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span class="text-muted">Remaining Balance Due:</span>
                                        <span class="fw-bold fs-6 text-danger" id="displayBalance">₹0.00</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted small">
                                <i class="fa-solid fa-shield-halved text-warning me-1"></i>
                                This billing action will trigger Spring AOP <code>BillingAuditAspect</code> and monitor execution times.
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm">
                                <i class="fa-solid fa-file-invoice me-1"></i> Generate & Issue Invoice
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
function calculateTotals() {
    var consult = parseFloat(document.getElementById("consultationCharges").value) || 0;
    var lab = parseFloat(document.getElementById("labCharges").value) || 0;
    var room = parseFloat(document.getElementById("roomCharges").value) || 0;
    var pharmacy = parseFloat(document.getElementById("pharmacyCharges").value) || 0;
    var other = parseFloat(document.getElementById("otherCharges").value) || 0;

    var subtotal = consult + lab + room + pharmacy + other;

    var discPct = parseFloat(document.getElementById("discountPercentage").value) || 0;
    var discAmt = (subtotal * discPct) / 100;

    var taxable = subtotal - discAmt;
    var taxPct = parseFloat(document.getElementById("taxPercentage").value) || 0;
    var taxAmt = (taxable * taxPct) / 100;

    var grandTotal = taxable + taxAmt;

    var paid = parseFloat(document.getElementById("paidAmount").value) || 0;
    var balance = grandTotal - paid;
    if (balance < 0) balance = 0;

    document.getElementById("displaySubtotal").innerText = "₹" + subtotal.toFixed(2);
    document.getElementById("displayDiscount").innerText = "-₹" + discAmt.toFixed(2);
    document.getElementById("displayTax").innerText = "+₹" + taxAmt.toFixed(2);
    document.getElementById("displayGrandTotal").innerText = "₹" + grandTotal.toFixed(2);
    document.getElementById("displayBalance").innerText = "₹" + balance.toFixed(2);
}

// Attach listeners to all calc-inputs
document.querySelectorAll(".calc-input").forEach(function(input) {
    input.addEventListener("input", calculateTotals);
});

// Run initial calculation on load
window.addEventListener("DOMContentLoaded", calculateTotals);
</script>

<jsp:include page="common/footer.jsp" />

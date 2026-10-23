<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Invoice ${bill.billNumber} - LifeCare Hospital" />
<c:set var="activePage" value="billing" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container py-4">

        <!-- Top Actions Bar -->
        <div class="d-flex justify-content-between align-items-center mb-4 no-print">
            <a href="${pageContext.request.contextPath}/billing" class="btn btn-outline-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Invoices
            </a>
            <div class="d-flex gap-2">
                <c:if test="${bill.balanceAmount > 0}">
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#paymentModal">
                        <i class="fa-solid fa-credit-card me-1"></i> Record Payment Settlement
                    </button>
                </c:if>
                <button type="button" class="btn btn-primary" onclick="window.print()">
                    <i class="fa-solid fa-print me-1"></i> Print Tax Invoice
                </button>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show no-print mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Printable Invoice Sheet -->
        <div class="card card-custom p-4 p-md-5 bg-white shadow-sm" id="printableInvoice">
            <!-- Hospital Header -->
            <div class="row align-items-center pb-4 mb-4 border-bottom">
                <div class="col-sm-7">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-primary text-white p-3 rounded-circle d-flex align-items-center justify-content-center" style="width: 58px; height: 58px;">
                            <i class="fa-solid fa-hospital-user fs-2"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold text-dark mb-0">LIFECARE HOSPITAL &amp; RESEARCH CENTER</h3>
                            <div class="text-muted small">NABH Accredited Multi-Speciality Tertiary Care Hospital</div>
                            <div class="text-secondary small">Plot 104, Healthcare Avenue, Medical City • Tel: +91 (022) 2855-4000</div>
                            <div class="text-secondary small">GSTIN: 27AABCL1234F1Z8 • Reg No: HOSP-MH-9942</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-5 text-sm-end mt-3 mt-sm-0">
                    <h4 class="fw-bold text-primary mb-1">FINAL TAX INVOICE</h4>
                    <div class="fw-bold text-dark fs-5">${bill.billNumber}</div>
                    <div class="text-muted small">
                        <strong>Invoice Date:</strong> <fmt:formatDate value="${bill.billingDate}" pattern="dd-MMM-yyyy, HH:mm" />
                    </div>
                    <div class="mt-2">
                        <c:choose>
                            <c:when test="${bill.paymentStatus == 'PAID'}">
                                <span class="badge badge-status-paid px-3 py-2 fs-6 border border-success">
                                    <i class="fa-solid fa-circle-check me-1"></i> FULLY PAID
                                </span>
                            </c:when>
                            <c:when test="${bill.paymentStatus == 'PARTIAL'}">
                                <span class="badge badge-status-partial px-3 py-2 fs-6 border border-warning">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i> PARTIALLY PAID
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-status-unpaid px-3 py-2 fs-6 border border-danger">
                                    <i class="fa-solid fa-circle-exclamation me-1"></i> PAYMENT DUE
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Billed To & Patient Profile -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6">
                    <div class="p-3 bg-light rounded border h-100">
                        <small class="text-uppercase text-muted fw-bold d-block mb-1" style="font-size: 0.72rem;">Billed Patient Information</small>
                        <h5 class="fw-bold text-dark mb-1">${bill.patientName}</h5>
                        <div class="text-secondary small">
                            <strong>UHID:</strong> <span class="text-primary fw-semibold">${bill.patientUhid}</span>
                        </div>
                        <div class="text-secondary small">
                            <strong>Phone:</strong> ${bill.patientPhone}
                        </div>
                        <div class="text-secondary small">
                            <strong>Address:</strong> ${bill.patientAddress != null ? bill.patientAddress : 'Outpatient Dept'}
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="p-3 bg-light rounded border h-100">
                        <small class="text-uppercase text-muted fw-bold d-block mb-1" style="font-size: 0.72rem;">Billing & Settlement Details</small>
                        <div class="text-secondary small mb-1">
                            <strong>Payment Mode:</strong> <span class="badge bg-secondary">${bill.paymentMode}</span>
                        </div>
                        <div class="text-secondary small mb-1">
                            <strong>Remarks:</strong> ${bill.remarks != null ? bill.remarks : 'Routine clinical billing'}
                        </div>
                        <div class="text-secondary small">
                            <strong>Audit Verification:</strong> Verified by Spring AOP BillingAuditAspect
                        </div>
                    </div>
                </div>
            </div>

            <!-- Itemized Table -->
            <div class="table-responsive mb-4">
                <table class="table table-bordered align-middle">
                    <thead class="table-light text-uppercase" style="font-size: 0.8rem;">
                        <tr>
                            <th style="width: 50px;" class="text-center">#</th>
                            <th style="width: 150px;">Category</th>
                            <th>Description of Clinical Service / Investigation</th>
                            <th class="text-end" style="width: 130px;">Rate (₹)</th>
                            <th class="text-center" style="width: 70px;">Qty</th>
                            <th class="text-end" style="width: 140px;">Amount (₹)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${bill.items}" varStatus="status">
                            <tr>
                                <td class="text-center text-muted">${status.count}</td>
                                <td>
                                    <span class="badge ${item.itemType == 'CONSULTATION' ? 'bg-primary-subtle text-primary' : (item.itemType == 'LAB_TEST' ? 'bg-info-subtle text-info' : 'bg-secondary-subtle text-secondary')}">
                                        ${item.itemType}
                                    </span>
                                </td>
                                <td class="fw-medium text-dark">${item.itemDescription}</td>
                                <td class="text-end">₹<fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2"/></td>
                                <td class="text-center">${item.quantity}</td>
                                <td class="text-end fw-semibold">₹<fmt:formatNumber value="${item.totalPrice}" minFractionDigits="2"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Financial Calculation Summary -->
            <div class="row justify-content-end mb-4">
                <div class="col-md-5">
                    <table class="table table-sm table-borderless">
                        <tr>
                            <td class="text-muted">Item Subtotal:</td>
                            <td class="text-end fw-semibold">₹<fmt:formatNumber value="${bill.subtotal}" minFractionDigits="2"/></td>
                        </tr>
                        <c:if test="${bill.discountAmount > 0}">
                            <tr>
                                <td class="text-muted">Discount (${bill.discountPercentage}%):</td>
                                <td class="text-end text-danger fw-semibold">-₹<fmt:formatNumber value="${bill.discountAmount}" minFractionDigits="2"/></td>
                            </tr>
                        </c:if>
                        <tr>
                            <td class="text-muted">Healthcare Tax / GST (${bill.taxPercentage}%):</td>
                            <td class="text-end text-dark fw-semibold">+₹<fmt:formatNumber value="${bill.taxAmount}" minFractionDigits="2"/></td>
                        </tr>
                        <tr class="border-top border-dark">
                            <td class="fw-bold fs-5 text-dark">Total Net Payable:</td>
                            <td class="text-end fw-bold fs-5 text-primary">₹<fmt:formatNumber value="${bill.totalAmount}" minFractionDigits="2"/></td>
                        </tr>
                        <tr>
                            <td class="text-success fw-bold">Amount Paid:</td>
                            <td class="text-end text-success fw-bold">₹<fmt:formatNumber value="${bill.paidAmount}" minFractionDigits="2"/></td>
                        </tr>
                        <tr class="border-top">
                            <td class="text-danger fw-bold">Balance Outstanding Due:</td>
                            <td class="text-end text-danger fw-bold fs-6">₹<fmt:formatNumber value="${bill.balanceAmount}" minFractionDigits="2"/></td>
                        </tr>
                    </table>
                </div>
            </div>

            <!-- Signature & Legal Footer -->
            <div class="row pt-4 mt-3 border-top text-center text-md-start">
                <div class="col-md-8 small text-muted">
                    <p class="mb-1"><strong>Terms &amp; Notice:</strong> This is a computer-generated official hospital tax invoice.</p>
                    <p class="mb-0">All charges are approved under standard schedule of tariffs. Keep this invoice for insurance claim reimbursement.</p>
                </div>
                <div class="col-md-4 text-center mt-3 mt-md-0">
                    <div style="height: 45px;"></div>
                    <div class="border-top pt-1 small fw-bold text-dark">Authorized Billing Officer</div>
                    <small class="text-muted">LifeCare Hospital Cash Office</small>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Record Payment Settlement Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/billing/pay" method="post">
                <input type="hidden" name="billId" value="${bill.id}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-cash-register text-success me-2"></i>Record Settlement Payment
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-2"><strong>Invoice:</strong> ${bill.billNumber}</p>
                    <p class="mb-2"><strong>Patient:</strong> ${bill.patientName} (${bill.patientUhid})</p>
                    <p class="mb-3 text-danger fw-bold">
                        <strong>Current Balance Due:</strong> ₹<fmt:formatNumber value="${bill.balanceAmount}" minFractionDigits="2"/>
                    </p>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Payment Amount to Receive (₹) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" name="paymentAmount" class="form-control form-control-lg"
                               value="${bill.balanceAmount}" max="${bill.balanceAmount}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Payment Mode <span class="text-danger">*</span></label>
                        <select name="paymentMode" class="form-select" required>
                            <option value="CASH">Cash</option>
                            <option value="UPI" selected>UPI / QR Scan</option>
                            <option value="CARD">Credit / Debit Card</option>
                            <option value="NET_BANKING">Net Banking</option>
                            <option value="INSURANCE">Insurance TPA Settlement</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Transaction Reference / Remarks</label>
                        <input type="text" name="remarks" class="form-control" placeholder="UPI Ref / Cheque No / Cash receipt ref">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">
                        <i class="fa-solid fa-check me-1"></i> Confirm & Settle Payment
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

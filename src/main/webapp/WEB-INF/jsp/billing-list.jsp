<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Hospital Billing & Invoices - LifeCare Hospital" />
<c:set var="activePage" value="billing" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid px-4 py-4">
        <!-- Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1 text-dark">
                    <i class="fa-solid fa-file-invoice-dollar text-primary me-2"></i>Hospital Billing & Invoicing Desk
                </h3>
                <p class="text-muted mb-0">Consolidate doctor consultation fees, diagnostic lab tests, room charges, and process payments.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/billing/new" class="btn btn-success shadow-sm">
                    <i class="fa-solid fa-receipt me-1"></i> Generate New Patient Bill
                </a>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Financial KPI Cards -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card card-custom p-3 border-start border-4 border-primary">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Total Invoices Raised</span>
                            <h3 class="fw-bold mb-0 text-dark">${stats.totalBills}</h3>
                        </div>
                        <div class="p-3 bg-primary-subtle text-primary rounded-circle">
                            <i class="fa-solid fa-file-lines fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-custom p-3 border-start border-4 border-success">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Revenue Realized</span>
                            <h3 class="fw-bold mb-0 text-success">
                                ₹<fmt:formatNumber value="${stats.totalRevenue}" minFractionDigits="2"/>
                            </h3>
                        </div>
                        <div class="p-3 bg-success-subtle text-success rounded-circle">
                            <i class="fa-solid fa-sack-dollar fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-custom p-3 border-start border-4 border-warning">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Outstanding Dues</span>
                            <h3 class="fw-bold mb-0 text-warning">
                                ₹<fmt:formatNumber value="${stats.pendingBalance}" minFractionDigits="2"/>
                            </h3>
                        </div>
                        <div class="p-3 bg-warning-subtle text-warning rounded-circle">
                            <i class="fa-solid fa-hand-holding-dollar fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Invoices Table -->
        <div class="card card-custom">
            <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark">All Billing Invoices (${bills.size()})</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Invoice No.</th>
                                <th>Patient Name & UHID</th>
                                <th>Billing Date</th>
                                <th class="text-end">Subtotal</th>
                                <th class="text-end">Tax / Disc</th>
                                <th class="text-end">Grand Total</th>
                                <th class="text-end">Paid Amount</th>
                                <th class="text-end">Balance Due</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bills}">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/billing/invoice/${b.billNumber}" class="fw-bold text-primary text-decoration-none">
                                            ${b.billNumber}
                                        </a>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patients/view/${b.patientId}" class="fw-bold text-dark text-decoration-none">
                                            ${b.patientName}
                                        </a>
                                        <small class="text-muted d-block">${b.patientUhid}</small>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${b.billingDate}" pattern="dd-MMM-yyyy, HH:mm" />
                                    </td>
                                    <td class="text-end">
                                        ₹<fmt:formatNumber value="${b.subtotal}" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-end text-muted" style="font-size: 0.85rem;">
                                        +₹<fmt:formatNumber value="${b.taxAmount}" minFractionDigits="2"/> /
                                        -₹<fmt:formatNumber value="${b.discountAmount}" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-end fw-bold text-dark">
                                        ₹<fmt:formatNumber value="${b.totalAmount}" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-end fw-bold text-success">
                                        ₹<fmt:formatNumber value="${b.paidAmount}" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-end fw-bold text-danger">
                                        ₹<fmt:formatNumber value="${b.balanceAmount}" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${b.paymentStatus == 'PAID'}">
                                                <span class="badge badge-status-paid px-2 py-1">PAID</span>
                                            </c:when>
                                            <c:when test="${b.paymentStatus == 'PARTIAL'}">
                                                <span class="badge badge-status-partial px-2 py-1">PARTIAL</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-status-unpaid px-2 py-1">UNPAID</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/billing/invoice/${b.billNumber}" class="btn btn-sm btn-outline-primary" title="View & Print Tax Invoice">
                                            <i class="fa-solid fa-receipt me-1"></i> Invoice
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty bills}">
                                <tr>
                                    <td colspan="10" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-receipt fs-2 d-block mb-2 text-secondary"></i>
                                        No hospital billing records created yet.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="common/footer.jsp" />
